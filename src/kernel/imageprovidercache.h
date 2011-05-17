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

/*! \class ImageProviderCache
  this class is instatiated per client and managing a connection to a SharedMemory, accessible
  for all ImageProviders.

  The very fist ImageProviderCache will create the shared memory file and preload a set of
  important images based on the statistics file. The last ImageProvider alive will remove
  the shared memory, but save a statitics file in order to update the list of most used files
  which should be loaded.

  \section1 Content of the shared memory:
  _____________
  MemoryInfo        basic information header
  _____________
  ImageTable(n)     fixed size Table of all ImageReference, which will be also stored inside the
                    Shared memory
  _____________
  PixmapTable(n)    fixed size Table of all ImageReference, only reference to XServer
                    is stored here
  _____________
  ThemeInfo         dynamic sized theme information, loaded once! to be done.
  _____________
  Images            loaded QImages and QPixmaps (if option is on).
  ......
  _____________

  \section1 State of caching:

  This class support 3 layers of caching:

  Layer1: Global QImage Cache
  In order to load each Image only once (until the cache is full) the QImages are stored inside the
  SharedMemory. This way all other clients don't have to read the QImages needed from the Disk.

  Layer2: Global QPixmap Cache:

  Pixmaps are hosted in the X11 Server and managed by a handle. This handle can be reused across processes.
  In Layer2 all the resized Pixmap are referenced directly in order to reduce even more speed.

  Layer3: Embedded QML Cache
  In the QDeclarativeEngie the QPixmaps are cached per process by default. This mechanism is still used,
  however the initial loading of a process is speeded up by layer 1 and layer 2.

   \\FIXME statistic must be considerd to have an aged statistic
   \\FIXME name of the statistics file / place to store is unclear
 */
class ImageProviderCache : public QObject
{
    Q_OBJECT

public:
    /*! Constructor
        \param const QString ThemeName name of the theme in order to connect to correct shared memory
        \param int maxImages: Max amount of Images, the cache should hold
        \param int sizeInMb: the Size of the SharedMemory in Mb
    */
    explicit ImageProviderCache( const QString ThemeName, int maxImages = 512 , int sizeInMb = 32, QObject *parent = 0 );
    /*! Destructor */
    virtual ~ImageProviderCache();

    /*! this method returns a requested QPixmap*/
    QPixmap requestPixmap( const QString &id, QSize *size, const QSize &requestedSize = QSize() );
    /*! this method returns a requested QImage*/
    QImage requestImage( const QString &id, QSize *size, const QSize &requestedSize = QSize() );

    void requestBorderGrid( const QString &id, int &borderTop, int &borderBottom, int &borderLeft, int &borderRight );
    void setPath( const QString path) { m_path = path; }

    //FIXME to be removed
    void bulk();

private:

    // ~~~~~~~ Private Implementation

    bool existImage( const QString &id, const QSize &size );
    bool existPixmap( const QString &id, const QSize &size );
    bool existSciFile( const QString &id );

    QImage requestImage( const QString &id, bool saveToMemory, QSize *size, const QSize &requestedSize = QSize() );

    QImage loadImageFromMemory( const QString &id, const QSize &size );
    QPixmap loadPixmapFromMemory( const QString &id, const QSize &size );
    QPixmap loadPixmapFromXServer( const QString &id, const QSize &size );
    QPixmap loadPixmapFromGles( const QString &id, const QSize &size );

    ImageReference loadSciFile( const QString &id );

    bool isResizedImageWorthCaching( const QString &id );

    void addImageToMemory( const QString &id, const QImage &image, const ImageReference &reference = ImageReference() );
    void addPixmapToMemory( const QString &id, const QPixmap &pixmap, const PixmapReference &reference = PixmapReference() );
    void addPixmapToX11Cache( const QString &id, const QPixmap &pixmap, const PixmapReference &reference = PixmapReference() );
    void addPixmapToGlesCache( const QString &id, const QPixmap &pixmap, const PixmapReference &reference = PixmapReference() );

    // ~~~~~~~ QSharedMemory Handling

    /*! read the memory info from sharedmemory in order to have synced data */
    void readMemoryInfo();
    /*! save the memory info from sharedmemory in order to have synced data */
    void saveMemoryInfo();
    /*! save referenceCount of an image */
    void saveImageInfo( int position, ImageReference &refTableInfo );
    /*! save referenceCount of a pixmap */
    void savePixmapInfo( int position, PixmapReference &refTableInfo );

    /*! saves the list of the most referenced images for the next start
     * \warning only the first client does that!
     */
    //FIXME: save List with statistics and aged information
    void savePreLoadFile();
    /*! loads the list of the most referenced images and loads them
     * \warning only the last client does that!
     */
    //FIXME: save List with statistics and aged information
    void loadPreLoadFile();

    void attachSharedMemory();
    void detachSharedMemory();
    void createShareMemory();

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

    QImage m_emptyImage;
    QPixmap m_emptyPixmap;
    QString m_filename;

    QString m_path;

    int streamMemoryInfoSize;
    int streamImageReferenceSize;
    int streamPixmapReferenceSize;

};

#endif // IMAGEPROVIDERCACHE_H
