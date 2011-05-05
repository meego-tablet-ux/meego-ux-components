#ifndef IMAGEPROVIDERCACHE_H
#define IMAGEPROVIDERCACHE_H

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

/*!

 */
class ImageProviderCache : public QObject
{
    Q_OBJECT

public:
    explicit ImageProviderCache(  uint maxImages = 512 , uint sizeInMb = 32, QObject *parent = 0 );
    virtual ~ImageProviderCache();

    QImage requestImage( const QString &id, QSize *size, const QSize &requestedSize = QSize() );
    QPixmap requestPixmap( const QString &id, QSize *size, const QSize &requestedSize = QSize() );

    void bulk();

private:

    // ~~~~~~~ Private Implementation

    bool existImage( const QString &id, const QSize &size );
    bool existPixmap( const QString &id, const QSize &size );
    bool existSciFile( const QString &id );

    QImage loadImageFromMemory( const QString &id, const QSize &size );
    QPixmap loadPixmapFromXServer( const QString &id, const QSize &size );

    ImageReference loadSciFile( const QString &id );

    bool isResizedImageWorthCaching( const QString &id );
    void addImageToMemory( const QString &id, const QImage &image, const ImageReference &reference = ImageReference() );
    void addPixMapToCache( const QString &id, const QPixmap &pixmap, const PixmapReference &reference = PixmapReference() );

    // ~~~~~~~ SharedMemory Handling

    /*! read the memory info from sharedmemory in order to have synced data */
    void readMemoryInfo();
    /*! save the memory info from sharedmemory in order to have synced data */
    void saveMemoryInfo();
    /*! save referenceCount of an image */
    void saveImageInfo( int position, ImageReference &refTableInfo );
    void savePixmapInfo( int position, PixmapReference &refTableInfo );

    /*! saves the list of the most referenced images for the next start */
    void savePreLoadFile();
    /*! loads the list of the most referenced images and loads them */
    void loadPreLoadFile();

    void attachSharedMemory();
    void detachSharedMemory();
    void createShareMemory();

    // ~~~~~~~ Member

    bool m_bMemoryReady;

    QSharedMemory m_memory;
    MemoryInfo m_memoryInfo;
    QList<ImageReference> m_imageTable;
    QList<PixmapReference> m_pixmapTable;

    uint m_lastUpdate;
    QString m_key;
    uint m_size;
    uint m_images;

    QImage m_emptyImage;
    QPixmap m_emptyPixmap;
    QString m_filename;

};

#endif // IMAGEPROVIDERCACHE_H
