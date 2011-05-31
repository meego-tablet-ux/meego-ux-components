/*
 * Copyright 2010 Nokia Corporation and/or its subsidiary(-ies).
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#include "qdeclarativegesturearea_p.h"

#include <qdeclarativeexpression.h>
#include <qdeclarativecontext.h>
#include <qdeclarativeinfo.h>

#include <QtCore/qdebug.h>
#include <QtCore/qstringlist.h>

#include <QtGui/qevent.h>
#include <QtGui/qgesture.h>

#include <QTapGesture>
#include <QTapAndHoldGesture>
#include <QSwipeGesture>
#include <QPanGesture>
#include <QPinchGesture>

#include <QDebug>

#include "qdeclarativegesturehandler_p.h"
#include "gestureareaplugin_p.h"

#ifndef QT_NO_GESTURES

QT_BEGIN_NAMESPACE

// remove me and search-n-replace GESTUREHANDLER_D to Q_D
// when put this plugin back to the Qt source tree
#define GESTUREHANDLER_D(x) x##Private *d = d_ptr

class QDeclarativeGestureAreaPrivate
{
public:
    QDeclarativeGestureAreaPrivate(QDeclarativeGestureArea *q) : q_ptr(q), defaultHandler(0) {
        absolute = false;
        blockMouseEvents = true;
        orientation = 3;
    }

    QDeclarativeGestureArea *q_ptr;

    QList<QObject *> handlers;
    QObject *defaultHandler;

    static void handlers_append(QDeclarativeListProperty<QObject> *prop, QObject *handler) {
        QDeclarativeGestureAreaPrivate *d = static_cast<QDeclarativeGestureAreaPrivate *>(prop->data);
        QDeclarativeGestureArea *q = d->q_ptr;
        int type = handler->property("gestureType").toInt();
        // check that all needed properties exist
        if (!handler->property("gestureType").isValid() || !handler->property("gesture").isValid()
                || !handler->property("onStarted").isValid() || !handler->property("onUpdated").isValid()
                || !handler->property("onCanceled").isValid() || !handler->property("onFinished").isValid()) {
            qmlInfo(handler) << "Invalid GestureArea handler.\n"
                             << "A GestureArea handler should provide the following properties: "
                                "'gestureType', 'onStarted', 'onUpdated', 'onCanceled', 'onFinished' and 'gesture'";
            return;
        }
        Qt::GestureType gestureType = Qt::GestureType(type);
        // see if there is already a handler for that gesture type
        foreach(QObject *handler, d->handlers) {
            Qt::GestureType type(Qt::GestureType(handler->property("gestureType").toInt()));
            if (type == gestureType) {
                qmlInfo(handler) << "Duplicate gesture found, ignoring.";
                return;
            }
        }
        d->handlers.append(handler);
        if (GestureAreaQmlPlugin::self)
            GestureAreaQmlPlugin::self->allGestures << gestureType;
        if (type == 0 && GestureAreaQmlPlugin::self) {
            d->defaultHandler = handler;
            GestureAreaQmlPlugin::self->allDefaultAreas << QWeakPointer<QDeclarativeGestureArea>(q);
            foreach (Qt::GestureType gestureType, GestureAreaQmlPlugin::self->allGestures) {
                foreach (QWeakPointer<QDeclarativeGestureArea> area, GestureAreaQmlPlugin::self->allDefaultAreas) {
                    if (area)
                        area.data()->grabGesture(gestureType);
                }
            }
        } else {
            q->grabGesture(gestureType);
        }
    }
    static void handlers_clear(QDeclarativeListProperty<QObject> *prop) {
        QDeclarativeGestureAreaPrivate *d = static_cast<QDeclarativeGestureAreaPrivate *>(prop->data);
        d->handlers.clear();
    }
    static int handlers_count(QDeclarativeListProperty<QObject> *prop) {
        QDeclarativeGestureAreaPrivate *d = static_cast<QDeclarativeGestureAreaPrivate *>(prop->data);
        return d->handlers.count();
    }
    static QObject *handlers_at(QDeclarativeListProperty<QObject> *prop, int index) {
        QDeclarativeGestureAreaPrivate *d = static_cast<QDeclarativeGestureAreaPrivate *>(prop->data);
        return d->handlers.at(index);
    }

    void evaluate(QGestureEvent *event, QGesture *gesture, QObject *handler);
    bool gestureEvent(QGestureEvent *event);

    QGesture* mapGesture( QGesture* gesture, const QGestureEvent *event);
    QPointF correctPoint( QPointF point, const QGestureEvent *event );
    qreal correctAngle( qreal angle );
    QPointF correctOffset( QPointF offset );
    void getOrientation();
    bool absolute;
    bool blockMouseEvents;
    int orientation;

};

/*!
    \qmlclass GestureArea QDeclarativeGestureArea
    \ingroup qml-basic-interaction-elements

    \brief The GestureArea item enables simple gesture handling.
    \inherits Item

    A GestureArea is like a MouseArea, but it has signals for gesture events.

    \e {Elements in the Qt.labs module are not guaranteed to remain compatible
    in future versions.}

    \qml
    import Qt.labs.gestures 0.1

    GestureArea {
        anchors.fill: parent

        Pan {
            when: Math.abs(gesture.delta.y) < Math.abs(gesture.delta.x)
            onUpdated: {
                // use gesture.delta
            }
        }
        TapAndHold {
            onFinished: {
                // do something
            }
        }
    }
    \endqml

    Each gesture object has a \e when clause that will be evaluated on start of the
    gesture. If the when clause evaluates to true the gesture is accepted and the
    \e onStarted script is handled.  If there is no \e when clause then it will
    automatically be accepted.  Notice that a gesture that is not accepted will be
    offered to another gesture area that is also covering the area where the gesture
    happened.

    After acceptance of a gesture updates in movement call \e unOpdated and finally either
    the script from \e onCanceled or \e onFinished is handled when the gesture is canceled
    or finished.
    Each gesture object has a \e gesture parameter that has the properties of the gesture
    which can be used in all of the script properties.

    The full list of supported gesture-types handled by a GestureArea is listed in the table
    below.
    \table
    \header \o Type \o Description
    \row \o Pan \o a movement of pressing and holding while moving the pointing device on the gesture area
    \row \o Tap \o a touch and release without moving
    \row \o TapAndHold \o a touch without releasing or moving for a longer time
    \row \o Pinch \o is used to handle the moving using more than one finger
    \endtable

    GestureArea is an invisible item: it is never painted.

    \sa MouseArea, {declarative/touchinteraction/gestures}{Gestures example}
*/

