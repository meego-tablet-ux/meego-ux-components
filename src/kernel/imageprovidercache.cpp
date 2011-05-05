#include <QDebug>
#include <QFile>
#include <QImageReader>

#include "imageprovidercache.h"

ImageProviderCache::ImageProviderCache(  uint maxImages, uint sizeInMb, QObject *parent ) :
    QObject(parent),
    m_bMemoryReady( false ),
    m_key( QString::fromLatin1("Meego\\Ux\\ImageProviderCache") ),
    m_size( sizeInMb ),
    m_images( maxImages ),
    m_filename( QString("statistics") )
{    
    m_emptyImage.fill(Qt::red);
    m_emptyPixmap.fill(Qt::red);

    attachSharedMemory();
}
ImageProviderCache::~ImageProviderCache()
{
    detachSharedMemory();
}

QImage ImageProviderCache::requestImage( const QString& id, QSize* size, const QSize& requestedSize )
{  
    QImage image;

    if( existImage ( id , requestedSize ) ) {

        image = loadImageFromMemory( id, requestedSize );

        if( !requestedSize.isEmpty() && image.size() != requestedSize ) {

            QImage resizedImage = image.scaled( requestedSize );

            if( isResizedImageWorthCaching( id ) ) {

                qDebug() << "adding resized image to shared memory";
                addImageToMemory( id,  resizedImage );

            }
        }

    } else if( existSciFile( id ) ) {

        ImageReference imageReference = loadSciFile( id );

        QImageReader reader;
        reader.setFileName( imageReference.id() );
        if ( reader.canRead() ) {

            image = reader.read();

            qDebug() << id << " exists - added to shared memory ";
            addImageToMemory( id, image, imageReference );

            if( !requestedSize.isEmpty() && image.size() != requestedSize ) {

                reader.setScaledSize( requestedSize );

                image = reader.read();

                if( isResizedImageWorthCaching( id ) ) {
                    qDebug() << "adding resized image to shared memory";
                    addImageToMemory( id, image );
                }
            }

        } else {

            qWarning() << "Image " << id << " does not exist";
            image = m_emptyImage;
            if( !requestedSize.isEmpty() )
                image.scaled( requestedSize );
        }

    } else {

        QImageReader reader;
        reader.setFileName( QString("%1%2").arg(id, QString::fromLatin1( ".png" ) ) );
        if ( reader.canRead() ) {

            image = reader.read();

            qDebug() << id << " exists - added to shared memory ";
            addImageToMemory( id, image );

            if(  !requestedSize.isEmpty() && image.size() != requestedSize ) {

                reader.setScaledSize( requestedSize );

                image = reader.read();

                if( isResizedImageWorthCaching( id ) ) {
                    qDebug() << "adding resized image to shared memory";
                    addImageToMemory( id, image );
                }
            }

        } else {

            qWarning() << "Image " << id << " does not exist";
            image = m_emptyImage;
            if( !requestedSize.isEmpty() )
                image.scaled( requestedSize );
        }        
    }

    if( size ) {
        size->setHeight( image.height() );
        size->setWidth( image.width() );
    }
    return image;

}

QPixmap ImageProviderCache::requestPixmap( const QString& id, QSize* size, const QSize& requestedSize )
{
    QPixmap pixmap;

    if( existPixmap( id, requestedSize ) ) {

        pixmap = loadPixmapFromXServer( id, size, requestedSize );

   } else {

        QImage image = requestImage( id, size, requestedSize );
        pixmap = QPixmap::fromImage( image );

        addPixmapToCache( pixmap );

    }

    if( size ) {
        size->setHeight( pixmap.height() );
        size->setWidth( pixmap.width() );
    }

    return pixmap;
}

bool ImageProviderCache::existImage( const QString & id, const QSize& size )
{
    if( m_bMemoryReady ){

        readMemoryInfo();

        if( size.isEmpty() ) {

            for( int i = 0; i < m_imageTable.size(); i++ ) {
                if( m_imageTable[i].equal( id ) )
                    return true;
            }

        } else {

            for( int i = 0; i < m_imageTable.size(); i++ ) {
                if( m_imageTable[i].equal( id, size ) )
                    return true;
            }

        }
    }
    return false;
}

