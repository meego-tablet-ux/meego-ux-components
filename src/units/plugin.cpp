/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#include <QtDeclarative>

#include "plugin.h"

#include "units.h"

void MeeGoUxUnitsPlugin::registerTypes(const char *uri)
{
    qmlRegisterType<Units>(uri, 0,1, "UnitsProvider");
}

Q_EXPORT_PLUGIN2(meego-ux-units, MeeGoUxUnitsPlugin);
