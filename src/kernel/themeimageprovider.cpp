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
    MGConfItem* themeItem = new MGConfItem(THEME_KEY);

    if( themeItem ) {
        qDebug() << themeItem->value().toString();

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

    qDebug() << m_themePath;

}

ThemeImageProvider::~ThemeImageProvider()
{    
}

QImage ThemeImageProvider::requestImage( const QString &id, QSize *size, const QSize &requestedSize)
{
    QString path = m_themePath + id;
    return m_cache.requestImage( path, size, requestedSize );
}

QPixmap ThemeImageProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    QString path = m_themePath + id;
    return m_cache.requestPixmap( path, size, requestedSize );    
}
