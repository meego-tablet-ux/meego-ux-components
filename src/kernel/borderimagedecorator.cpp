//#include <QDebug>
#include "borderimagedecorator.h"
#include "themeimageprovider.h"
#include "imageprovidercache.h"

#include <QtDeclarative/QtDeclarative>

BorderImageDecorator::BorderImageDecorator(QDeclarativeItem *parent) :
    QDeclarativeItem( parent ) ,
    pTarget( parent ),
    providerInstance( ThemeImageProvider::getCacheInstance() )
{
    m_source.clear();
}

BorderImageDecorator::~BorderImageDecorator()
{
    providerInstance = 0;
    m_source.clear();
    pTarget = 0;
}

void BorderImageDecorator::onSourceChanged()
{
    // qDebug() << "sourceChanged for";
    if( pTarget != 0 )
    {
        QVariant var = pTarget->property("source");
        if( var.type() == QVariant::Url ) {
            m_source = var.toUrl();
        }
        else {
            m_source.clear();
        }

    } else {
        m_source.clear();
    }

    getBorder();
}

QDeclarativeItem* BorderImageDecorator::object() const
{
    return pTarget;
}
void BorderImageDecorator::setObject(QDeclarativeItem *target)
{
    pTarget = target;

    if( pTarget == 0 ) {
        pTarget = this->parentItem();
    }
    if( pTarget != 0 )
    {
        connect( pTarget, SIGNAL( sourceChanged() ), this, SLOT( onSourceChanged() ) );
    }

    targetChanged();
    getBorder();
}

void BorderImageDecorator::componentComplete()
{
    getBorder();
}

void BorderImageDecorator::getBorder()
{
    m_borderTop = 0;
    m_borderBottom = 0;
    m_borderLeft = 0;
    m_borderRight = 0;

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

            providerInstance->requestBorderGrid( m_source.toString(), m_borderTop, m_borderBottom, m_borderLeft, m_borderRight );
            //qDebug() << "border for: " <<  m_source.toString() << m_borderTop << " " << m_borderBottom << " " << m_borderLeft<< " " << m_borderRight;

        } else {

            qWarning() << "Warning, no access to ImageProviderCache possible";

        }
    }

    emit borderChanged();

}

int BorderImageDecorator::borderTop() const
{
    return m_borderTop;
}
int BorderImageDecorator::borderBottom() const
{
    return m_borderBottom;
}
int BorderImageDecorator::borderRight() const
{
    return m_borderRight;
}
int BorderImageDecorator::borderLeft() const
{
    return m_borderLeft;
}

