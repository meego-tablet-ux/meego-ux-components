/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#include <QtDeclarative>

#include "plugin.h"

#include "fuzzydatetime.h"

void MeeGoUxComponentsDateTimePlugin::registerTypes(const char *uri)
{
    qmlRegisterType<FuzzyDateTime>(uri, 0,1, "FuzzyDateTime");
}

Q_EXPORT_PLUGIN2(meego-ux-components-datetime, MeeGoUxComponentsDateTimePlugin);
