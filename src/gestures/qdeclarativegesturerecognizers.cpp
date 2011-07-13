/*
 * Copyright 2010 Nokia Corporation and/or its subsidiary(-ies).
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#include "qdeclarativegesturerecognizers_p.h"
#include "qgesture.h"
#include "qevent.h"
#include "qwidget.h"
#include "qabstractscrollarea.h"
#include <qgraphicssceneevent.h>
#include <QtCore/QElapsedTimer>
#include "qdebug.h"

#include "qmath.h"

#ifndef QT_NO_GESTURES

QT_BEGIN_NAMESPACE

Q_DECLARE_METATYPE(QElapsedTimer)

static const int PanGestureMovementThreshold = 30;
static const bool debugGestures = (getenv("DEBUG_GESTURE") != NULL);
enum {
    GESTURE_INPUT_NONE = 0,
    GESTURE_INPUT_MOUSE,
    GESTURE_INPUT_TOUCH
};

QPanGestureRecognizer::QPanGestureRecognizer()
{
}

QGesture *QPanGestureRecognizer::create(QObject *target)
{
    if (target && target->isWidgetType()) {
#if defined(Q_OS_WIN) && !defined(QT_NO_NATIVE_GESTURES)
        // for scroll areas on Windows we want to use native gestures instead
        if (!qobject_cast<QAbstractScrollArea *>(target->parent()))
            static_cast<QWidget *>(target)->setAttribute(Qt::WA_AcceptTouchEvents);
#else
        static_cast<QWidget *>(target)->setAttribute(Qt::WA_AcceptTouchEvents);
#endif
    } else if (target) {
        return 0;
    }
    return new QPanGesture;
}

QGestureRecognizer::Result QPanGestureRecognizer::recognize(QGesture *state,
                                                            QObject *,
                                                            QEvent *event)
{
    QPanGesture *q = static_cast<QPanGesture *>(state);

    if (!q->property("gestureInput").isValid())
        q->setProperty("gestureInput", GESTURE_INPUT_NONE);

    QGestureRecognizer::Result result;
    switch (event->type()) {
    case QEvent::TouchBegin: {
        if (q->property("gestureInput") != GESTURE_INPUT_NONE)
            break;
        q->setProperty("gestureInput", GESTURE_INPUT_TOUCH);
        if (debugGestures) qDebug() << "pan: touch maybe";
        const QTouchEvent *ev = static_cast<const QTouchEvent *>(event);
        QTouchEvent::TouchPoint p = ev->touchPoints().at(0);
        q->setOffset(QPointF());
        q->setLastOffset(QPointF());
        QElapsedTimer pressTime;
        pressTime.start();
        q->setProperty("pressTime", QVariant::fromValue(pressTime));

        result = QGestureRecognizer::MayBeGesture;
        break;
    }
    case QEvent::TouchEnd: {
        if (q->property("gestureInput") != GESTURE_INPUT_TOUCH)
            break;
        const QTouchEvent *ev = static_cast<const QTouchEvent *>(event);
        if (q->state() != Qt::NoGesture) {
            if (ev->deviceType() == QTouchEvent::TouchScreen && ev->touchPoints().size() == 1) {
                QTouchEvent::TouchPoint p1 = ev->touchPoints().at(0);
                q->setLastOffset(q->offset());
                q->setOffset(QPointF(p1.pos().x() - p1.startPos().x(), p1.pos().y() - p1.startPos().y()));
            } else if (ev->deviceType() == QTouchEvent::TouchPad && ev->touchPoints().size() == 2) {
                QTouchEvent::TouchPoint p1 = ev->touchPoints().at(0);
                QTouchEvent::TouchPoint p2 = ev->touchPoints().at(1);
                q->setLastOffset(q->offset());
                q->setOffset(QPointF(p1.pos().x() - p1.startPos().x() + p2.pos().x() - p2.startPos().x(),
                                     p1.pos().y() - p1.startPos().y() + p2.pos().y() - p2.startPos().y()) / 2);

            }
            if (debugGestures) qDebug() << "pan: touch finish";
            result = QGestureRecognizer::FinishGesture;
        } else {
            if (debugGestures) qDebug() << "pan: touch cancel";
            result = QGestureRecognizer::CancelGesture;
        }
        break;
    }
    case QEvent::TouchUpdate: {
        if (q->property("gestureInput") != GESTURE_INPUT_TOUCH)
            break;
        bool deviceAndTouchPointsOK = false;
        const QTouchEvent *ev = static_cast<const QTouchEvent *>(event);
        QTouchEvent::TouchPoint p1;
        if (ev->deviceType() == QTouchEvent::TouchScreen && ev->touchPoints().size() == 1) {
            deviceAndTouchPointsOK = true;
            p1 = ev->touchPoints().at(0);
            q->setLastOffset(q->offset());
            q->setOffset(QPointF(p1.pos().x() - p1.startPos().x(), p1.pos().y() - p1.startPos().y()));
        } else if (ev->deviceType() == QTouchEvent::TouchPad && ev->touchPoints().size() >= 2) {
            deviceAndTouchPointsOK = true;
            p1 = ev->touchPoints().at(0);
            QTouchEvent::TouchPoint p2 = ev->touchPoints().at(1);
            q->setLastOffset(q->offset());
            q->setOffset(QPointF(p1.pos().x() - p1.startPos().x() + p2.pos().x() - p2.startPos().x(),
                                 p1.pos().y() - p1.startPos().y() + p2.pos().y() - p2.startPos().y()) / 2);
        }
        QPointF offset = q->offset();
        if (deviceAndTouchPointsOK &&
            (offset.x() > 10  || offset.y() > 10 ||
            offset.x() < -10 || offset.y() < -10)) {
            q->setHotSpot(p1.startScreenPos());
            if (debugGestures) qDebug() << "pan: touch trigger";
            result = QGestureRecognizer::TriggerGesture;
        } else {
            if (debugGestures) qDebug() << "pan: touch maybe";
            result = QGestureRecognizer::MayBeGesture;
        }
        break;
    }

    case QEvent::MouseButtonPress: {
        if (q->property("gestureInput") != GESTURE_INPUT_NONE)
            break;
        if (debugGestures) qDebug() << "pan: mouse begin";
        q->setProperty("gestureInput", GESTURE_INPUT_MOUSE);
        QMouseEvent *ev = static_cast<QMouseEvent *>(event);
        if (ev->buttons() == Qt::LeftButton && !(ev->modifiers() & Qt::ControlModifier)) {
            QPoint globalPos = ev->globalPos();
            q->setProperty("startPosition", globalPos);
            q->setProperty("lastPos", globalPos);
            state->setHotSpot(globalPos);

            QElapsedTimer pressTime;
            pressTime.start();
            q->setProperty("pressTime",QVariant::fromValue(pressTime));
            q->setProperty("lastPosTime",QVariant::fromValue(pressTime));

            ev->accept();
        }
        return QGestureRecognizer::MayBeGesture;
    }

    case QEvent::MouseMove: {
        if (q->property("gestureInput") != GESTURE_INPUT_MOUSE)
            break;
        QMouseEvent *ev = static_cast<QMouseEvent *>(event);
        QPoint startPosition = q->property("startPosition").toPoint();
        if (!startPosition.isNull()) {
            QPoint delta = ev->globalPos() - startPosition;
            if (state->state() != Qt::GestureStarted || state->state() != Qt::GestureUpdated) {
                if (delta.manhattanLength() > PanGestureMovementThreshold || q->property("pressTime").value<QElapsedTimer>().elapsed() > 200) {
                    q->setLastOffset(q->offset());
                    q->setOffset(delta);

                    QPoint lastPos = q->property("lastPos").toPoint();
                    QElapsedTimer lastPosTime = q->property("lastPosTime").value<QElapsedTimer>();
                    qreal xVelocity = q->property("horizontalVelocity").toReal();
                    qreal yVelocity = q->property("verticalVelocity").toReal();

                    qreal elapsed = qreal(lastPosTime.restart()) / 1000.;
                    q->setProperty("lastPosTime", QVariant::fromValue(lastPosTime));
                    if (elapsed <= 0)
                        elapsed = 1;
                    int dx = ev->globalPos().x() - lastPos.x();
                    xVelocity += dx / elapsed;
                    xVelocity /= 2;
                    q->setProperty("horizontalVelocity", xVelocity);
                    int dy = ev->globalPos().y() - lastPos.y();
                    yVelocity += dy / elapsed;
                    yVelocity /= 2;
                    q->setProperty("verticalVelocity", yVelocity);

                    q->setProperty("lastPos",ev->globalPos());
                    if (debugGestures) qDebug() << "pan: mouse trigger";
                    return QGestureRecognizer::TriggerGesture;
                }
            }
        }
        return QGestureRecognizer::Ignore;
    }

    case QEvent::MouseButtonRelease: {
        if (q->property("gestureInput") != GESTURE_INPUT_MOUSE)
            break;
        if(q->state() != Qt::NoGesture) {
            QMouseEvent *ev = static_cast<QMouseEvent *>(event);
            if (q->property("lastPosTime").value<QElapsedTimer>().elapsed() > 100) {
                // if we drag then pause before release we should not cause a flick.
                q->setProperty("horizontalVelocity", 0);
                q->setProperty("verticalVelocity", 0);
            } else {
                // FlickThreshold determines how far the "mouse" must have moved
                // before we perform a flick.
                static const int FlickThreshold = 20;

                // Really slow flicks can be annoying.
                static const int minimumFlickVelocity = 200;

                qreal xVelocity = q->property("horizontalVelocity").toReal();
                if (qAbs(xVelocity) > 10 && qAbs(ev->globalPos().x() - q->property("startPosition").toPoint().x()) > FlickThreshold) {
                    if (qAbs(xVelocity) < minimumFlickVelocity)
                        q->setProperty("horizontalVelocity", xVelocity < 0 ? -minimumFlickVelocity : minimumFlickVelocity);
                }
                qreal yVelocity = q->property("verticalVelocity").toReal();
                if (qAbs(yVelocity) > 10 && qAbs(ev->globalPos().y() - q->property("startPosition").toPoint().y()) > FlickThreshold) {
                    if (qAbs(yVelocity) < minimumFlickVelocity)
                        q->setProperty("verticalVelocity", yVelocity < 0 ? -minimumFlickVelocity : minimumFlickVelocity);
                }
            }
            if (!q->property("startPosition").toPoint().isNull() && !q->lastOffset().isNull()) {
                if (debugGestures) qDebug() << "pan: mouse finish";
                return QGestureRecognizer::FinishGesture;
            }
        }
        if (debugGestures) qDebug() << "pan: mouse cancel";
        return QGestureRecognizer::CancelGesture;
    }

    case QEvent::Gesture: {
        // We check for other gesture events: Swipe and Pinch both cancel the Pan
        // FIXME: QGraphicScene keeps old gestureEvents which saying that Pinch/Swipe is active but its not
        /*
        QGestureEvent *ge = static_cast<QGestureEvent *>(event);
        if (ge->gesture(Qt::SwipeGesture ) || ge->gesture(Qt::PinchGesture )) {
            if (state->state() == Qt::GestureStarted || state->state() == Qt::GestureUpdated)
                return QGestureRecognizer::CancelGesture;
        }
        */
        return QGestureRecognizer::Ignore;
    }

    default:
        result = QGestureRecognizer::Ignore;
        break;
    }
    return result;
}

