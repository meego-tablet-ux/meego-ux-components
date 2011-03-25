#ifndef FUZZYDATETIME_H
#define FUZZYDATETIME_H

#include <QObject>
#include <QDateTime>

class FuzzyDateTime : public QObject
{
    Q_OBJECT
public:
    explicit FuzzyDateTime(QObject *parent = 0);

    Q_INVOKABLE const QString getFuzzy(const QDateTime &dt) const;

signals:

public slots:

};

#endif // FUZZYDATETIME_H
