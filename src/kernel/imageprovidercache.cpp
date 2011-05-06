#include <QDebug>
#include <QFile>
#include <QImageReader>

#include "imageprovidercache.h"

ImageProviderCache::ImageProviderCache( const QString ThemeName, int maxImages, int sizeInMb, QObject *parent ) :
    QObject(parent),
    m_bMemoryReady( false ),
    m_key( ThemeName ),
    m_size( sizeInMb ),
    m_images( maxImages ),
    m_filename( QString("statistics") )
{    

    calcSizes();

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

                //qDebug() << "adding resized image to shared memory";
                addImageToMemory( id,  resizedImage );

            }
        }

    } else if( existSciFile( id ) ) {

        ImageReference imageReference = loadSciFile( id );

        QImageReader reader;
        reader.setFileName( imageReference.id() );
        if ( reader.canRead() ) {

            image = reader.read();

            //qDebug() << "adding image to shared memory " << id;
            addImageToMemory( id, image, imageReference );

            if( !requestedSize.isEmpty() && image.size() != requestedSize ) {

                reader.setScaledSize( requestedSize );

                image = reader.read();

                if( isResizedImageWorthCaching( id ) ) {
                    //qDebug() << "adding resized image to shared memory";
                    addImageToMemory( id, image );
                }
            }

        } else {

            qWarning() << "Image " << id << " does not exist";
            image = m_emptyImage;
            if( !requestedSize.isEmpty() )
                image = image.scaled( requestedSize );

        }

    } else {

        QImageReader reader;
        QString filename = QString("%1%2").arg( id, QString::fromLatin1( ".png" ) );
        reader.setFileName( filename );
        //qDebug() << "check filename" << filename;
        if ( reader.canRead() ) {

            image = reader.read();

            //qDebug() << id << " exists - added to shared memory ";
            addImageToMemory( id, image );

            if(  !requestedSize.isEmpty() && image.size() != requestedSize ) {

                reader.setScaledSize( requestedSize );

                image = reader.read();

                if( isResizedImageWorthCaching( id ) ) {
                    //qDebug() << "adding resized image to shared memory";
                    addImageToMemory( id, image );
                }
            }

        } else {

            qWarning() << "Image " << id << " does not exist";
            image = m_emptyImage;
            if( !requestedSize.isEmpty() )
                image = image.scaled( requestedSize );
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

        pixmap = loadPixmapFromXServer( id, requestedSize );

        if( !requestedSize.isEmpty() && pixmap.size() != requestedSize )
        {
            pixmap = pixmap.scaled( requestedSize );
        }

    } else {

        QImage image = requestImage( id, size, requestedSize );
        pixmap = QPixmap::fromImage( image );

        addPixmapToCache( id, pixmap );

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
                if( m_imageTable[i].equal( id ) ) {
                    qDebug() << "cache hit: " << id;
                    return true;
                }
            }

        } else {

            for( int i = 0; i < m_imageTable.size(); i++ ) {
                if( m_imageTable[i].equal( id, size ) ) {
                    qDebug() << "cache hit: " << id;
                    return true;
                }
            }

        }
    }
    return false;
}

