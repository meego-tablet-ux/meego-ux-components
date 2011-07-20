/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

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

class ImageProviderCachePrivate;

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
    QStringList verifyCache( bool errorsOnly = false );

private:

    ImageProviderCachePrivate* m_private;

};

#endif // IMAGEPROVIDERCACHECTRL_H
