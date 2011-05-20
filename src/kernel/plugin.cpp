/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#include <QtDeclarative>

#include "plugin.h"

#include "contextproperty.h"
#include "qmldebugtools.h"
#include "scene.h"
#include "systemiconprovider.h"
#include "themeimageprovider.h"
#include "translator.h"
#include "windowiconprovider.h"
#include "borderimagedecorator.h"
#include "saverestorestate.h"

void MeeGoUxKernelPlugin::registerTypes(const char *uri)
{
    qmlRegisterType<BorderImageDecorator>(uri, 0,1, "ThemeImageBorder");
    qmlRegisterType<QMLContextProperty>(uri, 0,1, "ContextProperty");
    qmlRegisterType<QmlDebugTools>(uri, 0,1, "QmlDebugTools");
    qmlRegisterType<Scene>(uri, 0,1,"Scene");
    qmlRegisterType<Translator>(uri, 0,1,"Translator");
    qmlRegisterType<SaveRestoreState>(uri, 0,1, "SaveRestoreState");
}

void MeeGoUxKernelPlugin::initializeEngine(QDeclarativeEngine *engine, const char *uri)
{
    Q_UNUSED(uri);

    engine->addImageProvider("systemicon", new SystemIconProvider);
    engine->addImageProvider("themedimage", new ThemeImageProvider);
    engine->addImageProvider("windowicon", new WindowIconProvider);
}

Q_EXPORT_PLUGIN2(meego-ux-kernel, MeeGoUxKernelPlugin);
