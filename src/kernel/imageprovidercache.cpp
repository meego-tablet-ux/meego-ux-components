/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#include <QDebug>
#include <QFile>
#include <QImageReader>

#include "imageprovidercache.h"
#include <QMutexLocker>

static const bool debugUxTheme = (getenv("DEBUG_UXTHEME") != NULL);
static const bool debugUxCache = (getenv("DEBUG_UXCACHE") != NULL);
static int callCount = 0;

ImageProviderCache::ImageProviderCache( const QString ThemeName, int maxImages, int sizeInMb, QObject *parent ) :
    QObject(parent),
    m_bMemoryReady( false ),
    m_key( ThemeName ),
    m_size( sizeInMb ),
    m_images( maxImages ),
    m_filename( QString("statistics") )
{

    m_lastUpdate = 0;
    m_emptyImage.fill(Qt::red);
    m_emptyPixmap.fill(Qt::red);

    m_pixmapHandling = saveToMemory;

    calcDataSize();
    attachSharedMemory();
}

ImageProviderCache::~ImageProviderCache()
{
    detachSharedMemory();
}

// ~~~~~~ Public

QPixmap ImageProviderCache::requestPixmap( const QString& id, QSize* size, const QSize& requestedSize )
{
    if(debugUxTheme) qDebug() << "request Pixmap " << id << " " << requestedSize;
    QPixmap pixmap;

    if( containsPixmap( id, requestedSize ) ) {

        if( saveToMemory == m_pixmapHandling ) {

            pixmap = loadPixmapFromMemory( id, requestedSize );

        } else if ( cacheInX11 == m_pixmapHandling  ) {

            pixmap = loadPixmapFromXServer( id, requestedSize );

        } else if ( cacheInGles == m_pixmapHandling ) {

            pixmap = loadPixmapFromGles( id, requestedSize );

        }

        if( !requestedSize.isEmpty() && pixmap.size() != requestedSize )
        {
            pixmap = pixmap.scaled( requestedSize );

            if( saveToMemory == m_pixmapHandling )
                addPixmapToMemory( id, pixmap );

        }

    } else {

        if( saveToMemory == m_pixmapHandling ) { // dont save image but pixmap

            QImage image = requestImage( id, false, size, requestedSize );
            pixmap = QPixmap::fromImage( image );

            if( !requestedSize.isEmpty() && requestedSize != pixmap.size() )
                pixmap = pixmap.scaled( requestedSize );

            addPixmapToMemory( id, pixmap );

        } else if ( cacheInX11 == m_pixmapHandling ) { // save image for rescaling

            QImage image = requestImage( id, true, size, requestedSize );
            pixmap = QPixmap::fromImage( image );

            if( !requestedSize.isEmpty() && requestedSize != pixmap.size() )
                pixmap = pixmap.scaled( requestedSize );

            addPixmapToX11Cache( id, pixmap );

        } else if ( cacheInGles == m_pixmapHandling) { // save image for rescaling

            QImage image = requestImage( id, true, size, requestedSize );
            pixmap = QPixmap::fromImage( image );

            if( !requestedSize.isEmpty() && requestedSize != pixmap.size() )
                pixmap = pixmap.scaled( requestedSize );

            addPixmapToGlesCache( id, pixmap );

        }
    }

    if( size ) {
        size->setHeight( pixmap.height() );
        size->setWidth( pixmap.width() );
    }

    return pixmap;
}

QImage ImageProviderCache::requestImage( const QString& id, QSize* size, const QSize& requestedSize )
{
    return requestImage( id, true, size, requestedSize );
}

