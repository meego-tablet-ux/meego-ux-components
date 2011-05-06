/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#include "themereader.h"
#include <QFile>
#include <QTextStream>
#include <QDebug>

themereader::themereader(QObject *parent) :
    QObject(parent)
{

}

bool themereader::readIni( QString _iniFile, QString _themeFile ) {

    QFile iniFile( _iniFile );

    if( !iniFile.open( QFile::ReadOnly ) ) {
        qDebug() << "Couldn't open ini file";
        return false;
    }
    QTextStream in( &iniFile );

    QFile themeFile( _themeFile );

    if( !themeFile.open( QFile::WriteOnly ) ) {
        qDebug() << "Couldn't open theme file";
        return false;
    }

    QTextStream out( &themeFile );

    QString line;

    out << "/*" << endl;
    out << " * Copyright 2011 Intel Corporation." << endl;
    out << " *" << endl;
    out << " * This program is licensed under the terms and conditions of the" << endl;
    out << " * LGPL, version 2.1.  The full text of the LGPL Licence is at" << endl;
    out << " * http://www.gnu.org/licenses/lgpl.html" << endl;
    out << " */" << endl << endl;

    out << ".pragma library" << endl;

    while( !in.atEnd() ) {
        line = in.readLine();

        if( line.startsWith( "#" ) ) {
            continue;
        }else {
            line = line.trimmed();
            out << "var " << line << endl;
        }
    }

    iniFile.close();
    themeFile.close();

    return true;
}
