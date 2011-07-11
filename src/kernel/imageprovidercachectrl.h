#ifndef IMAGEPROVIDERCACHECTRL_H
#define IMAGEPROVIDERCACHECTRL_H

#include <QObject>
#include <QStringList>

#include <QObject>
#include <QString>
#include <QBuffer>
#include <QDataStream>
#include <QSize>
#include <QImage>
#include <QImageReader>
#include <QPixmap>
#include <QPixmapCache>
#include <QSharedMemory>

#include "memoryinfo.h"
#include "imagereference.h"

class ImageProviderCachePrivate : public QObject
{
    Q_OBJECT
public:
    explicit ImageProviderCachePrivate( const QString memoryName, QObject* parent );
    virtual ~ImageProviderCachePrivate();

    bool attachSharedMemory();
    bool createSharedMemory( int maxImages, int sizeInMb );
    bool detachSharedMemory();
    bool clearSharedMemory();
    bool reloadSharedMemory();

    QStringList bulk();

    /*! saves the list of the most referenced images for the next start
     * \warning only the first client does that!
     */
    bool savePreLoadFile( QString filename );
    /*! loads the list of the most referenced images and loads them
     * \warning only the last client does that!
     */
    bool loadPreLoadFile( QString filename );

    // ~~~~~~~ QSharedMemory Handling

    /*! read the memory info from sharedmemory in order to have synced data */
    void readMemoryInfo();
    /*! save the memory info from sharedmemory in order to have synced data */
    void saveMemoryInfo();
    /*! save referenceCount of an image */
    void saveImageInfo( int position, ImageReference &refTableInfo );
    /*! save referenceCount of a pixmap */
    void savePixmapInfo( int position, PixmapReference &refTableInfo );

    void calcDataSize();

    // ~~~~~~~ Member

    bool m_bMemoryReady;

    enum ePixmapHandling {

        saveToMemory = 0,
        cacheInX11 = 1,
        cacheInGles = 2

    };

    ePixmapHandling m_pixmapHandling;

    QSharedMemory m_memory;
    MemoryInfo m_memoryInfo;
    QList<ImageReference> m_imageTable;
    QList<PixmapReference> m_pixmapTable;

    uint m_lastUpdate;
    QString m_key;
    int m_size;
    int m_images;

    QString m_filename;

    int streamMemoryInfoSize;
    int streamImageReferenceSize;
    int streamPixmapReferenceSize;

};

class ImageProviderCacheCtrl : public QObject
{
    Q_OBJECT
public:
    explicit ImageProviderCacheCtrl(const QString memoryName, QObject *parent = 0 );
    virtual ~ImageProviderCacheCtrl();

    enum Result {
        None,
        MemoryNotFound,
        CacheCreated,
        CacheCleared,
        CacheReloaded,
        CacheSaved,
        CacheLoaded,
        UndefinedError
    };

    ImageProviderCacheCtrl::Result createSharedMemory( int maxImages = 512 , int sizeInMb = 32 );
    ImageProviderCacheCtrl::Result clearCache();
    ImageProviderCacheCtrl::Result preLoadCache();
    ImageProviderCacheCtrl::Result reloadCache();
    ImageProviderCacheCtrl::Result savePayload( QString filename = QString() );
    ImageProviderCacheCtrl::Result loadPayLoad( QString filename = QString() );

    QStringList bulkCache();

private:

    ImageProviderCachePrivate* m_private;

};

#endif // IMAGEPROVIDERCACHECTRL_H
