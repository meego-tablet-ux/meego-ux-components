/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#ifndef MEEGOUNITS_H
#define MEEGOUNITS_H

#include <QObject>

class UnitsPrivate;
class Units : public QObject
{
    Q_OBJECT

public:
    Units(QObject *parent = NULL);
    virtual ~Units();

public:
    Q_PROPERTY(qreal density READ density WRITE setDensity NOTIFY densityChanged);
    Q_PROPERTY(qreal mm READ mm NOTIFY mmChanged);
    Q_PROPERTY(qreal vp READ vp NOTIFY vpChanged);
    Q_PROPERTY(qreal inch READ inch NOTIFY inchChanged);

public:
    qreal density() const;
    void setDensity(qreal density);
    qreal mm() const;
    qreal vp() const;
    qreal inch() const;

signals:
    void densityChanged();
    void mmChanged();
    void vpChanged();
    void inchChanged();

private:
    UnitsPrivate *d_ptr;

    Q_DISABLE_COPY(Units)
    Q_DECLARE_PRIVATE_D(d_ptr, Units)
};

#endif
