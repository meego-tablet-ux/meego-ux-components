#ifndef GESTUREAREA_H
#define GESTUREAREA_H

#include <QtDeclarative/qdeclarativeitem.h>
#include <QGesture>

class GestureArea: public QDeclarativeItem
{
    Q_OBJECT

    Q_PROPERTY(QGesture *gesture READ gesture);
  //  Q_PROPERTY(QGesture *pangesture READ pangesture)

public:

    GestureArea(QDeclarativeItem * parent = 0);
    QGesture *gesture() const;

signals:
    void pinchGesture();
    void panGesture();
    void gestureStarted();
    void gestureEnded();
protected:
    bool sceneEvent(QEvent *event);

private:
    QGesture * m_gesture;
};

#endif
