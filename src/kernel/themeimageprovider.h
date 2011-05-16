#ifndef THEMEIMAGEPROVIDER_H
#define THEMEIMAGEPROVIDER_H

#include <QDeclarativeImageProvider>
#include "imageprovidercache.h"

class MGConfItem;

class ThemeImageProvider : public QDeclarativeImageProvider
{
    static ImageProviderCache* m_cache;
public:

    static ImageProviderCache* getCacheInstance();

    ThemeImageProvider();
    ~ThemeImageProvider();

    QImage requestImage( const QString &id, QSize *size, const QSize &requestedSize);
    QPixmap requestPixmap( const QString &id, QSize *size, const QSize &requestedSize);

private:
    MGConfItem *themeItem;
};

#endif // THEMEIMAGEPROVIDER_H