void QPanGestureRecognizer::reset(QGesture *state)
{
    if (!state)
        return;
    QPanGesture *pan = static_cast<QPanGesture*>(state);
    pan->setProperty("startPosition", QPoint());
    pan->setLastOffset(QPointF());
    pan->setOffset(QPointF());
    pan->setAcceleration(0);
    pan->setProperty("gestureInput",GESTURE_INPUT_NONE);
    QElapsedTimer pressTime = pan->property("pressTime").value<QElapsedTimer>();
    pressTime.invalidate();
    pan->setProperty("pressTime",QVariant::fromValue(pressTime));
    QElapsedTimer lastPosTime = pan->property("lastPosTime").value<QElapsedTimer>();
    lastPosTime.invalidate();
    pan->setProperty("lastPosTime", QVariant::fromValue(lastPosTime));
    pan->setProperty("lastPos",QPoint());
    pan->setProperty("horizontalVelocity", 0);
    pan->setProperty("verticalVelocity", 0);

    QGestureRecognizer::reset(state);
}


//
// QPinchGestureRecognizer
//

QPinchGestureRecognizer::QPinchGestureRecognizer()
{
}

QGesture *QPinchGestureRecognizer::create(QObject *target)
{
    if (target) {
        if (target->isWidgetType())
            static_cast<QWidget *>(target)->setAttribute(Qt::WA_AcceptTouchEvents);
        else
            return 0;
    }
    return new QPinchGesture;
}

