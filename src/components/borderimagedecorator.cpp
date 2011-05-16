#include <QDebug>
#include "borderimagedecorator.h"
#include "themeimageprovider.h"

BorderImageDecorator::BorderImageDecorator(QDeclarativeItem *parent) :
    QDeclarativeItem( parent ) ,
    pTarget( parent ),
    providerInstance( ThemeImageProvider::getCacheInstance() )
{
    m_source.clear();
    qDebug() << "bla providerInstance: " << (providerInstance != 0);
}

BorderImageDecorator::~BorderImageDecorator()
{
    providerInstance = 0;
}

void BorderImageDecorator::setSource( const QUrl source )
{
    m_source = source;
    sourceChanged();
}

QUrl BorderImageDecorator::source() const
{
    return m_source;
}

QDeclarativeItem* BorderImageDecorator::object() const
{
    return pTarget;
}

void BorderImageDecorator::setObject(QDeclarativeItem *target)
{
    pTarget = target;
    targetChanged();
}

void BorderImageDecorator::componentComplete()
{
    if( pTarget == 0 ) {
        pTarget = this->parentItem();
    }
    if( pTarget != 0 )
    {
        if( m_source.isEmpty() ) {
            QVariant var = pTarget->property("source");
            if( var.type() == QVariant::Url ) {
                m_source = var.toUrl();
            }
        }
    }

    if( m_source.isValid() ) {

        if( providerInstance ) {
            providerInstance->requestBorderGrid( m_source.toString(), borderTop, borderBottom, borderLeft, borderRight );
        } else {
            qWarning() << "Warning, no access to ImageProviderCache possible";
        }
    }

    if( pTarget != 0) {

        qDebug() << pTarget->dynamicPropertyNames();
        QVariant border = pTarget->property( "border" );

        qDebug() <<  border.type() ;
        qDebug() <<  border.typeName();
        qDebug() <<  border.userType();

        QObject* obj = (QObject*)border.data();

        if( obj )
        {
            obj->setProperty("left", borderLeft );
        }

    }
}
