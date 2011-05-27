/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#include <QApplication>
#include <QFile>
#include <QPixmap>
#include <QIcon>
#include <QString>
#include <QSize>
#include <QDesktopWidget>
#include <QDebug>
#include <QImageReader>
#include <MGConfItem>
#include <QDebug>

#include "systemiconprovider.h"
#include "imageprovidercache.h"

#define THEME_KEY "/meego/ux/theme"

SystemIconProvider::SystemIconProvider() :
        QDeclarativeImageProvider(QDeclarativeImageProvider::Pixmap),
        m_cache( new ImageProviderCache( QString("SystemIconProviderCache%1").arg(THEME_KEY), 256, 8 ) )
{
    MGConfItem* themeItem = new MGConfItem(THEME_KEY);

    if( themeItem ) {

        if (themeItem->value().isNull() || themeItem->value().toString().isEmpty() ||
            !QFile::exists(QString("/usr/share/themes/") + themeItem->value().toString()))
        {
            QRect screenRect = qApp->desktop()->screenGeometry();

            if (screenRect.width() == 1024 && screenRect.height() == 600)
                themeItem->set("1024-600-10");
            else if (screenRect.height() == 1024 && screenRect.width() == 600)
                themeItem->set("1024-600-10");
            else if (screenRect.width() == 1280 && screenRect.height() == 800)
                themeItem->set("1280-800-7");
            else if (screenRect.height() == 1280 && screenRect.width() == 800)
                themeItem->set("1280-800-7");
            else
                // fallback to something...
                themeItem->set("1024-600-10");
        }

        if( themeItem->value().toString().isEmpty() ) {

            m_themePath = QString("/usr/share/themes/") + QString("1024-600-10") + "/";

        } else {

            m_themePath = QString("/usr/share/themes/") + themeItem->value().toString() + "/";
        }

        delete themeItem;
        themeItem = 0;
    }
    m_cache->setPath( m_themePath );
}

SystemIconProvider::~SystemIconProvider()
{
    delete m_cache;
    m_cache = 0;
}

QImage SystemIconProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{    
    if ( id.startsWith('/') ) // Determine if the request is for a real file
    {
        if (QFile::exists(id)) {

            QImage image = readImageFromFile( id, requestedSize );
            if (size)
                *size = image.size();
            return image;

        }

    } else if ( QIcon::hasThemeIcon(id) ) { // Perhaps it's for an icon ID?

        if(size)
            *size = QIcon::fromTheme(id).actualSize( requestedSize );
                return QImage( QIcon::fromTheme(id).pixmap( requestedSize ).toImage() );

    } else { // Seek in path

        const QString launcherPath = m_themePath + QLatin1String("icons/launchers/") + id + QLatin1String(".png");
        const QString settingsPath = m_themePath + QLatin1String("icons/settings/") + id + QLatin1String(".png");

        if ( QFile::exists( launcherPath ) ) {

            QImage image = readImageFromFile( id, requestedSize );
            if (size)
                *size = image.size();
            return image;

        } else if ( QFile::exists( settingsPath ) ) {

            QImage image = readImageFromFile( id, requestedSize );
            if (size)
                *size = image.size();
            return image;

        }
    }

    QImage image = m_cache->requestImage( m_themePath + id, size, requestedSize );
    return image;

}

QPixmap SystemIconProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{    
    if ( id.startsWith('/') ) // Determine if the request is for a real file
    {
        if (QFile::exists(id)) {

            QPixmap pixmap = readPixmapFromFile( id, requestedSize );
            if (size)
                *size = pixmap.size();
            return pixmap;

        }

    } else if ( QIcon::hasThemeIcon(id) ) { // Perhaps it's for an icon ID?

        if(size)
            *size = QIcon::fromTheme(id).actualSize( requestedSize );
        return QIcon::fromTheme(id).pixmap( requestedSize );

    } else { // Seek in path

        const QString launcherPath = m_themePath + QLatin1String("icons/launchers/") + id + QLatin1String(".png");
        const QString settingsPath = m_themePath + QLatin1String("icons/settings/") + id + QLatin1String(".png");

        if ( QFile::exists( launcherPath ) ) {

            QPixmap pixmap = readPixmapFromFile( launcherPath, requestedSize );
            if (size)
                *size = pixmap.size();
            return pixmap;

        } else if ( QFile::exists( settingsPath ) ) {

            QPixmap pixmap = readPixmapFromFile( settingsPath, requestedSize );
            if (size)
                *size = pixmap.size();
            return pixmap;

        }
    }

    QPixmap pixmap = m_cache->requestPixmap( m_themePath + id, size, requestedSize );
    if (size)
        *size = pixmap.size();
    return pixmap;
}

QImage SystemIconProvider::readImageFromFile(const QString &file, const QSize &requestedSize)
{
    QImageReader imageReader(file);
    if (requestedSize.isValid() &&
        requestedSize != imageReader.size())
    {
        imageReader.setScaledSize( requestedSize );
    }
    return imageReader.read();
}
QPixmap SystemIconProvider::readPixmapFromFile(const QString &file, const QSize &requestedSize)
{
    QImageReader imageReader(file);
    if (requestedSize.isValid() &&
        requestedSize != imageReader.size())
    {
        imageReader.setScaledSize( requestedSize );
    }
    return QPixmap::fromImageReader( &imageReader );
}
