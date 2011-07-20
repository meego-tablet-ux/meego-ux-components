#include "imageprovidercache_p.h"
#include <QFile>

static const bool debugCache = (getenv("DEBUG_UXTHEME") != NULL);
static const bool debugCacheDetails = (getenv("DEBUG_UXCACHE") != NULL);

ImageProviderCachePrivate::ImageProviderCachePrivate( const QString memoryName, QObject* parent ) :
    QObject( parent ),
    m_bMemoryReady( false ),
    m_key( memoryName )
{
    m_lastUpdate = 0;
    m_pixmapHandling = saveToMemory;
    m_memory.setKey( m_key );
    calcDataSize();
}

ImageProviderCachePrivate::~ImageProviderCachePrivate()
{
    detachSharedMemory();
}


/*! this method returns a requested QPixmap*/
QPixmap ImageProviderCachePrivate::loadPixmap( const QString &id, PixmapReference& reference )
{
    QPixmap pixmap;

    ImageReference imageReference;
    QImage image = loadImage( id, imageReference );

    pixmap = QPixmap::fromImage( image );

    return pixmap;
}

/*! this method returns a requested QImage*/
QImage ImageProviderCachePrivate::loadImage( const QString &id, ImageReference& imageReference )
{
    QImage image;

    if( existSciFile( id ) ) {

        if( debugCache ) qDebug() << "load sci file for " << id;
        imageReference = loadSciFile( id );

        QImageReader reader;
        reader.setFileName( imageReference.id() );
        if ( reader.canRead() )
            image = reader.read();
        else if( debugCache ) qWarning() << "Image " << imageReference.id() << " can not be read ";

    } else {

        QImageReader reader;
        QString filename = QString("%1%2").arg( id, QString::fromLatin1( ".png" ) );
        reader.setFileName( filename );
        if ( reader.canRead() )
            image = reader.read();
        else if( debugCache ) qWarning() << "Image " << id << " does not exist";

    }

    return image;
}