void ImageProviderCache::requestBorderGrid( const QString &id, int &borderTop, int &borderBottom, int &borderLeft, int &borderRight )
{
    QString path = m_path + id;
    path.remove( QString::fromLatin1("image://themedimage/") );
    path.remove( QString::fromLatin1("image://meegotheme/") );

    for( int i = 0; i < m_imageTable.size(); i++ ) {
        if( m_imageTable[i].equal( path ) ) {

            borderTop = m_imageTable[i].borderTop;
            borderBottom = m_imageTable[i].borderBottom;
            borderLeft = m_imageTable[i].borderLeft;
            borderRight = m_imageTable[i].borderRight;

            if(debugUxTheme) qDebug() << __PRETTY_FUNCTION__ << "border for" << path << " found";
            return;
        }
    }

    if(debugUxTheme) qDebug() << __PRETTY_FUNCTION__ << "loading image for: " << path;
    requestImage( path, true, 0 );

    for( int i = 0; i < m_imageTable.size(); i++ ) {

        if( m_imageTable[i].equal( path ) ) {

            borderTop = m_imageTable[i].borderTop;
            borderBottom = m_imageTable[i].borderBottom;
            borderLeft = m_imageTable[i].borderLeft;
            borderRight = m_imageTable[i].borderRight;
            return;

        }
    }

    if(debugUxTheme) qDebug() << " Image borders for " << path << "not found";   
    return;
}

bool ImageProviderCache::existImage( const QString& id )
{
    QString path = m_path + id;
    path.remove( QString::fromLatin1("image://themedimage/") );

    if( containsImage( path, QSize() ) )
        return true;
    if( containsPixmap( path, QSize() ) )
        return true;
    if( existSciFile( path ) )
        return true;

    QString filename = QString("%1%2").arg( path, QString::fromLatin1( ".png" ) );
    if( QFile::exists( filename ) )
        return true;

    filename = QString("%1%2").arg( id, QString::fromLatin1( ".png" ) );
    if( QFile::exists( filename ) )
        return true;

    filename = QString("%1%2").arg( id, QString::fromLatin1( ".svg" ) );
    if( QFile::exists( filename ) )
        return true;

    if( QFile::exists( id ) )
        return true;

    return false;
}

// ~~~~~~ Private

bool ImageProviderCache::containsImage( const QString & id, const QSize& size )
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

bool ImageProviderCache::containsPixmap( const QString & id, const QSize& size )
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

bool ImageProviderCache::existSciFile( const QString & id )
{
    QString filename = QString("%1%2").arg( id, QString::fromLatin1(".sci") );
    if( QFile::exists( filename ) )
        return true;
    return false;
}

QImage ImageProviderCache::requestImage( const QString& id, bool saveToMemory, QSize* size, const QSize& requestedSize )
{
    callCount++;

    if( debugUxTheme ) qDebug() << callCount;

    QImage image;

    if( containsImage ( id , requestedSize ) ) {

        image = loadImageFromMemory( id, requestedSize );

        if( !requestedSize.isEmpty() && image.size() != requestedSize ) {

            QImage resizedImage = image.scaled( requestedSize );

            if( isResizedImageWorthCaching( id ) ) {

                if( saveToMemory )
                    addImageToMemory( id,  resizedImage );

            }
        }

    } else if( existSciFile( id ) ) {

        ImageReference imageReference = loadSciFile( id );

        QImageReader reader;
        reader.setFileName( imageReference.id() );
        if ( reader.canRead() ) {

            image = reader.read();

           if( saveToMemory )
                addImageToMemory( id, image, imageReference );

            if( !requestedSize.isEmpty() && image.size() != requestedSize ) {

                reader.setScaledSize( requestedSize );

                image = reader.read();

                if( isResizedImageWorthCaching( id ) ) {
                    if( saveToMemory )
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
        if ( reader.canRead() ) {

            image = reader.read();

            if( saveToMemory)
                addImageToMemory( id, image );

            if(  !requestedSize.isEmpty() && image.size() != requestedSize ) {

                reader.setScaledSize( requestedSize );

                image = reader.read();

                if( isResizedImageWorthCaching( id ) ) {
                    if( saveToMemory )
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

    callCount--;

    return image;

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
                    tableInfo = m_imageTable[i];
                    break;
                }
            }

        } else {

            for( int i = 0; i < m_imageTable.size(); i++ )
            {
                if( m_imageTable[i].equal( id, size ) ) {
                    m_imageTable[i].refCount++;                    
                    tableInfo = m_imageTable[i];
                    break;
                }
            }
        }

        m_memory.lock();

        QBuffer buffer;
        QDataStream in( &buffer );

        char* begin = (char*) m_memoryInfo.calcPos( tableInfo.memoryPosition );

        buffer.setData( begin,  tableInfo.memorySize );
        buffer.open(QBuffer::ReadOnly);

        in >> image;

        m_memory.unlock();

    }
    return image;
}

QPixmap ImageProviderCache::loadPixmapFromMemory( const QString& id, const QSize& size )
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
        }

        if( found ) {

            m_memory.lock();

            QBuffer buffer;
            QDataStream in( &buffer );

            char* begin = (char*) m_memoryInfo.calcPos( tableInfo.memoryPosition );

            buffer.setData( begin,  tableInfo.memorySize );
            buffer.open(QBuffer::ReadOnly);

            in >> pixmap;

            m_memory.unlock();

        } else {

            pixmap = m_emptyPixmap;
        }
    }
    return pixmap;
}