bool ImageProviderCache::existPixmap( const QString & id, const QSize& size )
{
    if( m_bMemoryReady ){

        readMemoryInfo();

        if( size.isEmpty() ) {

            for( int i = 0; i < m_pixmapTable.size(); i++ ) {
                if( m_pixmapTable[i].equal( id ) )
                    return true;
            }

        } else {

            for( int i = 0; i < m_pixmapTable.size(); i++ ) {
                if( m_pixmapTable[i].equal( id, size ) )
                    return true;
            }

        }
    }
    return false;
}

bool ImageProviderCache::existSciFile( const QString & id )
{
    QString filename = QString("%1%2").arg( id, QString::fromLatin1(".sci") );
    if( QFile::exists( filename ) )
        return true;
    return false;
}

void ImageProviderCache::addImageToMemory( const QString& id, const QImage& image, const ImageReference& reference )
{
    if( m_bMemoryReady ) {

        readMemoryInfo();

        m_memory.lock();

        QBuffer buffer;
        buffer.open( QBuffer::ReadWrite );
        QDataStream out(&buffer);
        out << image;
        uint size = buffer.size();

        ImageReference imageReference( reference );
        if(  m_memoryInfo.dataEnd + size < m_memoryInfo.cacheEnd )
        {            
            imageReference.setId( id );
            imageReference.refCount = 1;
            imageReference.width = image.width();
            imageReference.height = image.height();
            imageReference.memoryPosition = m_memoryInfo.dataEnd;
            imageReference.memorySize = size;

            m_imageTable.append( imageReference );

            qDebug() << "Add Image to shared memory: " << imageReference.Id();
            qDebug() << "TableSize: " << m_imageTable.size();

            char *to = (char*)imageReference.memoryPosition;
            const char *from = buffer.data().data();

            memcpy( to, from, imageReference.memorySize );

            m_memoryInfo.dataEnd += size;
            m_lastUpdate = m_memoryInfo.incUpdate();

        } else {
            qDebug() << " cache is full ";
        }

        buffer.close();
        m_memory.unlock();

        saveMemoryInfo();
    }
}

void ImageProviderCache::addPixMapToCache( const QString& id, const QPixmap& pixmap, const PixmapReference& reference )
{
    if( m_bMemoryReady ) {

        readMemoryInfo();

        m_memory.lock();

        PixmapReference pixmapReference( reference );

        pixmapReference.setId( id );
        pixmapReference.refCount = 1;
        pixmapReference.width = image.width();
        pixmapReference.height = image.height();
        pixmapReference.pixMapHandle = pixmap.x11PictureHandle();

        m_pixmapTable.append( pixmapReference );
        m_memoryInfo.pixmapCount++;
        m_lastUpdate = m_memoryInfo.incUpdate();

        saveMemoryInfo();
    }
}

ImageReference ImageProviderCache::loadSciFile( const QString& id )
{
    ImageReference reference;

    QString filename = QString("%1%2").arg( id, QString::fromLatin1(".sci") );
    QFile file( filename );
    if( file.open( QFile::ReadOnly ) ) {

        int l = -1;
        int r = -1;
        int t = -1;
        int b = -1;
        QString imgFile;

        QByteArray raw;
        while(raw = file.readLine(), !raw.isEmpty()) {
            QString line = QString::fromUtf8(raw.trimmed());
            if (line.isEmpty() || line.startsWith(QLatin1Char('#')))
                continue;

            QStringList list = line.split(QLatin1Char(':'));
            if (list.count() != 2)
                return;

            list[0] = list[0].trimmed();
            list[1] = list[1].trimmed();

            if (list[0] == QLatin1String("border.left"))
                l = list[1].toInt();
            else if (list[0] == QLatin1String("border.right"))
                r = list[1].toInt();
            else if (list[0] == QLatin1String("border.top"))
                t = list[1].toInt();
            else if (list[0] == QLatin1String("border.bottom"))
                b = list[1].toInt();
            else if (list[0] == QLatin1String("source"))
                imgFile = list[1];
            else if (list[0] == QLatin1String("horizontalTileRule"))
                _h = stringToRule(list[1]);
            else if (list[0] == QLatin1String("verticalTileRule"))
                _v = stringToRule(list[1]);
        }

        if (l < 0 || r < 0 || t < 0 || b < 0 )
            return;

        reference.borderBottom = b;
        reference.borderTop = t;
        reference.borderLeft = l;
        reference.borderRight = r;
        reference.setId( imgFile );
    }

    return reference;
}

