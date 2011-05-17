/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#include <QtDeclarative>

#include "plugin.h"

#include "batteryindicator.h"
#include "bluetoothindicator.h"
#include "localtime.h"
#include "musicindicator.h"
#include "networkindicator.h"
#include "notificationindicator.h"
#include "volumecontrol.h"

void MeeGoUxComponentsIndicatorsPlugin::registerTypes(const char *uri)
{
    qmlRegisterType<BatteryIndicator>(uri, 0, 1, "BatteryIndicator");
    qmlRegisterType<BluetoothIndicator>(uri, 0, 1, "BluetoothIndicator");
    qmlRegisterType<LocalTime>(uri, 0,1, "LocalTime");
    qmlRegisterType<MusicIndicator>(uri, 0, 1, "MusicIndicator");
    qmlRegisterType<NetworkIndicator>(uri, 0, 1, "NetworkIndicator");
    qmlRegisterType<NotificationIndicator>(uri, 0, 1, "NotificationIndicator");
    qmlRegisterType<VolumeControl>(uri, 0,1,"VolumeControl");
}

Q_EXPORT_PLUGIN2(meego-ux-components-indicators, MeeGoUxComponentsIndicatorsPlugin);
