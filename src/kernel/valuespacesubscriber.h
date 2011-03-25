#ifndef VALUESPACESUBSCRIBER_H
#define VALUESPACESUBSCRIBER_H

#include <QDeclarativeParserStatus>
#include <QValueSpaceSubscriber>

class ValueSpaceSubscriber : public QObject, public QDeclarativeParserStatus
{
    Q_OBJECT
public:
    explicit ValueSpaceSubscriber(QObject *parent = 0);
    ~ValueSpaceSubscriber();

    Q_INTERFACES(QDeclarativeParserStatus);

    Q_PROPERTY(QString path READ path WRITE setPath NOTIFY pathChanged);

    Q_PROPERTY(QVariant value READ value NOTIFY valueChanged);

    QString path() const { return m_path; }

    void setPath(const QString path) ;

    QVariant value() const ;

    virtual void classBegin() {}

    virtual void componentComplete(){}

signals:
    void pathChanged();

    void valueChanged();

    void contentsChanged();

public slots:
    QVariant getValue(QString subPath) const;

private slots:
    void onContentsChanged();

private:
    QString m_path;

    QVariant m_value;

    QtMobility::QValueSpaceSubscriber* m_subscriber;
};

#endif // VALUESPACESUBSCRIBER_H
