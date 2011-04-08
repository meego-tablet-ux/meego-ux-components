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
#include <mgconfitem.h>


#include "systemiconprovider.h"

#define THEME_KEY "/meego/ux/theme"

SystemIconProvider::SystemIconProvider() :
        QDeclarativeImageProvider(QDeclarativeImageProvider::Pixmap)
{
    themeItem = new MGConfItem(THEME_KEY);
    if (themeItem->value().isNull() ||
            !QFile::exists(QString("/usr/share/themes/") + themeItem->value().toString()))
    {
        QRect screenRect = qApp->desktop()->screenGeometry();

        // TODO: Check both the resolution and the DPI to determine the default
        //       theme location

        if (screenRect.width() == 1024 && screenRect.height() == 600)
            themeItem->set("1024-600-10");
        else if (screenRect.width() == 1280 && screenRect.height() == 800)
            themeItem->set("1280-800-7");
        else
            // fallback to something...
            themeItem->set("1024-600-10");
    }
}

SystemIconProvider::~SystemIconProvider()
{
    delete themeItem;
}

QPixmap SystemIconProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    int width = requestedSize.width() > 0 ? requestedSize.width() : 100;
    int height = requestedSize.height() > 0 ? requestedSize.height() : 100;

    const QString themePath = QLatin1String("/usr/share/themes/") + themeItem->value().toString();
    QString pathName;

    if (size)
    {
        *size = QSize(width, height);
    }

    // Determine if the request is for a real file
    if (id.startsWith('/'))
    {
        if (QFile::exists(id))
        {
            pathName = id;
        }
    }
    else
    {
        // Perhaps it's for an icon ID?
        const QString launcherPath = themePath + QLatin1String("/icons/launchers/") + id + QLatin1String(".png");

        if (QFile::exists(launcherPath)) {
            pathName = launcherPath;
        } else
        {
            // Perhaps it's for an icon settigns?
            const QString settingsPath = themePath + QLatin1String("/icons/settings/") + id + QLatin1String(".png");
            
            if (QFile::exists(settingsPath))
                pathName = settingsPath;
        }
    }

    if (!pathName.isNull())
    {
        // Try load the image from disk
        QImageReader imageReader(pathName);
        QPixmap pixmap;

        if (requestedSize.isValid() &&
            requestedSize != imageReader.size())
        {
            imageReader.setScaledSize(requestedSize);
        }

        pixmap = QPixmap::fromImageReader(&imageReader);
        if (size)
            *size = pixmap.size();

        return pixmap;
    }
    else if (QIcon::hasThemeIcon(id))
    {
        ///according to docs, this will return a pixmap of at-max, width,height.
        ///However, it may return a smaller pixmap.
        if(size)
            *size = QIcon::fromTheme(id).actualSize(QSize(width, height));
        return QIcon::fromTheme(id).pixmap(QSize(width, height));
    }

    // Default icon?
    return QPixmap(requestedSize);
}