QPixmap ImageProviderCache::loadPixmapFromXServer( const QString &id, const QSize& size )
{
    QPixmap pixmap;

    if( size.isEmpty() ) {

        for( int i = 0; i < m_pixmapTable.size(); i++ ) {
            if( m_pixmapTable[i].equal( id ) ) {
                pixmap = QPixmap::fromX11Pixmap( m_pixmapTable[i].pixMapHandle );
                break;
            }
        }

    } else {

        for( int i = 0; i < m_pixmapTable.size(); i++ ) {
            if( m_pixmapTable[i].equal( id , size) ) {
                pixmap = QPixmap::fromX11Pixmap( m_pixmapTable[i].pixMapHandle );
                break;
            }
        }

    }

    return pixmap;
}

QImage ImageProviderCache::loadImageFromMemory( const QString& id, const QSize& size )
{
    QImage image;

    if( m_bMemoryReady ) {

        ImageReference tableInfo;

        if( size.isEmpty() )
        {
            for( int i = 0; i < m_imageTable.size(); i++ )
            {
                if( m_imageTable[i].equalId( id ) ) {
                    m_imageTable[i].refCount++;
                    saveImageInfo( i, m_imageTable[i] );
                    tableInfo = m_imageTable[i];
                    break;
                }
            }

        } else {

            for( int i = 0; i < m_imageTable.size(); i++ )
            {
                if( m_imageTable[i].equal( id, size ) ) {
                    m_imageTable[i].refCount++;
                    saveImageInfo( i, m_imageTable[i] );
                    tableInfo = m_imageTable[i];
                    break;
                }
            }
        }

        m_memory.lock();

        QBuffer buffer;
        QDataStream in( &buffer );

        char* begin = (char*)tableInfo.memoryPosition;
        qDebug() << "loadImageFromMemory - begin: " << tableInfo.memoryPosition << " size: " << tableInfo.memorySize;

        buffer.setData( (char*)begin,  tableInfo.memorySize );
        buffer.open(QBuffer::ReadOnly);

        in >> image;

        m_memory.unlock();

    }
    return image;
}
void ImageProviderCache::readMemoryInfo()
{
    if( m_bMemoryReady ) {

        m_memory.lock();

        // ~~~~~ memoryInfo
        QBuffer buffer;
        QDataStream in(&buffer);

        buffer.setData( (char*)m_memory.data(), m_memoryInfo.imageTableSize );
        buffer.open(QBuffer::ReadOnly);

        m_memoryInfo.loadFromStream( in );

        buffer.close();

        if( m_memoryInfo.lastUpdate != m_lastUpdate ) {

            m_lastUpdate = m_memoryInfo.lastUpdate;

            // ~~~~~ imageReferences
            buffer.setData( (char*)m_memoryInfo.imageTableBegin, m_memoryInfo.imageTableSize );
            buffer.open();
            in.setDevice( &buffer );
            ImageReference referenceTableInfo;
            for( uint i = 0; i < m_memoryInfo.imageCount; i++ )
            {
                referenceTableInfo.loadFromStream( in );

                bool bFound = false;
                for( int i; i < m_imageTable.size(); i++ )
                {
                    if( m_imageTable[i].equal( referenceTableInfo ) ) {
                        m_imageTable[i].refCount = referenceTableInfo.refCount;
                        bFound = true;
                        break;
                    }
                }
                if( !bFound ) {
                    m_imageTable.append( referenceTableInfo );
                    qDebug() << "readMemoryInfo - new Image found: " << referenceTableInfo.id()
                             << " height: " << referenceTableInfo.height
                             << " width: " << referenceTableInfo.width;
                }
            }
            buffer.close();

            // ~~~~~ pixmapReferences
            buffer.setData( (char*)m_memoryInfo.pixmapTableBegin, m_memoryInfo.pixmapTableSize );
            buffer.open();
            in.setDevice( &buffer );
            PixmapReference referenceInfo;
            for( uint i = 0; i < m_pixmapTable.pixmapCount; i++ )
            {
                referenceInfo.loadFromStream( in );

                bool bFound = false;
                for( int i; i < m_pixmapTable.size(); i++ )
                {
                    if( m_pixmapTable[i].equal( referenceTableInfo ) ) {
                        m_pixmapTable[i].refCount = referenceTableInfo.refCount;
                        bFound = true;
                        break;
                    }
                }
                if( !bFound ) {
                    m_imageTable.append( referenceTableInfo );
                    qDebug() << "readMemoryInfo - new Image found: " << referenceTableInfo.id()
                             << " height: " << referenceTableInfo.height
                             << " width: " << referenceTableInfo.width;
                }
            }
            buffer.close();
        }

        buffer.close();
        m_memory.unlock();

    }
}