QPixmap ImageProviderCache::loadPixmapFromXServer( const QString &id, const QSize& size )
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
        pixmap = m_emptyPixmap;

    return pixmap;
}

QPixmap ImageProviderCache::loadPixmapFromGles( const QString &id, const QSize& size )
{
    QPixmap pixmap;
    Q_UNUSED( id );
    Q_UNUSED( size );
    // to be implemented
    pixmap = m_emptyPixmap;

    return pixmap;
}

ImageReference ImageProviderCache::loadSciFile( const QString& id )
{
    ImageReference reference;

    QString filename = QString("%1%2").arg( id, QString::fromLatin1(".sci") );
    QFile file( filename );
    if( file.open( QFile::ReadOnly ) ) {

        if(debugUxTheme) qDebug() << "load file: " << filename;

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

bool ImageProviderCache::isResizedImageWorthCaching( const QString& id )
{
    Q_UNUSED( id );


    return true;
}

void ImageProviderCache::addImageToMemory( const QString& id, const QImage& image, const ImageReference& reference )
{
    if( m_bMemoryReady ) {

        if( debugUxCache ) qDebug() << __PRETTY_FUNCTION__ << " lock memory";
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

            if( debugUxTheme ) qDebug() << __PRETTY_FUNCTION__ << " saved " << buffer.size();

        } else {

            qWarning() << "the imageProvider cache is full ";

        }

        buffer.close();
        saveMemoryInfo();

        m_memory.unlock();
        if( debugUxCache ) qDebug() << __PRETTY_FUNCTION__ << " unlock memory";

    }
}

void ImageProviderCache::addPixmapToMemory( const QString &id, const QPixmap &pixmap, const PixmapReference &reference )
{
    if( m_bMemoryReady ) {

        if( debugUxCache ) qDebug() << __PRETTY_FUNCTION__ << " lock memory";
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

        m_memory.unlock();

    }
}

void ImageProviderCache::addPixmapToX11Cache( const QString& id, const QPixmap& pixmap, const PixmapReference& reference )
{
    if( m_bMemoryReady ) {

        if( debugUxCache ) qDebug() << __PRETTY_FUNCTION__ << " lock memory";
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

        if( debugUxCache ) qDebug() << __PRETTY_FUNCTION__ << " unlock memory";
        m_memory.unlock();

    }
}

void ImageProviderCache::addPixmapToGlesCache( const QString& id, const QPixmap& pixmap, const PixmapReference& reference )
{
    Q_UNUSED( id );
    Q_UNUSED( pixmap );
    Q_UNUSED( reference );
    // to be implemented
}

// ~~~~~~ Shared Memory
void ImageProviderCache::readMemoryInfo()
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

void ImageProviderCache::saveMemoryInfo()
{
    if( m_bMemoryReady ) {

        if( (uint)m_pixmapTable.size() < m_memoryInfo.pixmapCount ) {

            if( debugUxTheme ) {
                qWarning() << "Pixmap count is out of Sync. internal Count: " << m_pixmapTable.size() << " external Count: " << m_memoryInfo.pixmapCount;
                qDebug() << "reset pixmap table, changes will not passed to shared memory ";
            }
            readMemoryInfo(); // sharedMemory wins!
            return;
        }

        if( (uint)m_imageTable.size() < m_memoryInfo.imageCount ) {

            if( debugUxTheme ) {
                qWarning() << "Image count is out of Sync. internal Count: " << m_imageTable.size() << " external Count: " << m_memoryInfo.imageCount;
                qDebug() << "reset image table, changes will not passed to shared memory ";
            }
            readMemoryInfo(); // sharedMemory wins!
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

void ImageProviderCache::saveImageInfo( int position, ImageReference& refTableInfo )
{
    if( m_bMemoryReady ) {

        QBuffer buffer;
        buffer.open(QBuffer::ReadWrite);
        QDataStream out(&buffer);

        refTableInfo.saveToStream( out );

        int size = buffer.size();

        if( debugUxCache ) qDebug() << __PRETTY_FUNCTION__ << " lock memory";
        m_memory.lock();

        char *to = (char*)( m_memoryInfo.calcPos( m_memoryInfo.imageTableBegin ) + ( position * streamImageReferenceSize ) );
        const char *from = buffer.data().data();
        memcpy( to, from, size );

        if( debugUxCache ) qDebug() << __PRETTY_FUNCTION__ << " unlock memory";
        m_memory.unlock();
    }
}

void ImageProviderCache::savePixmapInfo( int position, PixmapReference& refTableInfo )
{
    if( m_bMemoryReady ) {

        QBuffer buffer;
        buffer.open(QBuffer::ReadWrite);
        QDataStream out(&buffer);

        refTableInfo.saveToStream( out );

        int size = buffer.size();

        if( debugUxCache ) qDebug() << __PRETTY_FUNCTION__ << " lock memory";
        m_memory.lock();

        char *to = (char*)( m_memoryInfo.calcPos( m_memoryInfo.pixmapTableBegin ) + ( position * streamPixmapReferenceSize ) );
        const char *from = buffer.data().data();
        memcpy( to, from, size );

        if( debugUxCache ) qDebug() << __PRETTY_FUNCTION__ << " unlock memory";
        m_memory.unlock();
    }
}

void ImageProviderCache::attachSharedMemory()
{
    m_memory.setKey( m_key );

    if( !m_memory.create( m_size * 1024 * 1024 ) ) {

        if( !m_memory.attach() ) {

            m_bMemoryReady = false;

        } else {

            m_memoryInfo.cacheBegin = (uint)(char*)m_memory.data();
            m_memoryInfo.cacheSize = m_memory.size();
            m_memoryInfo.cacheEnd = m_memoryInfo.cacheBegin + m_memoryInfo.cacheSize;

            m_bMemoryReady = true;

            if( debugUxCache ) qDebug() << __PRETTY_FUNCTION__ << " lock memory";
            m_memory.lock();

            readMemoryInfo();
            m_memoryInfo.clientCount++;
            m_memoryInfo.incUpdate();
            saveMemoryInfo();

            if( debugUxCache ) qDebug() << __PRETTY_FUNCTION__ << " unlock memory";
            m_memory.unlock();

        }

    } else {

        createSharedMemory();
        m_bMemoryReady = true;        

    }

}

void ImageProviderCache::detachSharedMemory()
{
    if( m_memory.isAttached() ) {

        if( debugUxCache ) qDebug() << __PRETTY_FUNCTION__ << " lock memory";
        m_memory.lock();

        readMemoryInfo();
        m_memoryInfo.clientCount--;
        saveMemoryInfo();

        if( debugUxCache ) qDebug() << __PRETTY_FUNCTION__ << "unlock memory";
        m_memory.unlock();

        m_memory.detach();
    }
}

void ImageProviderCache::createSharedMemory()
{
    m_memory.lock();

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
    m_memory.unlock();

}

void ImageProviderCache::calcDataSize()
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

}