bool ImageProviderCache::existPixmap( const QString & id, const QSize& size )
{    
    // ck todo
    return false;

    if( m_bMemoryReady ){

        readMemoryInfo();

        if( size.isEmpty() ) {

            for( int i = 0; i < m_pixmapTable.size(); i++ ) {
                if( m_pixmapTable[i].equal( id ) ) {
                    qDebug() << "cache hit: " << id;
                    return true;
                }
            }

        } else {

            for( int i = 0; i < m_pixmapTable.size(); i++ ) {
                if( m_pixmapTable[i].equal( id, size ) )
                    qDebug() << "cache hit: " << id << size;
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

        //qDebug() << "Add Image to shared memory: " << id;

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

            char *to = (char*) addCache( imageReference.memoryPosition );
            const char *from = buffer.data().data();

            memcpy( to, from, imageReference.memorySize );

            m_memoryInfo.dataEnd += size;
            m_memoryInfo.imageCount++;
            m_lastUpdate = m_memoryInfo.incUpdate();

            //qDebug() << "done";

        } else {

            //qDebug() << " cache is full ";

        }

        buffer.close();

        m_memory.unlock();

        saveMemoryInfo();
    }
}

void ImageProviderCache::addPixmapToCache( const QString& id, const QPixmap& pixmap, const PixmapReference& reference )
{
    if( m_bMemoryReady ) {

        readMemoryInfo();

        m_memory.lock();

        PixmapReference pixmapReference( reference );
        pixmapReference.setId( id );
        pixmapReference.refCount = 1;
        pixmapReference.width = pixmap.width();
        pixmapReference.height = pixmap.height();
        pixmapReference.pixMapHandle = (quint64)pixmap.x11PictureHandle();

        m_pixmapTable.append( pixmapReference );
        m_memoryInfo.pixmapCount++;
        m_lastUpdate = m_memoryInfo.incUpdate();

        m_memory.unlock();

        saveMemoryInfo();
    }
}

ImageReference ImageProviderCache::loadSciFile( const QString& id )
{
    ImageReference reference;

    QString filename = QString("%1%2").arg( id, QString::fromLatin1(".sci") );
    QFile file( filename );
    if( file.open( QFile::ReadOnly ) ) {

        //qDebug() << "load file: " << filename;

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
                return reference;

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
        }

        if (l < 0 || r < 0 || t < 0 || b < 0 )
            return reference;

        QString picturefile = filename;

        picturefile.remove( QString(".sci") );
        picturefile.append( QString(".png") );

        reference.borderBottom = b;
        reference.borderTop = t;
        reference.borderLeft = l;
        reference.borderRight = r;
        reference.setId( picturefile );
    }

    //qDebug() << reference.id();
    //qDebug() << reference.borderLeft;
    //qDebug() << reference.borderRight;
    //qDebug() << reference.borderBottom;
    //qDebug() << reference.borderTop;

    return reference;
}

