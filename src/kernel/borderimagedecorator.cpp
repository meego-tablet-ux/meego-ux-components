#include <QDebug>
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
    m_defaultSource.clear();
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

    m_source = pTarget->property("source").toUrl();

    targetChanged();
    getBorder();
}

void BorderImageDecorator::setSource( const QUrl& source )
{
    if( m_source != source )
    {
        m_source = source;

        getBorder();

        emit sourceChanged();
        emit isValidSourceChanged();
    }
}

QUrl BorderImageDecorator::source() const
{
    return m_source;
}

void BorderImageDecorator::setDefaultSource( const QUrl& defaultSource )
{
    if( m_defaultSource != defaultSource ) {

        if ( m_defaultSource == m_source )
            m_source.clear();

        m_defaultSource = defaultSource;

        getBorder();

        emit isValidSourceChanged();
        emit defaultSourceChanged();
    }
}

QUrl BorderImageDecorator::defaultSource() const
{
    return m_defaultSource;
}

bool BorderImageDecorator::isValidSource() const
{    
    bool existSource = providerInstance->existImage( m_source.toString() );
    bool existdefaultSource = providerInstance->existImage( m_defaultSource.toString() );
    if( existSource || existdefaultSource ) {
        return true;
    }
    return false;
}

bool BorderImageDecorator::needReplacement() const
{
    if( m_defaultSource.isEmpty() )
        return false;

    bool existSource = providerInstance->existImage( m_source.toString() );
    bool existdefaultSource = providerInstance->existImage( m_defaultSource.toString() );

    if( !existSource && existdefaultSource ) {
        return true;
    }
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
