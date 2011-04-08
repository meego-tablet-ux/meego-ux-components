/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */


#ifndef WINDOWLISTENER_H
#define WINDOWLISTENER_H

#include <QObject>
#include <X11/X.h>

class WindowElement;
class WindowInfo;

class WindowListener : public QObject
{
    Q_OBJECT
public:
    WindowListener(QObject *parent = 0);
    ~WindowListener();

    static WindowListener *instance();

    int count() {
        return items.count();
    }

    WindowElement *elementAt(int index) {
        if (index < 0 || index > items.length() - 1)
            return NULL;
        return items[index];
    }

signals:
    void updated();

public slots:
    void windowListUpdated(const QList<WindowInfo> &windowList);

private:
    QList<WindowElement *> items;
    Atom closeWindowAtom;
    Atom activeWindowAtom;

    static WindowListener *windowListenerInstance;
};

#endif // WINDOWLISTENER_H