bool ImageProviderCachePrivate::containsImage( const QString & id, const QSize& size )
{
    if( m_bMemoryReady ) {

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

bool ImageProviderCachePrivate::containsPixmap( const QString & id, const QSize& size )
{
    if( m_bMemoryReady ) {

        m_memory.lock();
        readMemoryInfo();
        m_memory.unlock();

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

bool ImageProviderCachePrivate::existSciFile( const QString & id )
{
    QString filename = QString("%1%2").arg( id, QString::fromLatin1(".sci") );
    if( QFile::exists( filename ) )
        return true;
    return false;
}

QImage ImageProviderCachePrivate::loadImageFromMemory( const QString& id, const QSize& size )
{
    QImage image;

    if( m_bMemoryReady ) {

        ImageReference tableInfo;

        bool found = false;
        if( size.isEmpty() )
        {
            for( int i = 0; i < m_imageTable.size(); i++ )
            {
                if( m_imageTable[i].equal( id ) ) {
                    m_imageTable[i].refCount++;
                    saveImageInfo( i, m_imageTable[i] );
                    tableInfo = m_imageTable[i];
                    found = true;
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
                    found = true;
                    break;
                }
            }
            if( !found ) {
                for( int i = 0; i < m_imageTable.size(); i++ )
                {
                    if( m_imageTable[i].equal( id ) ) {
                        m_imageTable[i].refCount++;
                        saveImageInfo( i, m_imageTable[i] );
                        tableInfo = m_imageTable[i];
                        found = true;
                        break;
                    }
                }
            }
        }

        if( found )
        {
            m_memory.lock();

            QBuffer buffer;
            QDataStream in( &buffer );

            if( debugCache ) qDebug() << __PRETTY_FUNCTION__ << " load image at position: " << m_memoryInfo.calcPos( tableInfo.memoryPosition ) << " size: " << tableInfo.memorySize;

            char* begin = (char*) m_memoryInfo.calcPos( tableInfo.memoryPosition );

            buffer.setData( begin,  tableInfo.memorySize );
            buffer.open(QBuffer::ReadOnly);

            in >> image;

            if( debugCache && image.isNull() ) qWarning() << __PRETTY_FUNCTION__ << " image could not be loaded: " << id;

            m_memory.unlock();

        } else {

            if( debugCache ) qWarning() << __PRETTY_FUNCTION__ << "Image can not be found: " << id;
            image = QImage();

        }
    }
    return image;
}

QPixmap ImageProviderCachePrivate::loadPixmapFromMemory( const QString& id, const QSize& size )
{
    QPixmap pixmap;

    if( m_bMemoryReady ) {

        PixmapReference tableInfo;
        bool found = false;

        if( size.isEmpty() )
        {
            for( int i = 0; i < m_pixmapTable.size(); i++ )
            {
                if( m_pixmapTable[i].equal( id ) ) {
                    m_pixmapTable[i].refCount++;
                    savePixmapInfo( i, m_pixmapTable[i] );
                    tableInfo = m_pixmapTable[i];
                    found = true;
                    break;
                }
            }

        } else {

            for( int i = 0; i < m_pixmapTable.size(); i++ )
            {
                if( m_pixmapTable[i].equal( id, size ) ) {
                    m_pixmapTable[i].refCount++;
                    savePixmapInfo( i, m_pixmapTable[i] );
                    tableInfo = m_pixmapTable[i];
                    found = true;
                    break;
                }
            }
            if( !found ) {
                for( int i = 0; i < m_pixmapTable.size(); i++ )
                {
                    if( m_pixmapTable[i].equal( id ) ) {
                        m_pixmapTable[i].refCount++;
                        savePixmapInfo( i, m_pixmapTable[i] );
                        tableInfo = m_pixmapTable[i];
                        found = true;
                        break;
                    }
                }
            }
        }

        if( found ) {

            m_memory.lock();

            QBuffer buffer;
            QDataStream in( &buffer );

            if( debugCache ) qDebug() << __PRETTY_FUNCTION__ << " load pixmap at position: " << m_memoryInfo.calcPos( tableInfo.memoryPosition ) << " size: " << tableInfo.memorySize;

            char* begin = (char*) m_memoryInfo.calcPos( tableInfo.memoryPosition );

            buffer.setData( begin,  tableInfo.memorySize );
            buffer.open(QBuffer::ReadOnly);

            in >> pixmap;

            if( debugCache && pixmap.isNull() ) qWarning() << __PRETTY_FUNCTION__ << " loaded null pixmap: ";

            m_memory.unlock();

        } else {

            if( debugCache ) qWarning() << __PRETTY_FUNCTION__ << "Pixmap can not be found: " << id;
            pixmap = QPixmap();

        }
    }
    return pixmap;
}

QPixmap ImageProviderCachePrivate::loadPixmapFromXServer( const QString &id, const QSize& size )
{
    QPixmap pixmap;
    Qt::HANDLE handle = 0;

    if( size.isEmpty() ) {

        for( int i = 0; i < m_pixmapTable.size(); i++ ) {
            if( m_pixmapTable[i].equal( id ) ) {
                handle = (Qt::HANDLE) m_pixmapTable[i].pixMapHandle;
                m_pixmapTable[i].refCount++;
                savePixmapInfo( i, m_pixmapTable[i] );
                break;
            }
        }

    } else {

        for( int i = 0; i < m_pixmapTable.size(); i++ ) {
            if( m_pixmapTable[i].equal( id , size) ) {
                handle = (Qt::HANDLE) m_pixmapTable[i].pixMapHandle;
                m_pixmapTable[i].refCount++;
                savePixmapInfo( i, m_pixmapTable[i] );
                break;
            }
        }

    }

    if(handle != 0)
        pixmap = QPixmap::fromX11Pixmap( handle , QPixmap::ExplicitlyShared );
    else
        pixmap = QPixmap();

    return pixmap;
}

QPixmap ImageProviderCachePrivate::loadPixmapFromGles( const QString &id, const QSize& size )
{
    QPixmap pixmap;
    Q_UNUSED( id );
    Q_UNUSED( size );
    // to be implemented
    pixmap = QPixmap();

    return pixmap;
}

ImageReference ImageProviderCachePrivate::loadSciFile( const QString& id )
{
    ImageReference reference;

    QString filename = QString("%1%2").arg( id, QString::fromLatin1(".sci") );
    QFile file( filename );
    if( file.open( QFile::ReadOnly ) ) {

        if(debugCache) qDebug() << "load file: " << filename;

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

        // naming convention of sci: same path, files are svg or png
        QString picturefile = filename;

        if( imgFile.contains( QString::fromLatin1(".svg") ) ) {

            picturefile.remove( QString(".sci") );
            picturefile.append( QString(".svg") );

        } else if( imgFile.contains( QString::fromLatin1(".png") ) ) {

            picturefile.remove( QString(".sci") );
            picturefile.append( QString(".png") );

        }

        reference.borderBottom = b;
        reference.borderTop = t;
        reference.borderLeft = l;
        reference.borderRight = r;
        reference.setId( picturefile );
    }
    return reference;
}

bool ImageProviderCachePrivate::isResizedImageWorthCaching( const QString& id )
{
    Q_UNUSED( id );


    return true;
}

void ImageProviderCachePrivate::addImageToMemory( const QString& id, const QImage& image, const ImageReference& reference )
{
    if( m_bMemoryReady ) {

        if( debugCacheDetails ) qDebug() << __PRETTY_FUNCTION__ << "lock memory";
        m_memory.lock();

        readMemoryInfo();

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

            char *to = (char*) m_memoryInfo.calcPos( imageReference.memoryPosition );
            const char *from = buffer.data().data();

            memcpy( to, from, imageReference.memorySize );

            m_memoryInfo.dataEnd += size;
            m_memoryInfo.imageCount++;
            m_lastUpdate = m_memoryInfo.incUpdate();

        } else {

            qWarning() << "the imageProvider cache is full ";

        }

        buffer.close();
        saveMemoryInfo();

        if( debugCacheDetails ) qDebug() << __PRETTY_FUNCTION__ << "unlock memory";
        m_memory.unlock();

    }
}

void ImageProviderCachePrivate::addPixmapToMemory( const QString &id, const QPixmap &pixmap, const PixmapReference &reference )
{
    if( m_bMemoryReady ) {

        if( debugCacheDetails ) qDebug() << __PRETTY_FUNCTION__ << "lock memory";
        m_memory.lock();

        readMemoryInfo();

        QBuffer buffer;
        buffer.open( QBuffer::ReadWrite );
        QDataStream out(&buffer);
        out << pixmap;
        uint size = buffer.size();

        PixmapReference pixmapReference( reference );
        if(  m_memoryInfo.dataEnd + size < m_memoryInfo.cacheEnd )
        {
            pixmapReference.setId( id );
            pixmapReference.refCount = 1;
            pixmapReference.width = pixmap.width();
            pixmapReference.height = pixmap.height();
            pixmapReference.memoryPosition = m_memoryInfo.dataEnd;
            pixmapReference.memorySize = size;

            m_pixmapTable.append( pixmapReference );

            char *to = (char*) m_memoryInfo.calcPos( pixmapReference.memoryPosition );
            const char *from = buffer.data().data();

            memcpy( to, from, pixmapReference.memorySize );

            m_memoryInfo.dataEnd += size;
            m_memoryInfo.pixmapCount++;
            m_lastUpdate = m_memoryInfo.incUpdate();

        } else {

            qWarning() << " ImageProviderCache is full ";

        }
        buffer.close();
        saveMemoryInfo();

        if( debugCacheDetails ) qDebug() << __PRETTY_FUNCTION__ << "unlock memory";
        m_memory.unlock();

    }
}

void ImageProviderCachePrivate::addPixmapToX11Cache( const QString& id, const QPixmap& pixmap, const PixmapReference& reference )
{
    if( m_bMemoryReady ) {

        if( debugCacheDetails ) qDebug() << __PRETTY_FUNCTION__ << "lock memory";
        m_memory.lock();

        readMemoryInfo();

        PixmapReference pixmapReference( reference );
        pixmapReference.setId( id );
        pixmapReference.refCount = 1;
        pixmapReference.width = pixmap.width();
        pixmapReference.height = pixmap.height();
        pixmapReference.pixMapHandle = (quint64)pixmap.x11PictureHandle();
        pixmapReference.memoryPosition = 0;
        pixmapReference.memorySize = 0;
        m_pixmapTable.append( pixmapReference );

        m_memoryInfo.pixmapCount++;
        m_lastUpdate = m_memoryInfo.incUpdate();

        saveMemoryInfo();

        if( debugCacheDetails ) qDebug() << __PRETTY_FUNCTION__ << "lock memory";
        m_memory.unlock();

    }
}

void ImageProviderCachePrivate::addPixmapToGlesCache( const QString& id, const QPixmap& pixmap, const PixmapReference& reference )
{
    Q_UNUSED( id );
    Q_UNUSED( pixmap );
    Q_UNUSED( reference );
    // to be implemented
}

bool ImageProviderCachePrivate::clearMemoryInfo( int maxImages )
{
    QBuffer buffer;
    buffer.open(QBuffer::ReadWrite);
    QDataStream out(&buffer);

    // calculate sizes of the fix table and data position
    char *to = (char*)m_memory.data();
    m_memoryInfo.incUpdate();

    m_memoryInfo.cacheBegin = (uint)(char*)m_memory.data();
    m_memoryInfo.cacheSize = m_memory.size();
    m_memoryInfo.cacheEnd = m_memoryInfo.cacheBegin + m_memoryInfo.cacheSize;
    m_memoryInfo.clientCount = 1;

    m_memoryInfo.imageCount = 0;
    m_memoryInfo.imageMaxCount = maxImages;
    m_memoryInfo.imageTableBegin = streamMemoryInfoSize;
    m_memoryInfo.imageTableEnd = m_memoryInfo.imageTableBegin + ( m_memoryInfo.imageMaxCount * streamImageReferenceSize );
    m_memoryInfo.imageTableSize = m_memoryInfo.imageTableEnd - m_memoryInfo.imageTableBegin;

    m_memoryInfo.pixmapCount = 0;
    m_memoryInfo.pixmapMaxCount = maxImages;
    m_memoryInfo.pixmapTableBegin = m_memoryInfo.imageTableEnd;
    m_memoryInfo.pixmapTableEnd = m_memoryInfo.pixmapTableBegin + ( m_memoryInfo.imageMaxCount * streamPixmapReferenceSize );
    m_memoryInfo.pixmapTableSize = m_memoryInfo.pixmapTableEnd - m_memoryInfo.pixmapTableBegin;

    m_memoryInfo.dataBegin = m_memoryInfo.pixmapTableEnd;
    m_memoryInfo.dataEnd = m_memoryInfo.dataBegin;

    m_memoryInfo.saveToStream( out );
    int pos = buffer.pos();

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

    pos = buffer.pos();

    const char *from = buffer.data().data();
    memcpy(to, from, qMin(m_memory.size(), pos));

    m_bMemoryReady = true;
    return true;
}

void ImageProviderCachePrivate::readMemoryInfo()
{
    if( m_bMemoryReady ) {

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
            imageBuffer.setData( (char*)m_memoryInfo.calcPos( m_memoryInfo.imageTableBegin ), m_memoryInfo.imageTableSize );
            imageBuffer.open(QBuffer::ReadOnly);
            imageIn.setDevice( &imageBuffer );

            ImageReference referenceTableInfo;

            QList<ImageReference> newImageTable;
            for( uint i = 0; i < m_memoryInfo.imageCount; i++ )
            {
                referenceTableInfo.loadFromStream( imageIn );
                newImageTable.append( referenceTableInfo );
            }
            m_imageTable = newImageTable;
            imageBuffer.close();

            // ~~~~~ pixmapReferences
            QBuffer pixmapBuffer;
            QDataStream pixmapIn(&pixmapBuffer);
            pixmapBuffer.setData( (char*) m_memoryInfo.calcPos( m_memoryInfo.pixmapTableBegin ), m_memoryInfo.pixmapTableSize );
            pixmapBuffer.open(QBuffer::ReadOnly);

            QList<PixmapReference> newPixmapTable;
            PixmapReference referenceInfo;
            for( uint i = 0; i < m_memoryInfo.pixmapCount; i++ )
            {
                referenceInfo.loadFromStream( pixmapIn );
                m_pixmapTable.append( referenceInfo );
            }
            m_pixmapTable = newPixmapTable;
            pixmapBuffer.close();
        }
    }
}

void ImageProviderCachePrivate::saveMemoryInfo()
{
    if( m_bMemoryReady ) {

        if( (uint)m_pixmapTable.size() < m_memoryInfo.pixmapCount ) {

            if( debugCache ) {
                qWarning() << "Pixmap count is out of Sync. internal Count: " << m_pixmapTable.size() << " external Count: " << m_memoryInfo.pixmapCount;
                qDebug() << "reset pixmap table, changes will not passed to shared memory ";
            }
            readMemoryInfo();
            return;
        }

        if( (uint)m_imageTable.size() < m_memoryInfo.imageCount ) {

            if( debugCache ) {
                qWarning() << "Image count is out of Sync. internal Count: " << m_imageTable.size() << " external Count: " << m_memoryInfo.imageCount;
                qDebug() << "reset image table, changes will not passed to shared memory ";
            }
            readMemoryInfo();
            return;
        }

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

        for( int i = 0; i < m_imageTable.size(); i++ )
        {
            m_imageTable[i].saveToStream( imageOut );
        }
        size = imageBuffer.size();
        char *imageTable = (char*) m_memoryInfo.calcPos( m_memoryInfo.imageTableBegin );
        const char *fromImageTable = imageBuffer.data().data();
        memcpy( imageTable, fromImageTable, size );

        imageBuffer.close();

        // ~~~~~ pixmapReferences
        QBuffer pixmapBuffer;
        pixmapBuffer.open(QBuffer::ReadWrite);
        QDataStream pixmapOut( &pixmapBuffer );

        for( int i = 0; i < m_pixmapTable.size(); i++ )
        {
            m_pixmapTable[i].saveToStream( pixmapOut );
        }
        size = pixmapBuffer.size();
        char *pixmapTable = (char*) m_memoryInfo.calcPos( m_memoryInfo.pixmapTableBegin );
        const char *fromPixmapTable = pixmapBuffer.data().data();
        memcpy( pixmapTable, fromPixmapTable, size );
        pixmapBuffer.close();

    }
}

void ImageProviderCachePrivate::saveImageInfo( int position, ImageReference& refTableInfo )
{
    if( m_bMemoryReady ) {

        if( debugCache ) qDebug() << __PRETTY_FUNCTION__ << "position: " << position << " id: " << refTableInfo.id();

        QBuffer buffer;
        buffer.open(QBuffer::ReadWrite);
        QDataStream out(&buffer);

        refTableInfo.saveToStream( out );

        int size = buffer.size();

        m_memory.lock();

        char *to = (char*)( m_memoryInfo.calcPos( m_memoryInfo.imageTableBegin ) + ( position * streamImageReferenceSize ) );
        const char *from = buffer.data().data();
        memcpy( to, from, size );

        m_memory.unlock();
    }
}

void ImageProviderCachePrivate::savePixmapInfo( int position, PixmapReference& refTableInfo )
{
    if( m_bMemoryReady ) {

        if( debugCache ) qDebug() << __PRETTY_FUNCTION__ << "position: " << position << " id: " << refTableInfo.id();

        QBuffer buffer;
        buffer.open(QBuffer::ReadWrite);
        QDataStream out(&buffer);

        refTableInfo.saveToStream( out );

        int size = buffer.size();

        m_memory.lock();

        char *to = (char*)( m_memoryInfo.calcPos( m_memoryInfo.pixmapTableBegin ) + ( position * streamPixmapReferenceSize ) );
        const char *from = buffer.data().data();
        memcpy( to, from, size );

        m_memory.unlock();
    }
}

bool ImageProviderCachePrivate::attachSharedMemory()
{
    bool bRet = false;

    if( m_memory.attach() )
    {
        m_memoryInfo.cacheBegin = (uint)(char*)m_memory.data();
        m_memoryInfo.cacheSize = m_memory.size();
        m_memoryInfo.cacheEnd = m_memoryInfo.cacheBegin + m_memoryInfo.cacheSize;

        m_bMemoryReady = true;

        if( debugCacheDetails ) qDebug() << __PRETTY_FUNCTION__ << "lock memory";
        m_memory.lock();

        readMemoryInfo();
        m_memoryInfo.clientCount++;
        saveMemoryInfo();

        if( debugCacheDetails ) qDebug() << __PRETTY_FUNCTION__ << "unlock memory";
        m_memory.unlock();

        m_bMemoryReady = true;
        bRet = true;

    } else {

        qDebug() << "can not attach";

    }

    return bRet;
}

bool ImageProviderCachePrivate::detachSharedMemory()
{
    if( m_memory.isAttached() ) {

        if(m_memoryInfo.clientCount == 1) {
            savePreLoadFile( m_filename );
        }

        if( debugCacheDetails ) qDebug() << __PRETTY_FUNCTION__ << "lock memory";
        m_memory.lock();

        readMemoryInfo();
        m_memoryInfo.clientCount--;
        saveMemoryInfo();

        if( debugCacheDetails ) qDebug() << __PRETTY_FUNCTION__ << "unlock memory";
        m_memory.unlock();
        m_memory.detach();
        return true;
    }
    return false;
}

bool ImageProviderCachePrivate::createSharedMemory( int maxImages , int sizeInMb)
{
    if ( !m_memory.create( sizeInMb * 1024 * 1024 ) )
        return false;

    m_memory.lock();
    bool bRet =  clearMemoryInfo( maxImages );
    m_memory.unlock();
    return bRet;
}

bool ImageProviderCachePrivate::reloadSharedMemory()
{
    if( !m_bMemoryReady ) {
        if( !attachSharedMemory() )
            return false;
    }
    if( m_bMemoryReady )
    {
        if( m_memory.isAttached() )
        {
            if( debugCacheDetails ) qDebug() << __PRETTY_FUNCTION__ << "lock memory";
            m_memory.lock();

            readMemoryInfo();

            QList<ImageReference>  imageTable = m_imageTable;
            QList<PixmapReference> pixmapTable = m_pixmapTable;

            clearMemoryInfo( m_memoryInfo.imageMaxCount );

            saveMemoryInfo();

            if( debugCacheDetails ) qDebug() << __PRETTY_FUNCTION__ << "unlock memory";
            m_memory.unlock();

            for( int i = 0 ; i < imageTable.size(); i++ )
            {
                ImageReference imageReference;
                QImage image = loadImage( imageTable[i].id(), imageReference );
                if( !image.isNull() )
                    addImageToMemory( imageTable[i].id(), image, imageReference );

            }
            for( int i = 0 ; i < pixmapTable.size(); i++ )
            {
                PixmapReference pixmapReference;
                QPixmap pixmap = loadPixmap( pixmapTable[i].id(), pixmapReference );
                if( !pixmap.isNull() )
                    addPixmapToMemory( pixmapTable[i].id(), pixmap, pixmapReference );
            }
        }
    }
    return m_bMemoryReady;
}

bool ImageProviderCachePrivate::clearSharedMemory()
{
    if( !m_bMemoryReady ) {
        if( !attachSharedMemory() )
            return false;
    }
    if( m_bMemoryReady )
    {
        if( m_memory.isAttached() )
        {
            if( debugCacheDetails ) qDebug() << __PRETTY_FUNCTION__ << "lock memory";
            m_memory.lock();

            clearMemoryInfo( m_memoryInfo.imageMaxCount );
            m_memoryInfo.incUpdate();
            m_imageTable.clear();
            m_pixmapTable.clear();

            saveMemoryInfo();

            if( debugCacheDetails ) qDebug() << __PRETTY_FUNCTION__ << "unlock memory";
            m_memory.unlock();
        }
    }
    return m_bMemoryReady;
}

bool ImageProviderCachePrivate::loadPreLoadFile( QString filename )
{
    if( !m_bMemoryReady ) {
        if( !attachSharedMemory() )
            return false;
    }
    if( m_bMemoryReady )
    {
        if( QFile::exists( filename ) ) {

            clearSharedMemory();

        } else {
            return false;
        }
    }

    return m_bMemoryReady;
}

bool ImageProviderCachePrivate::savePreLoadFile( QString filename )
{
    if( !m_bMemoryReady ) {
        if( !attachSharedMemory() )
            return false;
    }

    if( m_bMemoryReady )
    {

    }
    return m_bMemoryReady;
}

void ImageProviderCachePrivate::calcDataSize()
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

    if( debugCache ) qDebug() << "size ofa MemoryInfo: " << streamMemoryInfoSize;
    if( debugCache ) qDebug() << "size of ImageReference: " << streamImageReferenceSize;
    if( debugCache ) qDebug() << "size of PixmapReference: " << streamPixmapReferenceSize;

}

QStringList ImageProviderCachePrivate::bulk()
{
    if( !m_bMemoryReady ) {

        if( !attachSharedMemory() )
            return QStringList();
    }

    readMemoryInfo();

    QStringList list;

    list << QString( "Bulk of sharedMemory: %1" ).arg( m_key );
    list << QString( "lastUpdate: %1" ).arg(  m_memoryInfo.lastUpdate );
    list << QString( " clients: %1" ).arg( m_memoryInfo.clientCount );
    list << QString( " cacheBegin: %1" ).arg( m_memoryInfo.cacheBegin );
    list << QString( " cacheEnd: %1" ).arg(  m_memoryInfo.cacheEnd );
    list << QString( " cacheSize: %1" ).arg( m_memoryInfo.cacheSize );
    list << QString( " imageCount: %1" ).arg( m_memoryInfo.imageCount );
    list << QString( " imageMaxCount: %1" ).arg(  m_memoryInfo.imageMaxCount );
    list << QString( " relative imageTableBegin: %1" ).arg(  m_memoryInfo.imageTableBegin );
    list << QString( " relative imageTableEnd: %1" ).arg(  m_memoryInfo.imageTableEnd );
    list << QString( " relative imageTableSize: %1" ).arg(  m_memoryInfo.imageTableSize );
    list << QString( " pixmapCout: %1" ).arg(  m_memoryInfo.pixmapCount );
    list << QString( " pixmapMaxCount: %1" ).arg(  m_memoryInfo.pixmapMaxCount );
    list << QString( " relative pixmapTableBegin: %1" ).arg(  m_memoryInfo.pixmapTableBegin );
    list << QString( " relative pixmapTableEnd: %1" ).arg(  m_memoryInfo.pixmapTableEnd );
    list << QString( " relative pixmapTableSize: %1" ).arg(  m_memoryInfo.pixmapTableSize );
    list << QString( " dataBegin: %1" ).arg( m_memoryInfo.dataBegin );
    list << QString( " dataEnd: %1" ).arg( m_memoryInfo.dataEnd );

    for( int i = 0; i < m_imageTable.size(); i++)
    {
        list << QString("_______________________________");
        list << QString("%1. Image: %2").arg( i+1 ).arg( m_imageTable[i].id() );
        list << QString("MemoryPosition: %1, MemorySize %2, Width: %3, Height: %4").arg( m_imageTable[i].memoryPosition ).arg( m_imageTable[i].memorySize ).arg( m_imageTable[i].width).arg( m_imageTable[i].height );
        list << QString("Borders: %1;%2;%3;%4").arg( m_imageTable[i].borderTop ).arg( m_imageTable[i].borderLeft ).arg( m_imageTable[i].borderRight).arg( m_imageTable[i].borderBottom );
    }

    for( int i = 0; i < m_pixmapTable.size(); i++)
    {
        list << QString("_______________________________");
        list << QString("%1. Image: %2").arg( i+1 ).arg( m_pixmapTable[i].id() );
        list << QString("MemoryPosition: %1, MemorySize %2, Width: %3, Height: %4").arg( m_pixmapTable[i].memoryPosition ).arg( m_pixmapTable[i].memorySize ).arg( m_pixmapTable[i].width).arg( m_pixmapTable[i].height );
        list << QString("Borders: %1;%2;%3;%4").arg( m_pixmapTable[i].borderTop ).arg( m_pixmapTable[i].borderLeft ).arg( m_pixmapTable[i].borderRight).arg( m_pixmapTable[i].borderBottom );
    }
    list << QString("_______________________________");

    return list;

}

QStringList ImageProviderCachePrivate::verify( bool errorsOnly )
{
    QStringList list;

    if( !m_bMemoryReady ) {

        if( !attachSharedMemory() )
            return QStringList();
    }

    if( m_bMemoryReady )
    {
        list << QString( "Verify of sharedMemory: %1" ).arg( m_key );

        if( !errorsOnly ) {

            list << QString( " lastUpdate: %1" ).arg(  m_memoryInfo.lastUpdate );
            list << QString( " clients: %1" ).arg( m_memoryInfo.clientCount );
            list << QString( " cacheBegin: %1" ).arg( m_memoryInfo.cacheBegin );
            list << QString( " cacheEnd: %1" ).arg(  m_memoryInfo.cacheEnd );
            list << QString( " cacheSize: %1" ).arg( m_memoryInfo.cacheSize );
            list << QString( " imageCount: %1" ).arg( m_memoryInfo.imageCount );
            list << QString( " imageMaxCount: %1" ).arg(  m_memoryInfo.imageMaxCount );
            list << QString( " relative imageTableBegin: %1" ).arg(  m_memoryInfo.imageTableBegin );
            list << QString( " relative imageTableEnd: %1" ).arg(  m_memoryInfo.imageTableEnd );
            list << QString( " relative imageTableSize: %1" ).arg(  m_memoryInfo.imageTableSize );
            list << QString( " pixmapCout: %1" ).arg(  m_memoryInfo.pixmapCount );
            list << QString( " pixmapMaxCount: %1" ).arg(  m_memoryInfo.pixmapMaxCount );
            list << QString( " relative pixmapTableBegin: %1" ).arg(  m_memoryInfo.pixmapTableBegin );
            list << QString( " relative pixmapTableEnd: %1" ).arg(  m_memoryInfo.pixmapTableEnd );
            list << QString( " relative pixmapTableSize: %1" ).arg(  m_memoryInfo.pixmapTableSize );
            list << QString( " dataBegin: %1" ).arg( m_memoryInfo.dataBegin );
            list << QString( " dataEnd: %1" ).arg( m_memoryInfo.dataEnd );
        }
        for( int i = 1; i < m_imageTable.size(); i++)
        {
            list << QString("%1. Image: %2").arg( i ).arg( m_imageTable[i-1].id() );
            uint shouldBeOffset = m_imageTable[i].memoryPosition - m_imageTable[i-1].memoryPosition;
            uint offset = m_imageTable[i-1].memorySize;
            if( offset < shouldBeOffset )
                list << QString("Error: memorySize is smaller as expected %1 should be %2 " ).arg( offset ).arg( shouldBeOffset );
            else if( offset > shouldBeOffset )
                list << QString("Error: memorySize is bigger as expected %1 should be %2 " ).arg( offset ).arg( shouldBeOffset );
            else if( !errorsOnly ) list << QString("Verified: memorySize");

            QSize size;
            QImage image = loadImageFromMemory( m_imageTable[i-1].id(), size);
            if( image.isNull() )
                list << QString("Error: image can not be read");
            else if( !errorsOnly ) {
                list << QString("Verified: image can be read ");
                list << QString( "size: %1;%2, format: %3" ).arg( image.size().width() ).arg( image.size().height() ).arg( image.format() );
            }
        }

        for( int i = 1; i < m_pixmapTable.size(); i++)
        {
            list << QString("%1. Pixmap: %2").arg( i ).arg( m_pixmapTable[i-1].id() );
            uint offset = m_pixmapTable[i-1].memoryPosition + m_pixmapTable[i-1].memorySize;
            if( offset < m_pixmapTable[i].memoryPosition )
                list << QString("Error: memorySize is smaller as expected");
            else if( offset < m_pixmapTable[i].memoryPosition )
                list << QString("Error: memorySize is bigger as expected");
            else if( !errorsOnly )
                list << QString("Verified: memorySize");

            QSize size;
            QPixmap pixmap = loadPixmapFromMemory( m_imageTable[i-1].id(), size );
            if( pixmap.isNull() )
                list << QString("Error: pixmap can not be read");
            else if( !errorsOnly ) {
                list << QString("Verified: image can be read ");
                list << QString( "size: %1;%2" ).arg( pixmap.width() ).arg( pixmap.height() );
            }
        }

        list << QString( "End of Verifing" );
    } else {

        list << QString( "Verify of sharedMemory: %1 - SharedMemory not ready" ).arg( m_key );

    }
    return list;

}
