/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */


#include <QApplication>
#include <QX11Info>
#include "windowlistener.h"
#include "windowelement.h"

WindowListener *WindowListener::windowListenerInstance = NULL;

WindowListener::WindowListener(QObject *parent) :
    QObject(parent)
{
    connect(qApp , SIGNAL(windowListUpdated(QList<WindowInfo>)), this, SLOT(windowListUpdated(QList<WindowInfo>)));
}

WindowListener::~WindowListener()
{
}

WindowListener *WindowListener::instance()
{
    if (windowListenerInstance)
        return windowListenerInstance;

    windowListenerInstance = new WindowListener;
    return windowListenerInstance;
}

void WindowListener::windowListUpdated(const QList<WindowInfo> &windowList)
{

    while (!items.isEmpty())
        delete items.takeLast();

    Q_FOREACH (WindowInfo info, windowList)
    {
        items << new WindowElement(info);
    }

    emit updated();
}