/*!
    \internal
    \class QDeclarativeGestureArea
    \brief The QDeclarativeGestureArea class provides simple gesture handling.

*/
QDeclarativeGestureArea::QDeclarativeGestureArea(QDeclarativeItem *parent) :
    QDeclarativeItem(parent)
{
    d_ptr = new QDeclarativeGestureAreaPrivate(this);
    setAcceptedMouseButtons(Qt::LeftButton);
    setAcceptTouchEvents(true);

}

QDeclarativeGestureArea::~QDeclarativeGestureArea()
{
    delete d_ptr; d_ptr = 0;
}

QDeclarativeListProperty<QObject> QDeclarativeGestureArea::handlers()
{
    GESTUREHANDLER_D(QDeclarativeGestureArea);
    return QDeclarativeListProperty<QObject>(this, d, QDeclarativeGestureAreaPrivate::handlers_append,
                                             QDeclarativeGestureAreaPrivate::handlers_count, QDeclarativeGestureAreaPrivate::handlers_at,
                                             QDeclarativeGestureAreaPrivate::handlers_clear);
}

bool QDeclarativeGestureArea::sceneEvent(QEvent *event)
{
    bool rv = QDeclarativeItem::sceneEvent(event);
    GESTUREHANDLER_D(QDeclarativeGestureArea);
    switch (event->type()) {
    case QEvent::GraphicsSceneMousePress:
    case QEvent::MouseButtonPress:
    case QEvent::TouchBegin:
        event->accept();
        return true;
    case QEvent::Gesture:
        return d->gestureEvent(static_cast<QGestureEvent *>(event));
    case QEvent::MouseMove:
    case QEvent::MouseTrackingChange:
        if( d->blockMouseEvents ) {
            event->accept();
            return true;
        }
    default:
        break;
    }
    return rv;
}

void QDeclarativeGestureAreaPrivate::evaluate(QGestureEvent *event, QGesture *gesture, QObject *handler)
{
    QGesture* tempGesture = gesture;
    if( !absolute ) {
        getOrientation();
        tempGesture = mapGesture( gesture, event );
    }

    handler->setProperty("gesture", QVariant::fromValue<QObject *>(tempGesture));
    QDeclarativeScriptString when = handler->property("when").value<QDeclarativeScriptString>();
    if (!when.script().isEmpty()) {
        QDeclarativeExpression expr(when.context(), when.scopeObject(), when.script());
        QVariant result = expr.evaluate();
        if (expr.hasError()) {
            qmlInfo(q_ptr) << expr.error();
            return;
        }
        if (!result.toBool())
            return;
    }

    // those names map to the enum Qt::GestureState
    static const char * scriptPropertyNames[] = { "0", "onStarted", "onUpdated", "onFinished", "onCanceled", "__ERROR" };
    QDeclarativeScriptString script = handler->property(scriptPropertyNames[gesture->state()]).value<QDeclarativeScriptString>();
    if (!script.script().isEmpty()) {
        QDeclarativeExpression expr(script.context(), script.scopeObject(), script.script());
        expr.evaluate();
        if (expr.hasError())
            qmlInfo(q_ptr) << expr.error();
    }
    event->accept(gesture);
    handler->setProperty("gesture", QVariant());

    if( !absolute ) {
        delete tempGesture;
    }

}

