#ifndef THEMEIMAGEPROVIDER_H
#define THEMEIMAGEPROVIDER_H

#include <QDeclarativeImageProvider>
#include "imageprovidercache.h"

class MGConfItem;

class ThemeImageProvider : public QDeclarativeImageProvider
{
public:
    ThemeImageProvider();
    ~ThemeImageProvider();

    QImage requestImage( const QString &id, QSize *size, const QSize &requestedSize);
    QPixmap requestPixmap( const QString &id, QSize *size, const QSize &requestedSize);

private:    
    ImageProviderCache m_cache;
    QString m_themePath;
};

#endif // THEMEIMAGEPROVIDER_H
