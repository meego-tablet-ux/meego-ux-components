/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#ifndef QMLDEBUGTOOLS_H
#define QMLDEBUGTOOLS_H

#include <QObject>
#include <QFile>
#include <QTextStream>

class QmlDebugTools : public QObject
{
    Q_OBJECT
public:

    explicit QmlDebugTools();
    Q_INVOKABLE void writetofile( const QString& ,const QString& );


};

#endif // QMLDEBUGTOOLS_H
