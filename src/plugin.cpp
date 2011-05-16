/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */
#include "plugin.h"

#include "kernel/scene.h"
#include "kernel/musicserviceproxy.h"

#include "components/volumecontrol.h"
#include "components/batteryindicator.h"
#include "components/bluetoothindicator.h"
#include "components/networkindicator.h"
#include "components/notificationindicator.h"
#include "components/musicindicator.h"
#include "components/localtime.h"
#include "components/borderimagedecorator.h"

#include "kernel/systemiconprovider.h"
#include "kernel/windowiconprovider.h"
#include "kernel/themeimageprovider.h"
#include "kernel/qmldebugtools.h"
#include "kernel/fuzzydatetime.h"
#include "kernel/translator.h"
#include "kernel/units.h"

#include "models/devicemodel.h"
#include "models/librarymodel.h"
#include "models/browserlistmodel.h"
#include "models/imageextension.h"

#include "kernel/windowlistener.h"
#include "kernel/windowinfo.h"
#include "kernel/windowelement.h"
#include "models/windowmodel.h"

#include <QtDeclarative/qdeclarative.h>

void MeeGoUxComponentsPlugin::registerTypes(const char *uri)
{
    // 0.1
    // Kernel
    qmlRegisterType<Translator>(uri, 0,1,"Translator");
    qmlRegisterType<QmlDebugTools>(uri, 0,1, "QmlDebugTools");
    qmlRegisterType<FuzzyDateTime>(uri, 0,1, "FuzzyDateTime");
    qmlRegisterType<devicemodel>(uri, 0,1,"UDiskDeviceModel");
    qmlRegisterType<ImageExtension>(uri, 0,1,"ImageExtension");
    qmlRegisterType<Scene>(uri, 0,1,"Scene");
    qmlRegisterType<Units>(uri, 0,1, "UnitsProvider");
    // Components
    qmlRegisterType<BorderImageDecorator>(uri, 0, 1, "BorderImageDecorator");
    qmlRegisterType<VolumeControl>(uri, 0,1,"VolumeControl");
    qmlRegisterType<LocalTime>(uri, 0,1, "LocalTime");
    qmlRegisterType<NotificationIndicator>(uri, 0, 1, "NotificationIndicator");
    qmlRegisterType<BluetoothIndicator>(uri, 0, 1, "BluetoothIndicator");
    qmlRegisterType<NetworkIndicator>(uri, 0, 1, "NetworkIndicator");
    qmlRegisterType<BatteryIndicator>(uri, 0, 1, "BatteryIndicator");
    qmlRegisterType<MusicIndicator>(uri, 0, 1, "MusicIndicator");    


}
void MeeGoUxComponentsPlugin::initializeEngine(QDeclarativeEngine *engine, const char *uri)
{
    Q_UNUSED(uri);
    engine->addImageProvider("systemicon", new SystemIconProvider);
    engine->addImageProvider("windowicon", new WindowIconProvider);
    engine->addImageProvider("themedimage", new ThemeImageProvider);
}

Q_EXPORT_PLUGIN2(components, MeeGoUxComponentsPlugin);
