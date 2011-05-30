/*
 * Copyright 2010 Nokia Corporation and/or its subsidiary(-ies).
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#ifndef QDECLARATIVEGESTUREAREA_H
#define QDECLARATIVEGESTUREAREA_H

#include <qdeclarativeitem.h>
#include <qdeclarativescriptstring.h>

#include <QtCore/qobject.h>
#include <QtCore/qstring.h>
#include <QtGui/qgesture.h>

#include "qdeclarativegesturehandler_p.h"

#ifndef QT_NO_GESTURES

QT_BEGIN_HEADER

QT_BEGIN_NAMESPACE

QT_MODULE(Declarative)

class QDeclarativeBoundSignal;
class QDeclarativeContext;
class QGestureEvent;
class QDeclarativeGestureAreaPrivate;
class QDeclarativeGestureArea : public QDeclarativeItem
{
    Q_OBJECT

    Q_PROPERTY(QDeclarativeListProperty<QObject> handlers READ handlers)
    Q_PROPERTY( bool blockMouseEvents READ blockMouseEvents WRITE setBlockMouseEvents NOTIFY blockMouseEventsChanged )
    Q_PROPERTY( bool absolute READ absolute WRITE setAbsolute NOTIFY absoluteChanged )
    Q_CLASSINFO("DefaultProperty", "handlers")

public:
    QDeclarativeGestureArea(QDeclarativeItem *parent=0);
    ~QDeclarativeGestureArea();

    QDeclarativeListProperty<QObject> handlers();

protected:
    bool sceneEvent(QEvent *event);

signals:
    void blockMouseEventsChanged();
    void absoluteChanged();

private:
    QDeclarativeGestureAreaPrivate *d_ptr;

    bool absolute() const;
    void setAbsolute( bool absolute );

    bool blockMouseEvents() const;
    void setBlockMouseEvents( bool blockMouseEvent );

    Q_DISABLE_COPY(QDeclarativeGestureArea)
    Q_DECLARE_PRIVATE_D(QGraphicsItem::d_ptr.data(), QDeclarativeGestureArea)
};

QT_END_NAMESPACE

QML_DECLARE_TYPE(QDeclarativeGestureArea)

QT_END_HEADER

#endif // QT_NO_GESTURES

#endif
