/*
 * Copyright 2010 Nokia Corporation and/or its subsidiary(-ies).
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#ifndef QDECLARATIVEGESTUREHANDLER_H
#define QDECLARATIVEGESTUREHANDLER_H

#include <QtDeclarative/qdeclarative.h>
#include <QtDeclarative/qdeclarativescriptstring.h>
#include <QtCore/qobject.h>
#include <QtCore/qstringlist.h>
#include <QtGui/qgesture.h>

#ifndef QT_NO_GESTURES

QT_BEGIN_HEADER

QT_BEGIN_NAMESPACE

QT_MODULE(Declarative)

class QGesture;
class QDeclarativeBinding;
class QDeclarativeGestureHandlerPrivate;
class QDeclarativeGestureHandler : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int gestureType READ gestureType WRITE setGestureType)
    Q_PROPERTY(QObject *parent READ parent DESIGNABLE false FINAL)
    Q_PROPERTY(QDeclarativeScriptString when READ when WRITE setWhen)
    Q_PROPERTY(QDeclarativeScriptString onStarted READ onStarted WRITE setOnStarted)
    Q_PROPERTY(QDeclarativeScriptString onUpdated READ onUpdated WRITE setOnUpdated)
    Q_PROPERTY(QDeclarativeScriptString onCanceled READ onCanceled WRITE setOnCanceled)
    Q_PROPERTY(QDeclarativeScriptString onFinished READ onFinished WRITE setOnFinished)
    Q_PROPERTY(QObject *gesture READ gesture WRITE setGesture NOTIFY gestureChanged)

public:
    bool isWhenKnown() const;
    QDeclarativeScriptString when() const;
    void setWhen(const QDeclarativeScriptString &script);

    QDeclarativeScriptString onStarted() const;
    void setOnStarted(const QDeclarativeScriptString &script);

    QDeclarativeScriptString onUpdated() const;
    void setOnUpdated(const QDeclarativeScriptString &script);

    QDeclarativeScriptString onCanceled() const;
    void setOnCanceled(const QDeclarativeScriptString &script);

    QDeclarativeScriptString onFinished() const;
    void setOnFinished(const QDeclarativeScriptString &script);

    QObject *gesture() const;
    void setGesture(QObject *gesture);

    int gestureType() const;

Q_SIGNALS:
    void gestureChanged();

protected:
    QDeclarativeGestureHandler(QObject *parent = 0);
    ~QDeclarativeGestureHandler();

    void setGestureType(int type);

private:
    QDeclarativeGestureHandlerPrivate *d_ptr;

    friend class QDeclarativeGestureArea;
    Q_DISABLE_COPY(QDeclarativeGestureHandler)
    Q_DECLARE_PRIVATE(QDeclarativeGestureHandler)
};

class QDeclarativePanGestureHandler : public QDeclarativeGestureHandler
{
    Q_OBJECT
public:
    QDeclarativePanGestureHandler(QObject *parent = 0)
        : QDeclarativeGestureHandler(parent)
    {
        setGestureType(Qt::PanGesture);
    }

private:
    Q_DISABLE_COPY(QDeclarativePanGestureHandler)
};

class QDeclarativeDefaultGestureHandler : public QDeclarativeGestureHandler
{
    Q_OBJECT
public:
    QDeclarativeDefaultGestureHandler(QObject *parent = 0)
        : QDeclarativeGestureHandler(parent)
    {
    }

private:
    Q_DISABLE_COPY(QDeclarativeDefaultGestureHandler)
};

class QDeclarativePinchGestureHandler : public QDeclarativeGestureHandler
{
    Q_OBJECT
public:
    QDeclarativePinchGestureHandler(QObject *parent = 0)
        : QDeclarativeGestureHandler(parent)
    {
        setGestureType(Qt::PinchGesture);
    }

private:
    Q_DISABLE_COPY(QDeclarativePinchGestureHandler)
};

class QDeclarativeTapGestureHandler : public QDeclarativeGestureHandler
{
    Q_OBJECT
public:
    QDeclarativeTapGestureHandler(QObject *parent = 0)
        : QDeclarativeGestureHandler(parent)
    {
        setGestureType(Qt::TapGesture);
    }

private:
    Q_DISABLE_COPY(QDeclarativeTapGestureHandler)
};

class QDeclarativeTapAndHoldGestureHandler : public QDeclarativeGestureHandler
{
    Q_OBJECT
public:
    QDeclarativeTapAndHoldGestureHandler(QObject *parent = 0)
        : QDeclarativeGestureHandler(parent)
    {
        setGestureType(Qt::TapAndHoldGesture);
    }

private:
    Q_DISABLE_COPY(QDeclarativeTapAndHoldGestureHandler)
};

class QDeclarativeSwipeGestureHandler : public QDeclarativeGestureHandler
{
    Q_OBJECT
public:
    QDeclarativeSwipeGestureHandler(QObject *parent = 0)
        : QDeclarativeGestureHandler(parent)
    {
        setGestureType(Qt::SwipeGesture);
    }

private:
    Q_DISABLE_COPY(QDeclarativeSwipeGestureHandler)
};

QT_END_NAMESPACE

QML_DECLARE_TYPE(QDeclarativeGestureHandler)
QML_DECLARE_TYPE(QDeclarativeDefaultGestureHandler)
QML_DECLARE_TYPE(QDeclarativePanGestureHandler)
QML_DECLARE_TYPE(QDeclarativePinchGestureHandler)
QML_DECLARE_TYPE(QDeclarativeTapGestureHandler)
QML_DECLARE_TYPE(QDeclarativeTapAndHoldGestureHandler)
QML_DECLARE_TYPE(QDeclarativeSwipeGestureHandler)

QT_END_HEADER

#endif // QT_NO_GESTURES

#endif
