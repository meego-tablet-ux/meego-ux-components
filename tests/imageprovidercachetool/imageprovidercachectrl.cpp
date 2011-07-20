/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#include "imageprovidercachectrl.h"
#include "imageprovidercache_p.h"

#include <QFile>

static const bool debugCache = (getenv("DEBUG_UXTHEME") != NULL);

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
QStringList ImageProviderCacheCtrl::verifyCache( bool errorsOnly )
{
    QStringList list = m_private->verify( errorsOnly );

    return list;
}

