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
        QDeclarativeImageProvider(QDeclarativeImageProvider::Pixmap),
        m_cache( 
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

ThemeImageProvider::~ThemeImageProvider()
{
    delete themeItem;
}

QPixmap ThemeImageProvider::requestPixmap(const QString &id, QSize *size,
                                           const QSize &requestedSize)
{
    QString path = QString("/usr/share/themes/") + themeItem->value().toString() + "/" + id;
    return m_cache.requestPixmap( path, size, requestedSize );
}

QImage ThemeImageProvider::requestImage( const QString &id, QSize *size,
                                           const QSize &requestedSize)
{
    QString path = QString("/usr/share/themes/") + themeItem->value().toString() + "/" + id;
    return m_cache.requestImage( path, size, requestedSize );

}
