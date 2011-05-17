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

#define THEME_KEY "/meego/ux/theme"

ThemeImageProvider::ThemeImageProvider() :
        QDeclarativeImageProvider(QDeclarativeImageProvider::Image),
        m_cache( QString("IconImageProvider%1").arg(THEME_KEY), 512, 16 )
{
    themeItem = new MGConfItem(THEME_KEY);
    if (themeItem->value().isNull() ||
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
}

ThemeImageProvider::~ThemeImageProvider()
{
    delete themeItem;
}

QImage ThemeImageProvider::requestImage( const QString &id, QSize *size, const QSize &requestedSize)
{
    QString path = QString("/usr/share/themes/") + themeItem->value().toString() + "/" + id;
    return m_cache.requestImage( path, size, requestedSize );
}

QPixmap ThemeImageProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    QString path = QString("/usr/share/themes/") + themeItem->value().toString() + "/" + id;
    return m_cache.requestPixmap( path, size, requestedSize );
    /* deprecated
    QPixmap pixmap;

    QString themeDir = QString("/usr/share/themes/") + themeItem->value().toString() + "/";

    //  If we have a custom icon then use it
    if (QFile::exists(themeDir + id + ".png"))
    {
        QImageReader imageReader(themeDir + id + ".png");

        if (requestedSize.isValid())
        {
            imageReader.setScaledSize(requestedSize);
        }

        pixmap = QPixmap::fromImageReader(&imageReader);
    }
    else
    {
        // Return a red pixmap to assist in finding missing images
        int width = requestedSize.width();
        int height = requestedSize.height();

        if (width <= 0)
            width = 100;
        if (height <= 0)
            height = 100;
        pixmap = QPixmap(QSize(width, height));
        pixmap.fill(Qt::red);
    }

    if (size)
        *size = pixmap.size();

    return pixmap; */
}
