/*
 * Copyright 2011 Wind River Systems
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */
#ifndef _PREEDITINJECTOR_H
#define _PREEDITINJECTOR_H

#include <QDeclarativeExtensionPlugin>
#include <QInputContext>

class PreeditInjector : public QObject {
    Q_OBJECT;
public:
    Q_INVOKABLE void inject(QObject* editor, int start, int len);
};

#endif // _PREEDITINJECTOR_H
