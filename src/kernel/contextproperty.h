#ifndef QMLCONTEXTPROPERTY_H
#define QMLCONTEXTPROPERTY_H

#include <QObject>
#include <QDeclarativeItem>

class ContextProperty;

class QMLContextProperty : public QDeclarativeItem
{
    Q_OBJECT
    Q_PROPERTY(bool active READ getActive WRITE setActive NOTIFY activeNotify)
    Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameNotify)
    Q_PROPERTY(QVariant value READ getValue NOTIFY valueNotify)

public:
    explicit QMLContextProperty(QDeclarativeItem *parent = 0);
    virtual ~QMLContextProperty();

    const QString &getName() const;
    void setName(const QString &name);

    const QVariant &getValue() const;

    bool getActive() const;
    void setActive(bool active);

private:
    void unbind();
    void bind();

private slots:
    void valueChanged();

signals:
    void activeNotify();
    void nameNotify();
    void valueNotify();

private:
    ContextProperty *m_property;
    bool m_active;
    QString m_name;
    QVariant m_value;
};

#endif // QMLCONTEXTPROPERTY_H
