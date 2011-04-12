/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */


#include "qmldebugtools.h"
#include <QDebug>
#include <QString>


QmlDebugTools::QmlDebugTools():
        QObject()
{


}

void QmlDebugTools::writetofile(const QString &nameofFile,
                                const QString &message)
{

    QFile aFile(nameofFile);

    if ( aFile.open(QIODevice::WriteOnly | QIODevice::Append) )
    {
         aFile.write( message.toUtf8());
         aFile.write( "\n");
    }
    aFile.close();
}
