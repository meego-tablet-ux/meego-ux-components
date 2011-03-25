#ifndef ROUNDEDITEM_H
#define ROUNDEDITEM_H

#include <QDeclarativeItem>

class RoundedItem : public QDeclarativeItem
{
    Q_OBJECT
    Q_PROPERTY(double radius READ radius WRITE setRadius NOTIFY radiusChanged)
public:
    explicit RoundedItem(QDeclarativeItem *parent = 0);

    double radius() const;
    void setRadius(double value);

    virtual QPainterPath clipPath() const;
    virtual QPainterPath shape() const;

signals:
    void radiusChanged();

private:
    double mRadius;

};

#endif // ROUNDEDITEM_H
