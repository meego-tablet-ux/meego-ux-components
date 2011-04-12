/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#ifndef WINDOWWINDOWPROVIDER_H
#define WINDOWWINDOWPROVIDER_H

#include <QDeclarativeImageProvider>
#include "windowlistener.h"

class WindowIconProvider : public QDeclarativeImageProvider
{
public:
    WindowIconProvider();
    ~WindowIconProvider();

    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize);

private:
    WindowListener *listener;
};

#endif // WINDOWWINDOWPROVIDER_H
