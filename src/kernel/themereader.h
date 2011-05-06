#ifndef THEMEREADER_H
#define THEMEREADER_H

/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This class supplies a method to read a text file and write the listed values
   as javascript variables in a javascript file. Every line in the input file
   that doesn't start with a "#" is written as a line into the javascript file in the
   form "var <read line>". This fits to the contents of the theme.ini files
   in meego-ux-theme (2011-05-06). The Intel LGPL header is also written to the file. */

#include <QObject>

class themereader : public QObject
{
    Q_OBJECT
public:
    explicit themereader(QObject *parent = 0);

    bool readIni( QString _iniFile, QString _themeFile );

signals:

public slots:

};

#endif // THEMEREADER_H
