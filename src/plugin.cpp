/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */
#include "plugin.h"

//#include "models/applicationsmodel.h"
//#include "models/recentapplicationsmodel.h"
//#include "models/favoriteapplicationsmodel.h"
//#include "models/desktop.h"
//#include "kernel/valuespacepublisher.h"
//#include "kernel/valuespacesubscriber.h"

#include "kernel/musicserviceproxy.h"

#include "components/volumecontrol.h"
#include "components/batteryindicator.h"
#include "components/bluetoothindicator.h"
#include "components/networkindicator.h"
#include "components/notificationindicator.h"
#include "components/musicindicator.h"
#include "components/gesturearea.h"
#include "components/localtime.h"

//#include "components/theme.h"

#include "kernel/systemiconprovider.h"
#include "kernel/windowiconprovider.h"
#include "kernel/themeimageprovider.h"
#include "kernel/qmldebugtools.h"
#include "kernel/fuzzydatetime.h"
#include "kernel/translator.h"

#include "models/devicemodel.h"
#include "models/librarymodel.h"
#include "models/browserlistmodel.h"
#include "models/imageextension.h"
//#include "models/timezonelistmodel.h"

#include "kernel/windowlistener.h"
#include "kernel/windowinfo.h"
#include "kernel/windowelement.h"
#include "models/windowmodel.h"

#include <QtDeclarative/qdeclarative.h>
#include <QGesture>
#include <QPanGesture>
#include <QTapGesture>
#include <QTapAndHoldGesture>
#include <QPinchGesture>
#include <QSwipeGesture>

void MeeGoUxComponentsPlugin::registerTypes(const char *uri)
{
    // 0.1
    // Kernel:

    qmlRegisterType<Translator>(uri, 0,1,"Translator");
    qmlRegisterType<QmlDebugTools>(uri, 0,1, "QmlDebugTools");
    qmlRegisterType<FuzzyDateTime>(uri, 0,1, "FuzzyDateTime");
    qmlRegisterType<devicemodel>(uri, 0,1,"UDiskDeviceModel");
    qmlRegisterType<ImageExtension>(uri, 0,1,"ImageExtension");

    // Components
    qmlRegisterType<VolumeControl>(uri, 0,1,"VolumeControl");
    qmlRegisterType<GestureArea>(uri, 0,1, "GestureArea");
    qmlRegisterType<LocalTime>(uri, 0,1, "LocalTime");
    qmlRegisterType<NotificationIndicator>(uri, 0, 1, "NotificationIndicator");
    qmlRegisterType<BluetoothIndicator>(uri, 0, 1, "BluetoothIndicator");
    qmlRegisterType<NetworkIndicator>(uri, 0, 1, "NetworkIndicator");
    qmlRegisterType<BatteryIndicator>(uri, 0, 1, "BatteryIndicator");
    qmlRegisterType<MusicIndicator>(uri, 0, 1, "MusicIndicator");

    // 1.0
    // Uncreatable
    qmlRegisterUncreatableType<QGesture>(uri, 1, 0, "Gesture", QLatin1String("Do not create objects of this type."));
    qmlRegisterUncreatableType<QPanGesture>(uri, 1, 0, "PanGesture", QLatin1String("Do not create objects of this type."));
    qmlRegisterUncreatableType<QTapGesture>(uri, 1, 0, "TapGesture", QLatin1String("Do not create objects of this type."));
    qmlRegisterUncreatableType<QTapAndHoldGesture>(uri, 1, 0, "TapAndHoldGesture", QLatin1String("Do not create objects of this type."));
    qmlRegisterUncreatableType<QPinchGesture>(uri, 1, 0, "PinchGesture", QLatin1String("Do not create objects of this type."));
    qmlRegisterUncreatableType<QSwipeGesture>(uri, 1, 0, "SwipeGesture", QLatin1String("Do not create objects of this type."));
}
void MeeGoUxComponentsPlugin::initializeEngine(QDeclarativeEngine *engine, const char *uri)
{
    Q_UNUSED(uri);
    engine->addImageProvider("systemicon", new SystemIconProvider);
    engine->addImageProvider("windowicon", new WindowIconProvider);
    engine->addImageProvider("theme", new ThemeImageProvider);
}

Q_EXPORT_PLUGIN2(components, MeeGoUxComponentsPlugin);
