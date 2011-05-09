/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#include <QtDeclarative>

#include "plugin.h"

#include "kernel/scene.h"

#include "kernel/systemiconprovider.h"
#include "kernel/windowiconprovider.h"
#include "kernel/themeimageprovider.h"
#include "kernel/qmldebugtools.h"
#include "kernel/fuzzydatetime.h"
#include "kernel/translator.h"
#include "kernel/units.h"
#include "kernel/contextproperty.h"

#include "models/devicemodel.h"
#include "models/librarymodel.h"
#include "models/browserlistmodel.h"
#include "models/imageextension.h"

#include "kernel/windowlistener.h"
#include "kernel/windowinfo.h"
#include "kernel/windowelement.h"
#include "models/windowmodel.h"

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
    qmlRegisterType<QMLContextProperty>(uri, 0,1, "ContextProperty");
}
void MeeGoUxComponentsPlugin::initializeEngine(QDeclarativeEngine *engine, const char *uri)
{
    Q_UNUSED(uri);
    engine->addImageProvider("systemicon", new SystemIconProvider);
    engine->addImageProvider("windowicon", new WindowIconProvider);
    engine->addImageProvider("themedimage", new ThemeImageProvider);
}

Q_EXPORT_PLUGIN2(components, MeeGoUxComponentsPlugin);
