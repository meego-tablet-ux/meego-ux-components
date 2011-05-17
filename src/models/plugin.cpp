/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#include <QtDeclarative>

#include "plugin.h"

#include "devicemodel.h"
#include "imageextension.h"

void MeeGoUxModelsPlugin::registerTypes(const char *uri)
{
    qmlRegisterType<devicemodel>(uri, 0,1,"UDiskDeviceModel");
    qmlRegisterType<ImageExtension>(uri, 0,1,"ImageExtension");
}

Q_EXPORT_PLUGIN2(meego-ux-models, MeeGoUxModelsPlugin);
