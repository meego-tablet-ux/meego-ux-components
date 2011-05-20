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
    qmlRegisterType<QDeclarativeGestureArea>(uri, 2, 0, "GestureArea");

    qmlRegisterUncreatableType<QDeclarativeGestureHandler>(uri, 2, 0, "GestureHandler", QLatin1String("Do not create objects of this type."));

    qmlRegisterUncreatableType<QGesture>(uri, 2, 0, "Gesture", QLatin1String("Do not create objects of this type."));
    qmlRegisterUncreatableType<QPanGesture>(uri, 2, 0, "PanGesture", QLatin1String("Do not create objects of this type."));
    qmlRegisterUncreatableType<QTapGesture>(uri, 2, 0, "TapGesture", QLatin1String("Do not create objects of this type."));
    qmlRegisterUncreatableType<QTapAndHoldGesture>(uri, 2, 0, "TapAndHoldGesture", QLatin1String("Do not create objects of this type."));
    qmlRegisterUncreatableType<QPinchGesture>(uri, 2, 0, "PinchGesture", QLatin1String("Do not create objects of this type."));
    qmlRegisterUncreatableType<QSwipeGesture>(uri, 2, 0, "SwipeGesture", QLatin1String("Do not create objects of this type."));

    qmlRegisterType<QDeclarativeDefaultGestureHandler>(uri, 2, 0, "Default");
    qmlRegisterType<QDeclarativePanGestureHandler>(uri, 2, 0, "Pan");
    qmlRegisterType<QDeclarativeTapGestureHandler>(uri, 2, 0, "Tap");
    qmlRegisterType<QDeclarativeTapAndHoldGestureHandler>(uri, 2, 0, "TapAndHold");
    qmlRegisterType<QDeclarativePinchGestureHandler>(uri, 2, 0, "Pinch");
    qmlRegisterType<QDeclarativeSwipeGestureHandler>(uri, 2, 0, "Swipe");

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
