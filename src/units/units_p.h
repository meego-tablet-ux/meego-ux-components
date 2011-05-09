/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#ifndef MEEGOUNITS_P_H
#define MEEGOUNITS_P_H

#include <QObject>
#include "units.h"

class UnitsPrivate
{
public:
    UnitsPrivate(Units *q);
    virtual ~UnitsPrivate();

private:
    Units *q_ptr;
    qreal density;
    friend class Units;
};

#endif // MEEGOUNITS_P_H
