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
    if( pTarget ) {
        QVariant var = pTarget->property("source");
        if( var.type() == QVariant::Url ) {
            m_source = var.toUrl();

            if( !providerInstance->existImage( m_source.toString() ) )
                overrideSource();
        }
    }

    getBorder();

    emit isValidSourceChanged();
}

void BorderImageDecorator::setDefaultSource( const QUrl& defaultSource )
{
    m_defaultSource = defaultSource;
    emit isValidSourceChanged();
    emit defaultSourceChanged();
}

QUrl BorderImageDecorator::defaultSource() const
{
    return m_defaultSource;
}

bool BorderImageDecorator::isValidSource() const
{
    bool existSource = providerInstance->existImage( m_source.toString() );
    bool existdefaultSource = providerInstance->existImage( m_defaultSource.toString() );
    if( existSource || existdefaultSource )
        return true;
    return false;
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

    if( m_source.isValid() &&  providerInstance->existImage( m_source.toString() ) ) {

        if( providerInstance ) {

            providerInstance->requestBorderGrid( m_source.toString(), m_borderTop, m_borderBottom, m_borderLeft, m_borderRight );            

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

void BorderImageDecorator::onSourceChanged()
{
    if( pTarget != 0 )
    {
        QVariant var = pTarget->property("source");
        if( var.type() == QVariant::Url ) {

            m_source = var.toUrl();
            if( !providerInstance->existImage( m_source.toString() ) )
                overrideSource();

        } else {
            m_source.clear();
            overrideSource();
        }

    } else {
        m_source.clear();
        overrideSource();
    }

    emit isValidSourceChanged();
    getBorder();
}

void BorderImageDecorator::overrideSource()
{
    if( !m_defaultSource.isEmpty() ) {

        m_source = m_defaultSource;

        if( pTarget != 0 )
        {
            QVariant newSource( m_source );
            pTarget->setProperty( "source", newSource );

        }

        emit isValidSourceChanged();
        getBorder();

    }
}