/* We only support touch events for the pinch gesture [multi-point touch gesture] */
QGestureRecognizer::Result QPinchGestureRecognizer::recognize(QGesture *state,
                                                              QObject *,
                                                              QEvent *event)
{
    QPinchGesture *q = static_cast<QPinchGesture *>(state);
    QGestureRecognizer::Result result;

    switch (event->type()) {
    case QEvent::TouchBegin: {
        result = QGestureRecognizer::MayBeGesture;
        break;
    }
    case QEvent::TouchEnd: {
        if (q->state() != Qt::NoGesture) {
            result = QGestureRecognizer::FinishGesture;
        } else {
            result = QGestureRecognizer::CancelGesture;
        }
        break;
    }
    case QEvent::TouchUpdate: {
        const QTouchEvent *ev = static_cast<const QTouchEvent *>(event);
        q->setChangeFlags(0);
        if (ev->touchPoints().size() == 2) {
            QTouchEvent::TouchPoint p1 = ev->touchPoints().at(0);
            QTouchEvent::TouchPoint p2 = ev->touchPoints().at(1);

            q->setHotSpot(p1.screenPos());

            if (q->property("isNewSequence").toBool()) {
                q->setProperty("startPosition0", p1.screenPos());
                q->setProperty("startPosition1", p2.screenPos());
            }
            QLineF line(p1.screenPos(), p2.screenPos());
            QLineF lastLine(p1.lastScreenPos(),  p2.lastScreenPos());
            QLineF startLine( p1.startScreenPos(),  p2.startScreenPos() );
            QLineF tmp(line);
            tmp.setLength(line.length() / 2.);
            QPointF centerPoint = tmp.p2();

            q->setLastCenterPoint(q->centerPoint());
            q->setCenterPoint(centerPoint);
            q->setChangeFlags(q->changeFlags() | QPinchGesture::CenterPointChanged);

            const qreal scaleFactor =      line.length() / qMax( lastLine.length(), 0.01 );
            const qreal totalScaleFactor = line.length() / qMax( startLine.length(), 0.01 );

            if (q->property("isNewSequence").toBool()) {
                q->setLastScaleFactor(scaleFactor);
                q->setLastCenterPoint(centerPoint);
            } else {
                q->setLastScaleFactor(q->scaleFactor());
            }
            q->setScaleFactor( scaleFactor );
            q->setTotalScaleFactor( totalScaleFactor );

            q->setChangeFlags(q->changeFlags() | QPinchGesture::ScaleFactorChanged );

            qreal angle = QLineF(p1.screenPos(), p2.screenPos()).angle();
            if (angle > 180)
                angle -= 360;
            qreal startAngle = QLineF(p1.startScreenPos(), p2.startScreenPos()).angle();
            if (startAngle > 180)
                startAngle -= 360;
            const qreal rotationAngle = startAngle - angle;
            if (q->property("isNewSequence").toBool())
                q->setLastRotationAngle(rotationAngle);
            else
                q->setLastRotationAngle(q->rotationAngle());
            q->setRotationAngle(rotationAngle);
            q->setTotalRotationAngle(q->totalRotationAngle() + q->rotationAngle() - q->lastRotationAngle());
            q->setChangeFlags(q->changeFlags() | QPinchGesture::RotationAngleChanged);

            q->setTotalChangeFlags(q->totalChangeFlags() | q->changeFlags());
            if(p1.state() == Qt::TouchPointReleased || p2.state() == Qt::TouchPointReleased)
                q->setProperty("isNewSequence", true);
            else
                q->setProperty("isNewSequence", false);
            result = QGestureRecognizer::TriggerGesture;
        } else {
            q->setProperty("isNewSequence", true);
            if (q->state() != Qt::NoGesture)
                result = QGestureRecognizer::Ignore;
            else
                result = QGestureRecognizer::FinishGesture;
        }
        break;
    }

    default:
        result = QGestureRecognizer::Ignore;
        break;
    }
    return result;
}

