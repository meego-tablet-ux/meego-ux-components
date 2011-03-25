#ifndef QMLDEBUGTOOLS_H
#define QMLDEBUGTOOLS_H

#include <QObject>
#include <QFile>
#include <QTextStream>

class QmlDebugTools : public QObject
{
    Q_OBJECT
public:

    explicit QmlDebugTools();
    Q_INVOKABLE void writetofile( const QString& ,const QString& );


};

#endif // QMLDEBUGTOOLS_H