QGesture* QDeclarativeGestureAreaPrivate::mapGesture( QGesture* gesture, const QGestureEvent *event)
{
    //FIXME: orientation must be passed in a more generic way
    if( gesture ) {

        if(dynamic_cast<QTapGesture*>( gesture ) ) {

            QTapGesture* tapGesture = dynamic_cast<QTapGesture*>( gesture );
            QTapGesture* tempGesture = new QTapGesture();

            QPointF point = correctPoint( tapGesture->position(), event );
            tempGesture->setPosition( point );

            return (QGesture*)tempGesture;

        } else if(dynamic_cast<QTapAndHoldGesture*>( gesture ) ) {

            QTapAndHoldGesture* tapGesture = dynamic_cast<QTapAndHoldGesture*>( gesture );
            QTapAndHoldGesture* tempGesture = new QTapAndHoldGesture();

            QPointF point = correctPoint( tapGesture->position(), event );
            tempGesture->setPosition( point );

            return (QGesture*)tempGesture;

        } else if(dynamic_cast<QPanGesture*>( gesture ) ) {

            QPanGesture* panGesture = dynamic_cast<QPanGesture*>( gesture );
            QPanGesture* tempGesture = new QPanGesture();

            tempGesture->setLastOffset( correctOffset( panGesture->lastOffset() ) );
            tempGesture->setAcceleration( panGesture->acceleration() );
            tempGesture->setOffset( correctOffset( panGesture->offset() ) );

            return (QGesture*)tempGesture;

        } else if(dynamic_cast<QPinchGesture*>( gesture ) ) {

            QPinchGesture* pinchGesture = dynamic_cast<QPinchGesture*>( gesture );
            QPinchGesture* tempGesture = new QPinchGesture();

            QPointF centerPoint = correctPoint( pinchGesture->centerPoint() , event );
            tempGesture->setCenterPoint( centerPoint );

            QPointF lastCenterPoint = correctPoint( pinchGesture->lastCenterPoint() , event );
            tempGesture->setLastCenterPoint( lastCenterPoint );

            QPointF startCenterPoint = correctPoint( pinchGesture->startCenterPoint(), event);
            tempGesture->setStartCenterPoint( startCenterPoint );

            tempGesture->setRotationAngle( correctAngle( pinchGesture->rotationAngle() ) );
            tempGesture->setLastRotationAngle( correctAngle( pinchGesture->lastRotationAngle() ) );
            tempGesture->setTotalRotationAngle( correctAngle( pinchGesture->totalRotationAngle() ) );

            tempGesture->setChangeFlags( pinchGesture->changeFlags() );
            tempGesture->setLastScaleFactor( pinchGesture->lastScaleFactor() );
            tempGesture->setTotalChangeFlags( pinchGesture->totalChangeFlags() );
            tempGesture->setTotalScaleFactor( pinchGesture->totalScaleFactor() );

            return (QGesture*)tempGesture;
        } else if(dynamic_cast<QSwipeGesture*>( gesture ) ) {
            QSwipeGesture* swipeGesture = dynamic_cast<QSwipeGesture*>( gesture );
            QSwipeGesture* tempGesture = new QSwipeGesture();
            tempGesture->setSwipeAngle( correctAngle( swipeGesture->swipeAngle() ) );
            return (QGesture*)tempGesture;
        }
    }
    return new QGesture();
}

bool QDeclarativeGestureAreaPrivate::gestureEvent(QGestureEvent *event)
{
    if (handlers.isEmpty())
        return false;

    event->accept();

    QList<Qt::GestureType> handlersTypes;
    foreach(QObject *handler, handlers) {
        Qt::GestureType type(Qt::GestureType(handler->property("gestureType").toInt()));
        handlersTypes.append(type);
        event->ignore(type);
    }

    QSet<Qt::GestureType> handledGestures;
    for (int i = handlers.size()-1; i >= 0; --i) {
        Qt::GestureType gestureType = handlersTypes.at(i);
        if (!gestureType)
            continue;
        if (QGesture *gesture = event->gesture(gestureType)) {
            handledGestures << gestureType;
            QObject *handler = handlers.at(i);
            evaluate(event, gesture, handler);
        }
    }

    if (defaultHandler) {
        // filter all gestures through the default handler
        foreach (QGesture *gesture, event->gestures()) {
            if (!handledGestures.contains(gesture->gestureType()))
                evaluate(event, gesture, defaultHandler);
        }
    }
    return false;
}