void ImageProviderCache::saveMemoryInfo()
{
    if( m_bMemoryReady ) {

        m_memory.lock();

        // ~~~~~ memoryInfo
        QBuffer buffer;
        buffer.open(QBuffer::ReadWrite);
        QDataStream out(&buffer);
        int size = buffer.size();
        m_memoryInfo.saveToStream( out );
        char *to = (char*)m_memoryInfo.cacheBegin;
        const char *from = buffer.data().data();
        memcpy( to, from, size );
        buffer.close();

        // ~~~~~ imageReferences
        QBuffer imageBuffer;
        imageBuffer.open(QBuffer::ReadWrite);
        QDataStream imageOut( &imageBuffer );
        for( uint i = 0; i < m_memoryInfo.imageCount; i++ )
        {
            m_imageTable[i].saveToStream( imageOut );
        }
        size = imageBuffer.size();
        char *imageTable = (char*)m_memoryInfo.imageTableBegin;
        const char *fromImageTable = imageBuffer.data().data();
        memcpy( imageTable, fromImageTable, size );
        imageBuffer.close();

        // ~~~~~ pixmapReferences
        QBuffer pixmapBuffer;
        pixmapBuffer.open(QBuffer::ReadWrite);
        QDataStream pixmapOut( &pixmapBuffer );
        for( uint i = 0; i < m_memoryInfo.pixmapCount; i++ )
        {
            m_imageTable[i].saveToStream( pixmapOut );
        }
        size = pixmapBuffer.size();
        char *pixmapTable = (char*)m_memoryInfo.pixmapTableBegin;
        const char *fromPixmapTable = pixmapBuffer.data().data();
        memcpy( pixmapTable, fromPixmapTable, size );
        pixmapBuffer.close();

        m_memory.unlock();
    }
}

void ImageProviderCache::saveImageInfo( int position, ImageReference& refTableInfo )
{
    if( m_bMemoryReady ) {

        m_memory.lock();

        QBuffer buffer;
        buffer.open(QBuffer::ReadWrite);
        QDataStream out(&buffer);

        refTableInfo.saveToStream( out );

        int size = buffer.size();

        char *to = (char*)( m_memoryInfo.imageTableBegin + ( position * size ) );
        const char *from = buffer.data().data();
        memcpy( to, from, size );

        // no update of memoryInfo -> clients don't need that info.

        m_memory.unlock();
    }
}

