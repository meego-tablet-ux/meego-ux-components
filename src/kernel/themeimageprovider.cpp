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
#include <MGConfItem>
#include <QDebug>
#include <QImageReader>
#include "themeimageprovider.h"
#include "imageprovidercache.h"

#define THEME_KEY "/meego/ux/theme"

ImageProviderCache* ThemeImageProvider::m_cache = 0;

ImageProviderCache* ThemeImageProvider::getCacheInstance()
{
    if( m_cache == 0 ) {
        qDebug() << "create ImageProviderInstance" << QString("ImageProviderCache%1").arg(THEME_KEY);
        m_cache = new ImageProviderCache( QString("ImageProviderCache%1").arg(THEME_KEY), 512, 16 );
    }
    return m_cache;
}

ThemeImageProvider::ThemeImageProvider() :
        QDeclarativeImageProvider(QDeclarativeImageProvider::Image)
{
    ThemeImageProvider::getCacheInstance();

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

    ThemeImageProvider::m_cache->setPath( m_themePath );

}

ThemeImageProvider::~ThemeImageProvider()
{
}

QImage ThemeImageProvider::requestImage( const QString &id, QSize *size, const QSize &requestedSize)
{
    QString path = m_themePath + id;   
    return ThemeImageProvider::m_cache->requestImage( path, size, requestedSize );
}
/*
QPixmap ThemeImageProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    QString path = m_themePath + id;
    return ThemeImageProvider::m_cache->requestPixmap( path, size, requestedSize );
}
*/
