#include <QValueSpacePublisher>
#include "valuespacepublisher.h"

ValueSpacePublisher::ValueSpacePublisher(QObject *parent):
    QObject(parent) ,
    m_publisher(0)
{
    // should move this to a global place, so we only initialize it once
    // and when close the publisher, the subscriber will not crash
    QValueSpace::initValueSpaceServer();
}

ValueSpacePublisher::~ValueSpacePublisher()
{
    delete m_publisher;
}

void ValueSpacePublisher::setPath(const QString path)
{
    QString tpath = path.trimmed();
    if (m_path == tpath) {
        return;
    }

    m_path = tpath;

    delete m_publisher;

    m_publisher = new QValueSpacePublisher(m_path);

    emit pathChanged();
}


void ValueSpacePublisher::setValue(const QString &name, const QVariant &data)
{
    if (m_publisher) {
        m_publisher->setValue(name, data);
    }
}
