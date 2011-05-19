/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#ifndef THEMEIMAGEPROVIDER_H
#define THEMEIMAGEPROVIDER_H

#include <QDeclarativeImageProvider>

class ImageProviderCache;
class MGConfItem;

class ThemeImageProvider : public QDeclarativeImageProvider
{
public:
    ThemeImageProvider();
    ~ThemeImageProvider();

    QImage requestImage( const QString &id, QSize *size, const QSize &requestedSize);
    QPixmap requestPixmap( const QString &id, QSize *size, const QSize &requestedSize);

    static ImageProviderCache* getCacheInstance();
    
private:    

    // static for borderimage workaround @see borderimagedecorator
    static ImageProviderCache* m_cache;
    QString m_themePath;
};

#endif // THEMEIMAGEPROVIDER_H