void QPinchGestureRecognizer::reset(QGesture *state)
{
    if (!state)
        return;
    QPinchGesture *pinch = static_cast<QPinchGesture *>(state);

    pinch->setTotalChangeFlags(0);
    pinch->setChangeFlags(0);

    pinch->setStartCenterPoint(QPointF());
    pinch->setLastCenterPoint(QPointF());
    pinch->setCenterPoint(QPointF());
    pinch->setTotalScaleFactor(1);
    pinch->setLastScaleFactor(1);
    pinch->setScaleFactor(1);
    pinch->setTotalRotationAngle(0);
    pinch->setLastRotationAngle(0);
    pinch->setRotationAngle(0);

    pinch->setProperty("isNewSequence", true);
    pinch->setProperty("startPosition0", QPointF());
    pinch->setProperty("startPosition1", QPointF());

    QGestureRecognizer::reset(state);
}

//
// QSwipeGestureRecognizer
//

QSwipeGestureRecognizer::QSwipeGestureRecognizer()
{
}

QGesture *QSwipeGestureRecognizer::create(QObject *target)
{
    if (target) {
        if (target->isWidgetType())
            static_cast<QWidget *>(target)->setAttribute(Qt::WA_AcceptTouchEvents);
        else
            return 0;
    }
    return new QSwipeGesture;
}

