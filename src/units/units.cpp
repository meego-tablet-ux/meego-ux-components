/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#include <QObject>
#include "units.h"
#include "units_p.h"

Units::Units(QObject *parent) : QObject(parent)
{
    d_ptr = new UnitsPrivate(this);
}

Units::~Units()
{
    delete d_ptr;
}

qreal Units::density() const
{
    const Q_D(Units);
    return d->density;
}

void Units::setDensity(qreal density)
{
    Q_D(Units);
    if (d->density != density) {
        d->density = density;
        emit densityChanged();
        emit mmChanged();
        emit vpChanged();
        emit inchChanged();
    }
}

qreal Units::mm() const
{
    const Q_D(Units);
    return d->density / 25.4;
}

qreal Units::inch() const
{
    const Q_D(Units);
    return d->density;
}

qreal Units::vp() const
{
    const Q_D(Units);
    return d->density / 330.0; /* Nominal DPI is 330 */
}
