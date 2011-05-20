/*
 * Copyright 2010 Nokia Corporation and/or its subsidiary(-ies).
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#ifndef GESTUREAREAPLUGIN_P_H
#define GESTUREAREAPLUGIN_P_H

#include <QtDeclarative/qdeclarativeextensionplugin.h>
#include <QtCore/QSet>
#include <QtCore/QList>
#include <QtCore/QWeakPointer>

QT_BEGIN_NAMESPACE

class QDeclarativeGestureArea;
class GestureAreaQmlPlugin : public QDeclarativeExtensionPlugin
{
    Q_OBJECT
public:
    GestureAreaQmlPlugin(QObject *parent = 0) : QDeclarativeExtensionPlugin(parent) { self = this; }
    ~GestureAreaQmlPlugin() { self = 0; }

    virtual void registerTypes(const char *uri);

    static GestureAreaQmlPlugin *self;

    QSet<Qt::GestureType> allGestures;
    // all gesture areas with default handlers
    QList<QWeakPointer<QDeclarativeGestureArea> > allDefaultAreas;
};

QT_END_NAMESPACE

#endif