/* We only support touch events for the swipe gesture [multi-point touch gesture] */
QGestureRecognizer::Result QSwipeGestureRecognizer::recognize(QGesture *state,
                                                              QObject *,
                                                              QEvent *event)
{
    QSwipeGesture *q = static_cast<QSwipeGesture *>(state);

    QGestureRecognizer::Result result;

    switch (event->type()) {
    case QEvent::TouchBegin: {
        q->setProperty("gotTouched", true);
        q->setProperty("velocityValue", qreal(1));
        q->setProperty("d_verticalDirection", QSwipeGesture::NoDirection);
        q->setProperty("d_horizontalDirection", QSwipeGesture::NoDirection);

        QElapsedTimer time;
        time.start();
        q->setProperty("time",QVariant::fromValue(time));
        q->setProperty("started", true);
        result = QGestureRecognizer::MayBeGesture;
        break;
    }
    case QEvent::TouchEnd: {
        if (q->state() != Qt::NoGesture) {
            result = QGestureRecognizer::FinishGesture;
        } else {
            result = QGestureRecognizer::CancelGesture;
        }
        break;
    }
    case QEvent::TouchUpdate: {
        const QTouchEvent *ev = static_cast<const QTouchEvent *>(event);
        if (!q->property("started").toBool())
            result = QGestureRecognizer::CancelGesture;
        else if (ev->touchPoints().size() == 2) {
            QTouchEvent::TouchPoint p1 = ev->touchPoints().at(0);
            QTouchEvent::TouchPoint p2 = ev->touchPoints().at(1);

            if (q->property("lastPositions0").toPoint().isNull()) {
                q->setProperty("lastPositions0", p1.startScreenPos().toPoint());
                q->setProperty("lastPositions1", p2.startScreenPos().toPoint());
            }
            q->setHotSpot(p1.screenPos());

            QPoint lastPositions0 = q->property("lastPositions0").toPoint();
            QPoint lastPositions1 = q->property("lastPositions1").toPoint();

            int xDistance = (p1.screenPos().x() - lastPositions0.x() +
                             p2.screenPos().x() - lastPositions1.x()) / 2;
            int yDistance = (p1.screenPos().y() - lastPositions0.y() +
                             p2.screenPos().y() - lastPositions1.y()) / 2;
            int absXDistance = qAbs(xDistance);
            int absYDistance = qAbs(yDistance);

            const int distance = absXDistance >= absYDistance ? absXDistance : absYDistance;

            QElapsedTimer time = q->property("time").value<QElapsedTimer>();
            int elapsedTime = time.restart();
            q->setProperty("time", QVariant::fromValue(time));
            if (!elapsedTime)
                elapsedTime = 1;
            q->setProperty("velocityValue", 0.9 * q->property("velocityValue").toReal() + distance / elapsedTime);
            q->setSwipeAngle(QLineF(p1.startScreenPos(), p1.screenPos()).angle());

            static const int MoveThreshold = 50;
            if (absXDistance > MoveThreshold || absYDistance > MoveThreshold) {
                // measure the distance to check if the direction changed
                q->setProperty("lastPositions0", p1.screenPos().toPoint());
                q->setProperty("lastPositions1", p2.screenPos().toPoint());
                QSwipeGesture::SwipeDirection horizontal =
                        xDistance > 0 ? QSwipeGesture::Right : QSwipeGesture::Left;
                QSwipeGesture::SwipeDirection vertical =
                        yDistance > 0 ? QSwipeGesture::Down : QSwipeGesture::Up;
                if (q->property("d_verticalDirection").toInt() == QSwipeGesture::NoDirection)
                    q->setProperty("d_verticalDirection", vertical);
                if (q->property("d_horizontalDirection").toInt() == QSwipeGesture::NoDirection)
                    q->setProperty("d_horizontalDirection", horizontal);
                if (q->property("d_verticalDirection").toInt() != vertical || q->property("d_horizontalDirection").toInt() != horizontal) {
                    // the user has changed the direction!
                    result = QGestureRecognizer::CancelGesture;
                }
                result = QGestureRecognizer::TriggerGesture;
            } else {
                if (q->state() != Qt::NoGesture)
                    result = QGestureRecognizer::TriggerGesture;
                else
                    result = QGestureRecognizer::MayBeGesture;
            }
        } else if (ev->touchPoints().size() > 2) {
            result = QGestureRecognizer::CancelGesture;
        } else { // less than 2 touch points
            bool started = q->property("started").toBool();
            if (started && (ev->touchPointStates() & Qt::TouchPointPressed))
                result = QGestureRecognizer::CancelGesture;
            else if (started)
                result = QGestureRecognizer::Ignore;
            else
                result = QGestureRecognizer::MayBeGesture;
        }
        break;
    }
    default:
        result = QGestureRecognizer::Ignore;
        break;
    }
    return result;
}

