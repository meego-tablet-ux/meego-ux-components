#include "imageprovidercachectrl.h"

#include <QFile>

//
// Private
//
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
            for( uint i = 0; i < m_memoryInfo.imageCount; i++ )
            {
                referenceTableInfo.loadFromStream( imageIn );

                bool bFound = false;
                for( int i = 0; i < m_imageTable.size(); i++ )
                {
                    if( m_imageTable[i].equal( referenceTableInfo ) ) {
                        m_imageTable[i].refCount = referenceTableInfo.refCount;
                        bFound = true;
                        break;
                    }
                }
                if( !bFound ) {
                    m_imageTable.append( referenceTableInfo );
                }
            }
            imageBuffer.close();

            // ~~~~~ pixmapReferences
            QBuffer pixmapBuffer;
            QDataStream pixmapIn(&pixmapBuffer);
            pixmapBuffer.setData( (char*) m_memoryInfo.calcPos( m_memoryInfo.pixmapTableBegin ), m_memoryInfo.pixmapTableSize );
            pixmapBuffer.open(QBuffer::ReadOnly);

            PixmapReference referenceInfo;
            for( uint i = 0; i < m_memoryInfo.pixmapCount; i++ )
            {
                referenceInfo.loadFromStream( pixmapIn );

                bool bFound = false;
                for( int i = 0; i < m_pixmapTable.size(); i++ )
                {
                    if( m_pixmapTable[i].equal( referenceInfo ) ) {
                        bFound = true;
                        break;
                    }
                }
                if( !bFound ) {
                    m_pixmapTable.append( referenceInfo );
                }
            }
            pixmapBuffer.close();
        }

    }
}