QPixmap ImageProviderCache::loadPixmapFromXServer( const QString &id, const QSize& size )
{
    QPixmap pixmap;

    if( size.isEmpty() ) {

        for( int i = 0; i < m_pixmapTable.size(); i++ ) {
            if( m_pixmapTable[i].equal( id ) ) {
                Qt::HANDLE handle = (Qt::HANDLE) m_pixmapTable[i].pixMapHandle;
                m_pixmapTable[i].refCount++;

                //qDebug() << "load pixmap from cache: " << id << " handle:" << pixmap.x11PictureHandle();

                pixmap = QPixmap::fromX11Pixmap( handle, QPixmap::ExplicitlyShared );
                break;
            }
        }

    } else {

        for( int i = 0; i < m_pixmapTable.size(); i++ ) {
            if( m_pixmapTable[i].equal( id , size) ) {
                Qt::HANDLE handle = (Qt::HANDLE) m_pixmapTable[i].pixMapHandle;
                m_pixmapTable[i].refCount++;

                //qDebug() << "load pixmap from cache: " << id << " handle:" << pixmap.x11PictureHandle();

                pixmap = QPixmap::fromX11Pixmap( handle , QPixmap::ExplicitlyShared );
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
                if( m_imageTable[i].equal( id ) ) {
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

        //qDebug() << "loadImageFromMemory - begin: " << tableInfo.memoryPosition << " size: " << tableInfo.memorySize;
        char* begin = (char*) addCache( tableInfo.memoryPosition );

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

        buffer.setData( (char*)m_memoryInfo.cacheBegin, streamMemoryInfoSize);
        buffer.open(QBuffer::ReadOnly);
        m_memoryInfo.loadFromStream( in );
        buffer.close();

        if( m_memoryInfo.lastUpdate != m_lastUpdate ) {

            m_lastUpdate = m_memoryInfo.lastUpdate;

            // ~~~~~ imageReferences
            QBuffer imageBuffer;
            QDataStream imageIn(&imageBuffer);
            imageBuffer.setData( (char*)addCache( m_memoryInfo.imageTableBegin ), m_memoryInfo.imageTableSize );
            imageBuffer.open(QBuffer::ReadOnly);
            imageIn.setDevice( &imageBuffer );

            ImageReference referenceTableInfo;
            //qDebug() << "image count:" << m_memoryInfo.imageCount;
            for( uint i = 0; i < m_memoryInfo.imageCount; i++ )
            {
                referenceTableInfo.loadFromStream( imageIn );

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
                    /*qDebug() << "readMemoryInfo - new Image found: " << referenceTableInfo.id()
                             << " height: " << referenceTableInfo.height
                             << " width: " << referenceTableInfo.width;*/
                }
            }
            imageBuffer.close();

            // ~~~~~ pixmapReferences
            QBuffer pixmapBuffer;
            QDataStream pixmapIn(&pixmapBuffer);
            pixmapBuffer.setData( (char*) addCache( m_memoryInfo.pixmapTableBegin ), m_memoryInfo.pixmapTableSize );
            pixmapBuffer.open(QBuffer::ReadOnly);

            PixmapReference referenceInfo;
            //qDebug() << "pixmap count:" << m_memoryInfo.pixmapCount;
            for( uint i = 0; i < m_memoryInfo.pixmapCount; i++ )
            {              
                referenceInfo.loadFromStream( pixmapIn );                

                bool bFound = false;
                for( int i; i < m_pixmapTable.size(); i++ )
                {                    
                    if( m_pixmapTable[i].equal( referenceInfo ) ) {                        
                        bFound = true;
                        break;
                    }
                }
                if( !bFound ) {
                    /*qDebug() << "readMemoryInfo - new pixmap found: " << referenceInfo.id()
                             << " height: " << referenceInfo.height
                             << " width: " << referenceInfo.width;*/
                    m_pixmapTable.append( referenceInfo );
                }
            }
            //qDebug() << "pixmap close";
            pixmapBuffer.close();
        }

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

        m_memoryInfo.saveToStream( out );
        int size = buffer.size();

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
        char *imageTable = (char*) addCache( m_memoryInfo.imageTableBegin );
        const char *fromImageTable = imageBuffer.data().data();            
        memcpy( imageTable, fromImageTable, size );

        imageBuffer.close();

        // ~~~~~ pixmapReferences
        QBuffer pixmapBuffer;
        pixmapBuffer.open(QBuffer::ReadWrite);
        QDataStream pixmapOut( &pixmapBuffer );
        for( uint i = 0; i < m_memoryInfo.pixmapCount; i++ )
        {
            m_pixmapTable[i].saveToStream( pixmapOut );
        }
        size = pixmapBuffer.size();
        char *pixmapTable = (char*) addCache( m_memoryInfo.pixmapTableBegin );
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

        char *to = (char*)( addCache( m_memoryInfo.imageTableBegin ) + ( position * streamImageReferenceSize ) );
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

        char *to = (char*)( m_memoryInfo.pixmapTableBegin + ( position * streamPixmapReferenceSize ) );
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

            m_memoryInfo.cacheBegin = (uint)(char*)m_memory.data();
            m_memoryInfo.cacheSize = m_memory.size();
            m_memoryInfo.cacheEnd = m_memoryInfo.cacheBegin + m_memoryInfo.cacheSize;

            m_bMemoryReady = true;

            readMemoryInfo();

            m_memoryInfo.clientCount++;
            saveMemoryInfo();

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

        if(m_memoryInfo.clientCount == 1)
            savePreLoadFile();

        readMemoryInfo();
        m_memoryInfo.clientCount--;
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

    qDebug() << "sm start" << (uint)to;

    m_memoryInfo.incUpdate();

    m_memoryInfo.cacheBegin = (uint)(char*)m_memory.data();
    m_memoryInfo.cacheSize = m_memory.size();    
    m_memoryInfo.cacheEnd = m_memoryInfo.cacheBegin + m_memoryInfo.cacheSize;

    m_memoryInfo.clientCount = 1;

    m_memoryInfo.imageCount = 0;
    m_memoryInfo.imageMaxCount = m_images;
    m_memoryInfo.imageTableBegin = streamMemoryInfoSize;
    m_memoryInfo.imageTableEnd = m_memoryInfo.imageTableBegin + ( m_memoryInfo.imageMaxCount * streamImageReferenceSize );
    m_memoryInfo.imageTableSize = m_memoryInfo.imageTableEnd - m_memoryInfo.imageTableBegin;
    m_memoryInfo.pixmapCount = 0;
    m_memoryInfo.pixmapMaxCount = m_images;
    m_memoryInfo.pixmapTableBegin = m_memoryInfo.imageTableEnd;
    m_memoryInfo.pixmapTableEnd = m_memoryInfo.pixmapTableBegin + ( m_memoryInfo.imageMaxCount * streamPixmapReferenceSize );
    m_memoryInfo.pixmapTableSize = m_memoryInfo.pixmapTableEnd - m_memoryInfo.pixmapTableBegin;
    m_memoryInfo.dataBegin = m_memoryInfo.pixmapTableEnd;
    m_memoryInfo.dataEnd = m_memoryInfo.pixmapTableEnd;

    m_memoryInfo.saveToStream( out );
    int pos = buffer.pos();

    //qDebug() << "position imagetable: " << m_memoryInfo.imageTableBegin;
    //qDebug() << "size would be: " << m_memoryInfo.cacheBegin + buffer.pos();

    ImageReference emptyReference;
    for( uint i = 0; i < m_memoryInfo.imageMaxCount ; i++ )
    {
        emptyReference.saveToStream( out );
    }

    //qDebug() << "delta: " << m_memoryInfo.imageTableSize - ( buffer.pos() - pos );
    //qDebug() << "delta per image: " << ( m_memoryInfo.imageTableSize - ( buffer.pos() - pos ) ) / m_memoryInfo.imageMaxCount;
    //pos = buffer.pos();

    //qDebug() << "position pixmaptable: " << m_memoryInfo.pixmapTableBegin;
    //qDebug() << "size would be: " << m_memoryInfo.cacheBegin + buffer.pos();

    PixmapReference pixmapReference;
    for( uint i = 0; i < m_memoryInfo.pixmapMaxCount ; i++ )
    {
        pixmapReference.saveToStream( out );
    }    

    //qDebug() << "delta: " << m_memoryInfo.pixmapTableSize - ( buffer.pos() - pos );
    //qDebug() << "delta per pixmap: " << ( m_memoryInfo.pixmapTableSize - ( buffer.pos() - pos ) ) / m_memoryInfo.pixmapMaxCount;

    pos = buffer.pos();

    const char *from = buffer.data().data();    
    memcpy(to, from, qMin(m_memory.size(), pos));
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
            QString id = list[i].id();
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
    qDebug() << " relative imageTableBegin: " << m_memoryInfo.imageTableBegin;
    qDebug() << " relative imageTableEnd: " << m_memoryInfo.imageTableEnd;
    qDebug() << " relative imageTableSize: " << m_memoryInfo.imageTableSize;
    qDebug() << " pixmapCout: " << m_memoryInfo.pixmapCount;
    qDebug() << " pixmapMaxCount: " << m_memoryInfo.pixmapMaxCount;
    qDebug() << " relative pixmapTableBegin: " << m_memoryInfo.pixmapTableBegin;
    qDebug() << " relative pixmapTableEnd: " << m_memoryInfo.pixmapTableEnd;
    qDebug() << " relative pixmapTableSize: " << m_memoryInfo.pixmapTableSize;
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

void ImageProviderCache::calcSizes()
{
    QBuffer buffer;
    buffer.open(QBuffer::ReadWrite);
    int size = buffer.pos();
    int newSize = buffer.pos();
    QDataStream out(&buffer);

    size = buffer.pos();
    PixmapReference pRef;
    pRef.saveToStream( out );
    newSize = buffer.pos();
    streamPixmapReferenceSize = newSize - size;

    size = buffer.pos();
    MemoryInfo minfo;
    minfo.saveToStream( out );
    newSize = buffer.pos();
    streamMemoryInfoSize = newSize - size;

    size = buffer.pos();
    ImageReference iRef;
    iRef.saveToStream( out );
    newSize = buffer.pos();
    streamImageReferenceSize = newSize - size;

    //qDebug() << "size ofa MemoryInfo: " << streamMemoryInfoSize;
    //qDebug() << "size of ImageReference: " << streamImageReferenceSize;
    //qDebug() << "size of PixmapReference: " << streamPixmapReferenceSize;

}

uint ImageProviderCache::addCache( uint ref )
{
    return m_memoryInfo.cacheBegin + ref;
}