void QSwipeGestureRecognizer::reset(QGesture *state)
{
    if (!state)
        return;
    QSwipeGesture *q = static_cast<QSwipeGesture *>(state);

    q->setProperty("d_verticalDirection", QSwipeGesture::NoDirection);
    q->setProperty("d_horizontalDirection", QSwipeGesture::NoDirection);
    q->setSwipeAngle(0);
    q->setProperty("gotTouched", false);

    q->setProperty("lastPositions0", QPoint());
    q->setProperty("lastPositions1", QPoint());
    q->setProperty("started", false);
    q->setProperty("velocityValue", 0);
    QElapsedTimer time = q->property("time").value<QElapsedTimer>();
    time.invalidate();
    q->setProperty("time", QVariant::fromValue(time));

    QGestureRecognizer::reset(state);
}

//
// QTapGestureRecognizer
//

QTapGestureRecognizer::QTapGestureRecognizer()
{
}

QGesture *QTapGestureRecognizer::create(QObject *target)
{
    if (target) {
        if (target->isWidgetType())
            static_cast<QWidget *>(target)->setAttribute(Qt::WA_AcceptTouchEvents);
        else
            return 0;
    }
    return new QTapGesture;
}

QGestureRecognizer::Result QTapGestureRecognizer::recognize(QGesture *state,
                                                            QObject *,
                                                            QEvent *event)
{
    QTapGesture *q = static_cast<QTapGesture *>(state);

    QGestureRecognizer::Result result = QGestureRecognizer::CancelGesture;

    switch (event->type()) {
    case QEvent::TouchBegin: {
        if (debugGestures) qDebug() << "tap: touch begin";
        q->setProperty("gotTouched", true);
        const QTouchEvent *ev = static_cast<const QTouchEvent *>(event);
        q->setPosition(ev->touchPoints().at(0).pos());
        q->setHotSpot(ev->touchPoints().at(0).screenPos());
        result = QGestureRecognizer::TriggerGesture;
        break;
    }
    case QEvent::TouchUpdate:
    case QEvent::TouchEnd: {
        if (debugGestures) qDebug() << "tap: touch end";
        const QTouchEvent *ev = static_cast<const QTouchEvent *>(event);
        if (q->state() != Qt::NoGesture && ev->touchPoints().size() == 1) {
            QTouchEvent::TouchPoint p = ev->touchPoints().at(0);
            QPoint delta = p.pos().toPoint() - p.startPos().toPoint();
            enum { TapRadius = 40 };
            if (delta.manhattanLength() <= TapRadius) {
                if (event->type() == QEvent::TouchEnd)
                    result = QGestureRecognizer::FinishGesture;
                else
                    result = QGestureRecognizer::TriggerGesture;
            }
        }
        break;
    }

    case QEvent::MouseButtonPress:
        if (!q->property("gotTouched").toBool()) {
            if (debugGestures) qDebug() << "tap: mouse press";
            QMouseEvent *ev = static_cast<QMouseEvent *>(event);
            if (!(ev->modifiers() & Qt::ControlModifier)) {
                state->setProperty("position", ev->globalPos());
                state->setHotSpot(ev->globalPos());
                event->accept();
                return QGestureRecognizer::TriggerGesture;
            }
        }
        return QGestureRecognizer::Ignore;

    case QEvent::MouseMove:
        return QGestureRecognizer::Ignore;

    case QEvent::MouseButtonRelease:
        if (!q->property("gotTouched").toBool()) {
            if (debugGestures) qDebug() << "tap: mouse release";
            if (state->state() == Qt::GestureStarted) {
                return QGestureRecognizer::FinishGesture;
            }
        }
        return QGestureRecognizer::Ignore;

    case QEvent::Gesture: {
        // We check for other gesture events: TapAndHold and Pan both cancel the simple Tap        
        QGestureEvent *ge = static_cast<QGestureEvent *>(event);
        if (ge->gesture(Qt::PanGesture) || ge->gesture(Qt::TapAndHoldGesture)) {
            if (state->state() == Qt::GestureStarted || state->state() == Qt::GestureUpdated)
                return QGestureRecognizer::CancelGesture;
        }
        return QGestureRecognizer::Ignore;
    }

    default:
        result = QGestureRecognizer::Ignore;
        break;
    }
    return result;
}

