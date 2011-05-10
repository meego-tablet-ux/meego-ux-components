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
#include "kernel/translator.h"
#include "kernel/contextproperty.h"

#include "kernel/windowlistener.h"
#include "kernel/windowinfo.h"
#include "kernel/windowelement.h"

void MeeGoUxComponentsPlugin::registerTypes(const char *uri)
{
    // 0.1
    // Kernel
    qmlRegisterType<Translator>(uri, 0,1,"Translator");
    qmlRegisterType<QmlDebugTools>(uri, 0,1, "QmlDebugTools");
    qmlRegisterType<Scene>(uri, 0,1,"Scene");
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
