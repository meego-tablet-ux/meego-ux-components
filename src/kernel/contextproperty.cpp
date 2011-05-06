#include "contextproperty.h"
#include <contextsubscriber/contextproperty.h>

QMLContextProperty::QMLContextProperty(QDeclarativeItem *parent) :
    QDeclarativeItem(parent),
    m_property(NULL),
    m_active(false)
{
}

QMLContextProperty::~QMLContextProperty()
{
    unbind();
}

void QMLContextProperty::bind()
{
    if (m_active && !m_name.isEmpty())
    {
        m_property = new ContextProperty(m_name, this);
        connect(m_property, SIGNAL(valueChanged()), this, SLOT(valueChanged()));
    }
}

void QMLContextProperty::unbind()
{
    if (m_property)
    {
        m_property->unsubscribe();
        disconnect(m_property);
        m_property->deleteLater();
        m_property = NULL;
    }
}

const QString &QMLContextProperty::getName() const
{
	return m_name;
}

const QVariant &QMLContextProperty::getValue() const
{
	return m_value;
}

bool QMLContextProperty::getActive() const
{
	return m_active;
}

void QMLContextProperty::setName(const QString &name)
{
    if (name == m_name)
        return;
    unbind();
    m_name = name;
    emit nameNotify();
    bind();
}

void QMLContextProperty::setActive(bool active)
{
    if (active == m_active)
        return;
    unbind();
    m_active = active;
    emit activeNotify();
    /* Fire a name and value notification change as the UI may
     * now be out of sync with the model */
    emit nameNotify();
    emit valueNotify();
    bind();
}

void QMLContextProperty::valueChanged()
{
    if (m_value == m_property->value())
        return;
    m_value = m_property->value();
    if (!m_active)
	return;
    emit valueNotify();
}

QML_DECLARE_TYPE(QMLContextProperty);