void ImageProviderCache::savePixmapInfo( int position, PixmapReference& refTableInfo )
{
    if( m_bMemoryReady ) {

        m_memory.lock();

        QBuffer buffer;
        buffer.open(QBuffer::ReadWrite);
        QDataStream out(&buffer);

        refTableInfo.saveToStream( out );

        int size = buffer.size();

        char *to = (char*)( m_memoryInfo.pixmapTableBegin + ( position * size ) );
        const char *from = buffer.data().data();
        memcpy( to, from, size );

        m_memory.unlock();
    }
}

void ImageProviderCache::attachSharedMemory()
{
    m_memory.setKey( m_key );

    if( !m_memory.create( m_size * 1024 * 1024 ) ) {

        if( !m_memory.attach() ) {

            qDebug() << "Attach to shared memory failed: " << m_key;
            m_bMemoryReady = false;

        } else {

            qDebug() << "shared memory attached: " << m_key;
            m_bMemoryReady = true;
            readMemoryInfo();
            m_memoryInfo.clients++;
            saveMemoryInfo();
            bulk();
        }

    } else {

        qDebug() << "shared memory created: " << m_key;
        createShareMemory();
        m_bMemoryReady = true;
        loadPreLoadFile();

    }
}

void ImageProviderCache::detachSharedMemory()
{
    if( m_memory.isAttached() ) {

        if(m_memoryInfo.clients == 1)
            savePreLoadFile();

        m_memoryInfo.clients--;
        saveMemoryInfo();

        m_memory.detach();
        qDebug() << "shared memory detached";
    }
}

void ImageProviderCache::createShareMemory()
{
    m_memory.lock();

    QBuffer buffer;
    buffer.open(QBuffer::ReadWrite);
    QDataStream out(&buffer);

    char *to = (char*)m_memory.data();

    m_memoryInfo.incUpdate();
    m_memoryInfo.clientCount = 1;
    m_memoryInfo.cacheBegin = (uint)to;
    m_memoryInfo.cacheSize = m_memory.size();    
    m_memoryInfo.cacheEnd =  m_memoryInfo.cacheBegin + m_memoryInfo.cacheSize;
    m_memoryInfo.imageCount = 0;
    m_memoryInfo.imageMaxCount = m_images;
    m_memoryInfo.imageTableBegin = (uint)( to + sizeof( MemoryInfo ) );
    m_memoryInfo.imageTableEnd = m_memoryInfo.imageTableBegin + ( m_memoryInfo.imageMaxCount * sizeof( ImageReference ) );
    m_memoryInfo.imageTableSize = m_memoryInfo.tableEnd - m_memoryInfo.imageTableBegin;
    m_memoryInfo.pixmapCount = 0;
    m_memoryInfo.pixmapMaxCount = m_images;
    m_memoryInfo.pixmapTableBegin = m_memoryInfo.imageTableEnd;
    m_memoryInfo.pixmapTableEnd = m_memoryInfo.pixmapTableBegin + ( m_memoryInfo.imageMaxCount * sizeof( PixmapReference ) );
    m_memoryInfo.pixmapTableSize = m_memoryInfo.pixmapTableEnd - m_memoryInfo.pixmapTableBegin;
    m_memoryInfo.dataBegin = m_memoryInfo.pixmapTableEnd;
    m_memoryInfo.dataEnd = m_memoryInfo.pixmapTableEnd;
    m_memoryInfo.saveToStream( out );
    int size = buffer.size();

    ImageReference emptyReference;
    for( uint i = 0; i < m_memoryInfo.imageMaxCount ; i++ )
    {
        emptyReference.saveToStream( out );
    }

    PixmapReference pixmapReference;
    for( uint i = 0; i < m_memoryInfo.pixmapMaxCount ; i++ )
    {
        pixmapReference.saveToStream( out );
    }

    size = buffer.size();
    const char *from = buffer.data().data();
    memcpy(to, from, qMin(m_memory.size(), size));
    m_memory.unlock();

}

