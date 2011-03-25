#include "qmldebugtools.h"
#include <QDebug>
#include <QString>


QmlDebugTools::QmlDebugTools():
        QObject()
{


}

void QmlDebugTools::writetofile(const QString &nameofFile,
                                const QString &message)
{

    QFile aFile(nameofFile);

    if ( aFile.open(QIODevice::WriteOnly | QIODevice::Append) )
    {
         aFile.write( message.toUtf8());
         aFile.write( "\n");
    }
    aFile.close();
}
