/*
 * Copyright 2010 Nokia Corporation and/or its subsidiary(-ies).
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#include <QtDeclarative/qdeclarative.h>

#include "gestureareaplugin_p.h"
#include "qdeclarativegesturearea_p.h"
#include "qdeclarativegesturerecognizers_p.h"

QT_BEGIN_NAMESPACE

void GestureAreaQmlPlugin::registerTypes(const char *uri)
{
#ifndef QT_NO_GESTURES
    qmlRegisterType<QDeclarativeGestureArea>(uri, 0, 1, "GestureArea");

    qmlRegisterUncreatableType<QDeclarativeGestureHandler>(uri, 0, 1, "GestureHandler", QLatin1String("Do not create objects of this type."));

    qmlRegisterUncreatableType<QGesture>(uri, 0, 1, "Gesture", QLatin1String("Do not create objects of this type."));
    qmlRegisterUncreatableType<QPanGesture>(uri, 0, 1, "PanGesture", QLatin1String("Do not create objects of this type."));
    qmlRegisterUncreatableType<QTapGesture>(uri, 0, 1, "TapGesture", QLatin1String("Do not create objects of this type."));
    qmlRegisterUncreatableType<QTapAndHoldGesture>(uri, 0, 1, "TapAndHoldGesture", QLatin1String("Do not create objects of this type."));
    qmlRegisterUncreatableType<QPinchGesture>(uri, 0, 1, "PinchGesture", QLatin1String("Do not create objects of this type."));
    qmlRegisterUncreatableType<QSwipeGesture>(uri, 0, 1, "SwipeGesture", QLatin1String("Do not create objects of this type."));

    qmlRegisterType<QDeclarativeDefaultGestureHandler>(uri, 0, 1, "Default");
    qmlRegisterType<QDeclarativePanGestureHandler>(uri, 0, 1, "Pan");
    qmlRegisterType<QDeclarativeTapGestureHandler>(uri, 0, 1, "Tap");
    qmlRegisterType<QDeclarativeTapAndHoldGestureHandler>(uri, 0, 1, "TapAndHold");
    qmlRegisterType<QDeclarativePinchGestureHandler>(uri, 0, 1, "Pinch");
    qmlRegisterType<QDeclarativeSwipeGestureHandler>(uri, 0, 1, "Swipe");

    QGestureRecognizer::unregisterRecognizer(Qt::TapGesture);
    QGestureRecognizer::unregisterRecognizer(Qt::TapAndHoldGesture);
    QGestureRecognizer::unregisterRecognizer(Qt::PanGesture);
    QGestureRecognizer::unregisterRecognizer(Qt::PinchGesture);
    QGestureRecognizer::unregisterRecognizer(Qt::SwipeGesture);

    QGestureRecognizer::registerRecognizer(new QTapGestureRecognizer());
    QGestureRecognizer::registerRecognizer(new QTapAndHoldGestureRecognizer());
    QGestureRecognizer::registerRecognizer(new QPanGestureRecognizer());
    QGestureRecognizer::registerRecognizer(new QPinchGestureRecognizer());
    QGestureRecognizer::registerRecognizer(new QSwipeGestureRecognizer());
#endif
}

GestureAreaQmlPlugin *GestureAreaQmlPlugin::self = 0;

QT_END_NAMESPACE


Q_EXPORT_PLUGIN2(meego-ux-gestures, QT_PREPEND_NAMESPACE(GestureAreaQmlPlugin));