void ImageProviderCache::loadPreLoadFile()
{    
    QFile file( m_filename );
    if( file.open( QFile::ReadOnly ) )
    {
        QDataStream in( &file );
        QList<ImageReference> list;
        ImageReference referenceTableInfo;

        while( !in.atEnd() )
        {
            referenceTableInfo.loadFromStream( in );
            list.append( referenceTableInfo );
        }

        for( int i = 0; i < list.size(); i++ )
        {
            QSrtring id = list[i].id();
            QSize size( list[i].width, list[i].height );

            if( !existImage( id, size ) ) {
                requestImage( id, 0, size);
            }
        }

        file.close();
    }
}

void ImageProviderCache::savePreLoadFile()
{
    QFile file( m_filename );
    if( file.open( QFile::ReadWrite ) )
    {
        QDataStream out( &file );

        // save with the highest refcounts first
        QMap<uint, ImageReference> sortingMap;
        for( int i = 0; i < m_imageTable.size(); i++ )
        {
            if( m_imageTable[i].refCount > 1 )
                sortingMap.insert( m_imageTable[i].refCount,  m_imageTable[i] );
        }

        QList<ImageReference> list = sortingMap.values();
        for( int i = list.size() ; i > 0 ; i-- )
        {
            list[i-1].saveToStream( out );
        }
        file.close();

    }
}

bool ImageProviderCache::isResizedImageWorthCaching( const QString& id )
{    
    // todo find a way to determine if the picture should be cached or not.
    return true;
}

void ImageProviderCache::bulk()
{
    readMemoryInfo();

    qDebug() << "Bulk ____________________________";
    qDebug() << " lastUpdate: " << m_memoryInfo.lastUpdate;
    qDebug() << " clients: " << m_memoryInfo.clientCount;
    qDebug() << " cacheBegin: " << m_memoryInfo.cacheBegin;
    qDebug() << " cacheEnd: " << m_memoryInfo.cacheEnd;
    qDebug() << " cacheSize: " << m_memoryInfo.cacheSize;
    qDebug() << " imageCount: " << m_memoryInfo.imageCount;
    qDebug() << " imageMaxCount: " << m_memoryInfo.imageMaxCount;
    qDebug() << " imageTableBegin: " << m_memoryInfo.imageTableBegin;
    qDebug() << " imageTableEnd: " << m_memoryInfo.imageTableEnd;
    qDebug() << " imageTableSize: " << m_memoryInfo.imageTableSize;
    qDebug() << " pixmapCout: " << m_memoryInfo.pixmapCount;
    qDebug() << " pixmapMaxCount: " << m_memoryInfo.pixmapMaxCount;
    qDebug() << " pixmapTableBegin: " << m_memoryInfo.pixmapTableBegin;
    qDebug() << " pixmapTableEnd: " << m_memoryInfo.pixmapTableEnd;
    qDebug() << " pixmapTableSize: " << m_memoryInfo.pixmapTableSize;
    qDebug() << " dataBegin: " << m_memoryInfo.dataBegin;
    qDebug() << " dataEnd: " << m_memoryInfo.dataEnd;

    for( uint i = 0; i < m_memoryInfo.imageCount; i++)
    {
        qDebug() << "____________________________";
        qDebug() << i+1 << ". image: " << m_imageTable[i].id();
        qDebug() << " memoryPosition: " << m_imageTable[i].memoryPosition;
        qDebug() << " memorySize: " << m_imageTable[i].memorySize;
        qDebug() << " image width: " << m_imageTable[i].width;
        qDebug() << " image height: " << m_imageTable[i].height;
    }

    for( uint i = 0; i < m_memoryInfo.pixmapCount; i++)
    {
        qDebug() << "____________________________";
        qDebug() << i+1 << ". pixmap: " << m_pixmapTable[i].id();
        qDebug() << " image width: " << m_pixmapTable[i].width;
        qDebug() << " image height: " << m_pixmapTable[i].height;
    }

    qDebug() << "____________________________ End Bulk";
}
