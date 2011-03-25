#include <QApplication>
#include <QFile>
#include <QPixmap>
#include <QIcon>
#include <QString>
#include <QSize>
#include <QDesktopWidget>
#include <MGConfItem>
#include <QDebug>

#include "themedimageprovider.h"

#define THEME_KEY "/meego/ux/theme"

ThemedImageProvider::ThemedImageProvider() :
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

ThemedImageProvider::~ThemedImageProvider()
{
    delete themeItem;
}

QPixmap ThemedImageProvider::requestPixmap(const QString &id, QSize *size,
                                           const QSize &requestedSize)
{
    QPixmap pixmap;
    int width = requestedSize.width();
    int height = requestedSize.height();

    QString themeDir = QString("/usr/share/themes/") + themeItem->value().toString() + "/images/";
    if( !QFile::exists(themeDir + id + ".png") ){
        themeDir = QString("/usr/share/themes/") + themeItem->value().toString() + "/widgets/common/";
    }

    //  If we have a custom icon then use it
    if (QFile::exists(themeDir + id + ".png"))
    {
        pixmap.load(themeDir + id + ".png");

        if (width > 0 && height > 0)
        {
            pixmap = pixmap.scaled(QSize(width, height));
        }
        else if (width > 0)
        {
            pixmap = pixmap.scaledToWidth(width);
        }
        else if (height > 0)
        {
            pixmap = pixmap.scaledToHeight(height);
        }
    }
    else
    {
        // Return a red pixmap to assist in finding missing images
        if (width <= 0)
            width = 100;
        if (height <= 0)
            height = 100;
        pixmap = QPixmap(QSize(width, height));
        pixmap.fill(Qt::red);
    }

    if (size)
        *size = pixmap.size();

    return pixmap;
}
