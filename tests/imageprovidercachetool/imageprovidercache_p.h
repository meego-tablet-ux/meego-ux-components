/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#ifndef IMAGEPROVIDERCACHEP_H
#define IMAGEPROVIDERCACHEP_H

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

#include "imagereference.h"
#include "memoryinfo.h"

class ImageProviderCachePrivate : public QObject
{
    Q_OBJECT
public:
    explicit ImageProviderCachePrivate( const QString memoryName, QObject* parent );
    virtual ~ImageProviderCachePrivate();

    // Image and Pixmap loading

    /*! this method returns a requested QPixmap*/
    QPixmap loadPixmap( const QString &id );
    /*! this method returns a requested QImage*/
    QImage loadImage( const QString &id );

    // Image and Pixmap cache

    bool containsImage( const QString &id, const QSize &size );
    bool containsPixmap( const QString &id, const QSize &size );
    bool existSciFile( const QString & id );

    QImage  loadImageFromMemory( const QString &id, const QSize &size );
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

    bool attachSharedMemory();
    bool createSharedMemory( int maxImages, int sizeInMb );
    bool detachSharedMemory();
    bool reloadSharedMemory();
    bool clearSharedMemory();

    QStringList bulk();
    QStringList verify( bool errorsOnly );

    /*! saves the list of the most referenced images for the next start
     * \warning only the first client does that!
     */
    bool savePreLoadFile( QString filename );
    /*! loads the list of the most referenced images and loads them
     * \warning only the last client does that!
     */
    bool loadPreLoadFile( QString filename );
    /*! read the memory info from sharedmemory in order to have synced data */
    void readMemoryInfo();
    /*! save the memory info from sharedmemory in order to have synced data */
    void saveMemoryInfo();
    /*! save referenceCount of an image */
    void saveImageInfo( int position, ImageReference &refTableInfo );
    /*! save referenceCount of a pixmap */
    void savePixmapInfo( int position, PixmapReference &refTableInfo );
    /*! cleares the shared memory */
    bool clearMemoryInfo( int maxImages );

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

#endif //IMAGEPROVIDERCACHEP_H
