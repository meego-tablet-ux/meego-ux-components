#include <QtDeclarative/qdeclarative.h>
#include <QFile>
#include <QX11Info>
#include "windowelement.h"
#include "systemiconprovider.h"

WindowElement::WindowElement(WindowInfo info, QObject *parent) :
    QObject(parent),
    m_title(info.title()),
    m_windowId(info.window())
{
    SystemIconProvider provider;

    if (info.icon())
        m_pixmap = QPixmap::fromX11Pixmap(info.icon());
    else if (!info.iconName().isEmpty())
    {
        m_pixmap = provider.requestPixmap(info.iconName(), NULL, QSize());
    }
    else
    {
        // App icon wasn't set, and iconName wasn't set... fallback to default
        m_pixmap = provider.requestPixmap("default", NULL, QSize());
    }

    if (!info.notificationIconName().isEmpty())
    {
        m_notify = provider.requestPixmap(info.notificationIconName(), NULL, QSize());
    }
}

QML_DECLARE_TYPE(WindowElement);