void ImageProviderCachePrivate::saveMemoryInfo()
{
    if( m_bMemoryReady ) {

        if( (uint)m_pixmapTable.size() < m_memoryInfo.pixmapCount ) {
            qWarning() << "Pixmap count is out of Sync. internal Count: " << m_pixmapTable.size() << " external Count: " << m_memoryInfo.pixmapCount;
        }

        if( (uint)m_imageTable.size() < m_memoryInfo.imageCount ) {
            qWarning() << "Image count is out of Sync. internal Count: " << m_imageTable.size() << " external Count: " << m_memoryInfo.imageCount;
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

        //qDebug() << "save";

        QBuffer buffer;
        buffer.open(QBuffer::ReadWrite);
        QDataStream out(&buffer);

        refTableInfo.saveToStream( out );

        int size = buffer.size();

        m_memory.lock();

        //qDebug() << "save";

        char *to = (char*)( m_memoryInfo.calcPos( m_memoryInfo.imageTableBegin ) + ( position * streamImageReferenceSize ) );
        const char *from = buffer.data().data();
        memcpy( to, from, size );

        //qDebug() << "save";

        // no update of memoryInfo -> clients don't need that info.

        m_memory.unlock();
    }
}

void ImageProviderCachePrivate::savePixmapInfo( int position, PixmapReference& refTableInfo )
{
    if( m_bMemoryReady ) {

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

            m_memory.lock();

            readMemoryInfo();
            m_memoryInfo.clientCount++;
            saveMemoryInfo();

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

        m_memory.lock();

        readMemoryInfo();
        m_memoryInfo.clientCount--;
        saveMemoryInfo();

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
    m_memory.unlock();

    m_bMemoryReady = true;
    return true;

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
            m_memory.lock();
            readMemoryInfo();

            m_memoryInfo.imageCount = 0;
            m_memoryInfo.pixmapCount = 0;
            m_memoryInfo.dataEnd = m_memoryInfo.dataBegin;

            saveMemoryInfo();
            m_memory.unlock();

            for( int i = 0 ; i < m_imageTable.size(); i++ )
            {
                //loadImage( m_imageTable.at(i);
            }
            for( int i = 0 ; i < m_pixmapTable.size(); i++ )
            {
                //loadPixmap( m_pixmapTable.at(i);
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
            m_memory.lock();
            readMemoryInfo();

            m_memoryInfo.imageCount = 0;
            m_memoryInfo.pixmapCount = 0;
            m_memoryInfo.dataEnd = m_memoryInfo.dataBegin;

            m_imageTable.clear();
            m_pixmapTable.clear();

            saveMemoryInfo();
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

    //qDebug() << "size ofa MemoryInfo: " << streamMemoryInfoSize;
    //qDebug() << "size of ImageReference: " << streamImageReferenceSize;
    //qDebug() << "size of PixmapReference: " << streamPixmapReferenceSize;

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
        list << QString("%1. Image: %2").arg( i+1 ).arg( m_imageTable[i].id() );
        list << QString("MemoryPosition: %1").arg( m_imageTable[i].memoryPosition );
        list << QString("MemorySize: %1").arg( m_imageTable[i].memorySize );
        list << QString("MemoryWidth: %1, MemoryHeight: %2").arg( m_imageTable[i].width).arg( m_imageTable[i].height );
    }

    for( int i = 0; i < m_pixmapTable.size(); i++)
    {
        list << QString("%1. Image: %2").arg( i+1 ).arg( m_pixmapTable[i].id() );
        list << QString("MemoryPosition: %1").arg( m_pixmapTable[i].memoryPosition );
        list << QString("MemorySize: %1").arg( m_pixmapTable[i].memorySize );
        list << QString("MemoryWidth: %1, MemoryHeight: %2").arg( m_pixmapTable[i].width).arg( m_pixmapTable[i].height );
    }

    list << QString( "End of Bulk" );

    return list;

}

//
// public
//
ImageProviderCacheCtrl::ImageProviderCacheCtrl( const QString ThemeName,  QObject *parent ) :
        QObject( parent ),
        m_private( new ImageProviderCachePrivate( ThemeName, this ) )
{

}

ImageProviderCacheCtrl::~ImageProviderCacheCtrl()
{
    delete m_private;
    m_private = 0;
}

ImageProviderCacheCtrl::Result ImageProviderCacheCtrl::createSharedMemory(int maxImages, int sizeInMb )
{
   bool bRet = m_private->createSharedMemory( maxImages, sizeInMb );

   if( bRet )
       return ImageProviderCacheCtrl::CacheCreated;

   return ImageProviderCacheCtrl::UndefinedError;

}
ImageProviderCacheCtrl::Result ImageProviderCacheCtrl::clearCache()
{
   bool bRet = m_private->clearSharedMemory();

   if( bRet )
       return ImageProviderCacheCtrl::CacheCleared;

   return ImageProviderCacheCtrl::UndefinedError;
}
ImageProviderCacheCtrl::Result ImageProviderCacheCtrl::preLoadCache()
{    
   bool bRet = m_private->loadPreLoadFile( "statistics" );

   if( bRet )
       return ImageProviderCacheCtrl::CacheReloaded;

   return ImageProviderCacheCtrl::UndefinedError;
}
ImageProviderCacheCtrl::Result ImageProviderCacheCtrl::reloadCache()
{
   bool bRet = m_private->reloadSharedMemory();

   if( bRet )
       return ImageProviderCacheCtrl::CacheReloaded;

   return ImageProviderCacheCtrl::UndefinedError;
}
ImageProviderCacheCtrl::Result ImageProviderCacheCtrl::savePayload( QString filename )
{
    bool bRet = m_private->savePreLoadFile( filename );

    if( bRet )
        return ImageProviderCacheCtrl::CacheSaved;

    return ImageProviderCacheCtrl::UndefinedError;
}
ImageProviderCacheCtrl::Result ImageProviderCacheCtrl::loadPayLoad( QString filename )
{
    bool bRet = m_private->loadPreLoadFile( filename );

    if( bRet)
        return ImageProviderCacheCtrl::CacheLoaded;

    return ImageProviderCacheCtrl::UndefinedError;
}
QStringList ImageProviderCacheCtrl::bulkCache()
{    
    QStringList list = m_private->bulk();

    return list;
}

