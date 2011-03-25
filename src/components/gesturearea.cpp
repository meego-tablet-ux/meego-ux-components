#include "gesturearea.h"
#include <QEvent>
#include <QGestureEvent>
#include <QDebug>
GestureArea::GestureArea(QDeclarativeItem *parent)
    : QDeclarativeItem(parent)
{
    setAcceptTouchEvents(true);
    grabGesture(Qt::PinchGesture);
}

QGesture* GestureArea::gesture() const
{
    return m_gesture;
}


bool GestureArea::sceneEvent(QEvent *event)
{
    if (event->type() == QEvent::TouchBegin ||
        event->type() == QEvent::TouchEnd ||
        event->type() == QEvent::TouchUpdate) 
    {
        return true;
    }
    if (event->type() == QEvent::Gesture) {
        QGestureEvent * ge = static_cast<QGestureEvent*>(event);
        if (ge->gesture(Qt::PinchGesture) ) {
            m_gesture = ge->gesture(Qt::PinchGesture);
            Qt::GestureState state= m_gesture->state();
            if (state == Qt::GestureStarted) {
                emit gestureStarted();
            }else if (state == Qt::GestureCanceled || state == Qt::GestureFinished)
                emit gestureEnded();
            emit pinchGesture();
        }else if (ge->gesture(Qt::PanGesture)) {
            m_gesture = ge->gesture(Qt::PanGesture);
            Qt::GestureState state= m_gesture->state();
            if (state == Qt::GestureStarted) {
                emit gestureStarted();
            }else if (state == Qt::GestureCanceled || state == Qt::GestureFinished)
                emit gestureEnded();
            emit panGesture();
        }
            return true;
    }
    return QDeclarativeItem::sceneEvent(event);
}

