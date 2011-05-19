/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */


#ifndef SYSTEMICONPROVIDER_H
#define SYSTEMICONPROVIDER_H

#include <QDeclarativeImageProvider>

class ImageProviderCache;
class MGConfItem;

class SystemIconProvider : public QDeclarativeImageProvider
{
public:
    SystemIconProvider();
    ~SystemIconProvider();

    QImage requestImage( const QString &id, QSize *size, const QSize &requestedSize);
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize);

private:

    QPixmap readPixmapFromFile( const QString& file, const QSize& requestedSize );
    QImage readImageFromFile( const QString& file, const QSize& requestedSize );

    ImageProviderCache* m_cache;
    QString m_themePath;
};

#endif // SYSTEMICONPROVIDER_H
