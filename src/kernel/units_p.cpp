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
#include <QX11Info>

UnitsPrivate::UnitsPrivate(Units *q) : q_ptr(q)
{
    density = QX11Info::appDpiX();
}

UnitsPrivate::~UnitsPrivate()
{
}