void QDeclarativeGestureArea::geometryChanged(const QRectF &newGeometry,
                                              const QRectF &oldGeometry)
{
    QDeclarativeItem::geometryChanged(newGeometry, oldGeometry);


}

bool QDeclarativeGestureArea::absolute() const
{
    Q_D(const QDeclarativeGestureArea);
    return d->absolute;
}
void QDeclarativeGestureArea::setAbsolute( bool absolute )
{
    Q_D(QDeclarativeGestureArea);
    d->absolute = absolute;
}

bool QDeclarativeGestureArea::blockMouseEvents() const
{
    Q_D(const QDeclarativeGestureArea);
    return d->blockMouseEvents;
}
void QDeclarativeGestureArea::setBlockMouseEvents( bool blockMouseEvents )
{
    Q_D(QDeclarativeGestureArea);
    d->blockMouseEvents = blockMouseEvents;
}

QPointF QDeclarativeGestureAreaPrivate::correctPoint( const QPointF point, const QGestureEvent *event )
{
    //FIXME: orientation must be passed in a more generic way

    /*
    1 = landscape
    2 = portrait
    3 = inverted landscape
    4 = inverted portrait
    */
    if( orientation == 1 ) {

        QPointF mapFromGlobalToScene = event->mapToGraphicsScene( point );
        return q_ptr->mapFromScene( mapFromGlobalToScene );

    } else if ( orientation == 2 ) {

        QPointF mapFromGlobalToScene = event->mapToGraphicsScene( point );
        QPointF tempPoint = q_ptr->mapFromScene( mapFromGlobalToScene );
        QPointF correctionPoint;
        correctionPoint.setX( tempPoint.x() );
        correctionPoint.setY( tempPoint.y() );
        return correctionPoint;

    } else if ( orientation == 3 ) {

        QPointF mapFromGlobalToScene = event->mapToGraphicsScene( point );
        QPointF tempPoint = q_ptr->mapFromScene( mapFromGlobalToScene );
        QPointF correctionPoint;
        correctionPoint.setX( tempPoint.x() );
        correctionPoint.setY( tempPoint.y() );
        return correctionPoint;

    } else if ( orientation == 4 ) {

        QPointF mapFromGlobalToScene = event->mapToGraphicsScene( point );
        QPointF tempPoint = q_ptr->mapFromScene( mapFromGlobalToScene );
        QPointF correctionPoint;
        correctionPoint.setY( tempPoint.x() );
        correctionPoint.setX( tempPoint.y() );
        return correctionPoint;

    }
    return QPointF( point );
}

qreal QDeclarativeGestureAreaPrivate::correctAngle( qreal angle )
{
    //FIXME: orientation must be passed in a more generic way

    /*
    1 = landscape
    2 = portrait
    3 = inverted landscape
    4 = inverted portrait
    */
    if( orientation == 1 ) {
        return angle;
    } else if( orientation == 2 ) {
        qreal realAngle = ( angle - 90.0 );
        return realAngle;
    } else if( orientation == 3 ) {
        qreal realAngle = ( angle - 180.0 );
        return realAngle;
    } else if( orientation == 4 ) {
        qreal realAngle = ( angle + 90.0 );
        return realAngle;
    }
    return angle;
}

QPointF QDeclarativeGestureAreaPrivate::correctOffset( QPointF offset )
{
    //FIXME: orientation must be passed in a more generic way
    /*
    1 = landscape
    2 = portrait
    3 = inverted landscape
    4 = inverted portrait
    */
    if( orientation == 1 ) {

        return offset;

    } else if( orientation == 2 ) {

        QPointF tempPoint;
        tempPoint.setX( 0 - offset.y() );
        tempPoint.setY( offset.x() );
        return tempPoint;

    } else if( orientation == 3 ) {

        QPointF tempPoint;
        tempPoint.setX( 0 - offset.x() );
        tempPoint.setY( 0 - offset.y() );
        return tempPoint;

    } else if( orientation == 4 ) {

        QPointF tempPoint;
        tempPoint.setX( 0 - offset.y() );
        tempPoint.setY( 0 - offset.x() );
        return tempPoint;

    }
    return offset;

}

void QDeclarativeGestureAreaPrivate::getOrientation()
{
    //FIXME: orientation must be passed in a more generic way

    QDeclarativeItem *item = q_ptr->parentItem();
    while( 0 != item )
    {
        if( item->objectName() == "window") {
            orientation = item->property("orientation").toInt();
            return;
        } else {
            item = item->parentItem();
        }
    }
}

QT_END_NAMESPACE

#endif // QT_NO_GESTURES