void QTapGestureRecognizer::reset(QGesture *state)
{
    if (!state)
        return;
    QTapGesture *q = static_cast<QTapGesture *>(state);
    q->setPosition(QPointF());
    q->setProperty("gotTouched", false);

    QGestureRecognizer::reset(state);
}

//
// QTapAndHoldGestureRecognizer
//

QTapAndHoldGestureRecognizer::QTapAndHoldGestureRecognizer()
{
}

QGesture *QTapAndHoldGestureRecognizer::create(QObject *target)
{
    if (target) {
        if (target->isWidgetType())
            static_cast<QWidget *>(target)->setAttribute(Qt::WA_AcceptTouchEvents);
        else
            return 0;
    }
    return new QTapAndHoldGesture;
}

QGestureRecognizer::Result
QTapAndHoldGestureRecognizer::recognize(QGesture *state, QObject *object,
                                        QEvent *event)
{
    QTapAndHoldGesture *q = static_cast<QTapAndHoldGesture *>(state);

    if (object == state && event->type() == QEvent::Timer) {
        q->killTimer(q->property("timerId").toInt());
        q->setProperty("timerId",0);
        return QGestureRecognizer::FinishGesture | QGestureRecognizer::ConsumeEventHint;
    }

    const QTouchEvent *ev = static_cast<const QTouchEvent *>(event);
//    const QMouseEvent *me = static_cast<const QMouseEvent *>(event);
#ifndef QT_NO_GRAPHICSVIEW
    const QMouseEvent *gsme = static_cast<const QMouseEvent *>(event);
#endif

    enum { TapRadius = 40 };

    switch (event->type()) {
#ifndef QT_NO_GRAPHICSVIEW
    case QEvent::MouseButtonPress:
        q->setPosition(gsme->globalPos());
        q->setHotSpot(q->position());
        if (q->property("timerId").toInt())
            q->killTimer(q->property("timerId").toInt());
        q->setProperty("timerId",q->startTimer(q->timeout()));
        return QGestureRecognizer::MayBeGesture; // we don't show a sign of life until the timeout
#endif
//    case QEvent::MouseButtonPress:
//        d->position = me->globalPos();
//        q->setHotSpot(d->position);
//        if (q->property("timerId").toInt())
//            q->killTimer(q->property("timerId").toInt());
//        q->setProperty("timerId",q->startTimer(QTapAndHoldGesturePrivate::Timeout));
//        return QGestureRecognizer::MayBeGesture; // we don't show a sign of life until the timeout
    case QEvent::TouchBegin:
        q->setPosition(ev->touchPoints().at(0).startScreenPos());
        q->setHotSpot(q->position());
        if (q->property("timerId").toInt())
            q->killTimer(q->property("timerId").toInt());
        q->setProperty("timerId",q->startTimer(q->timeout()));
        return QGestureRecognizer::MayBeGesture; // we don't show a sign of life until the timeout
#ifndef QT_NO_GRAPHICSVIEW
    case QEvent::MouseButtonRelease:
#endif
//    case QEvent::MouseButtonRelease:
    case QEvent::TouchEnd:
        return QGestureRecognizer::CancelGesture; // get out of the MayBeGesture state
    case QEvent::TouchUpdate:
        if (q->property("timerId").toInt() && ev->touchPoints().size() == 1) {
            QTouchEvent::TouchPoint p = ev->touchPoints().at(0);
            QPoint delta = p.pos().toPoint() - p.startPos().toPoint();
            if (delta.manhattanLength() <= TapRadius)
                return QGestureRecognizer::MayBeGesture;
        }
        return QGestureRecognizer::CancelGesture;
//    case QEvent::MouseMove: {
//        QPoint delta = me->globalPos() - d->position.toPoint();
//        if (q->property("timerId").toInt() && delta.manhattanLength() <= TapRadius)
//            return QGestureRecognizer::MayBeGesture;
//        return QGestureRecognizer::CancelGesture;
//    }
#ifndef QT_NO_GRAPHICSVIEW
    case QEvent::MouseMove: {
        QPoint delta = gsme->globalPos() - q->position().toPoint();
        if (q->property("timerId").toInt() && delta.manhattanLength() <= TapRadius)
            return QGestureRecognizer::MayBeGesture;
        return QGestureRecognizer::CancelGesture;
    }
#endif
    default:
        return QGestureRecognizer::Ignore;
    }
}

void QTapAndHoldGestureRecognizer::reset(QGesture *state)
{
    if (!state)
        return;
    QTapAndHoldGesture *q = static_cast<QTapAndHoldGesture *>(state);

    q->setPosition(QPointF());
    if (q->property("timerId").toInt())
        q->killTimer(q->property("timerId").toInt());
    q->setProperty("timerId",0);

    QGestureRecognizer::reset(state);
}

QT_END_NAMESPACE

#endif // QT_NO_GESTURES
