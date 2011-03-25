#include "roundeditem.h"
#include <QDebug>

RoundedItem::RoundedItem(QDeclarativeItem *parent) :
    QDeclarativeItem(parent), mRadius(0)
{
    setClip(true);
}

double RoundedItem::radius() const
{
    return mRadius;
}

void RoundedItem::setRadius(double value)
{
    prepareGeometryChange();
    mRadius = value;
    emit radiusChanged();
    geometryChanged(boundingRect(), boundingRect());
}

QPainterPath RoundedItem::clipPath() const
{
    QPainterPath path;
    path.addRoundedRect(boundingRect(), mRadius, mRadius);

    return path;
}

QPainterPath RoundedItem::shape() const
{
    return clipPath();
}
