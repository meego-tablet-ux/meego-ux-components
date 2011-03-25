#include "theme.h"
#include <QSettings>
#include <QApplication>

Theme::Theme(QDeclarativeItem* parent) : QDeclarativeItem(parent)
{
   m_pSettings = new QSettings();
}

Theme::~Theme()
{
    if(m_pSettings)
        delete m_pSettings;
}

QString Theme::loadedTheme() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "loadedTheme", "defaultTheme" ).toString();
    }
    return QString();
}

QString Theme::fontFamily() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "fontFamily", "Droid Sans" ).toString();
    }
    return QString();
}

int Theme::fontPixelSizeLargest3() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "fontPixelSizeLargest3", 40 ).toInt();
    }
    return 0;
}

int Theme::fontPixelSizeLargest2() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "fontPixelSizeLargest2", 35 ).toInt();
    }
    return 0;
}
int Theme::fontPixelSizeLargest() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "fontPixelSizeLargest", 26 ).toInt();
    }
    return 0;
}
int Theme::fontPixelSizeLarger() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "fontPixelSizeLarger", 22 ).toInt();
    }
    return 0;
}
int Theme::fontPixelSizeLarge() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "fontPixelSizeLarge", 20 ).toInt();
    }
    return 0;
}
int Theme::fontPixelSizeMediumLarge() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "fontPixelSizeMediumLarge", 17 ).toInt();
    }
    return 0;
}
int Theme::fontPixelSizeMedium() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "fontPixelSizeMedium", 14 ).toInt();
    }
    return 0;
}
int Theme::fontPixelSizeNormal() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "fontPixelSizeNormal", 14 ).toInt();
    }
    return 0;
}
int Theme::fontPixelSizeSmall() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "fontPixelSizeSmall", 10 ).toInt();
    }
    return 0;
}
int Theme::fontPixelSizeSmaller() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "fontPixelSizeSmaller", 8 ).toInt();
    }
    return 0;
}
int Theme::fontPixelSizeSmallest() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "fontPixelSizeSmallest", 6 ).toInt();
    }
    return 0;
}

QString Theme::fontColorNormal() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "fontColorNormal", "#4e4e4e" ).toString();
    }
    return QString();
}

QString Theme::fontColorHighlight() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "fontColorHighlight", "white" ).toString();
    }
    return QString();
}
QString Theme::fontColorInactive() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "fontColorInactive", "grey" ).toString();
    }
    return QString();
}

QString Theme::fontColorMediaHighlight() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "fontColorMediaHighlight", "white" ).toString();
    }
    return QString();
}
QString Theme::fontBackgroundColor() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "fontBackgroundColor", "#fba2ff" ).toString();
    }
    return QString();
}
QString Theme::dialogFogColor() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "dialogFogColor", "slategray" ).toString();
    }
    return QString();
}

QString Theme::dialogTitleFontColor() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "dialogTitleFontColor", "#4e4e4e" ).toString();
    }
    return QString();
}
QString Theme::dialogBackgroundColor() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "dialogBackgroundColor", "slategray" ).toString();
    }
    return QString();
}

int Theme::dialogTitleFontPixelSize() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "dialogTitleFontPixelSize", 18 ).toInt();
    }
    return 0;
}
qreal Theme::dialogFogOpacity() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "dialogFogOpacity", 0.8 ).toReal();
    }
    return 0.0;
}
int Theme::dialogAnimationDuration() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "dialogAnimationDuration", 250 ).toInt();
    }
    return 0;
}
int Theme::dialogMargins() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "dialogMargins", 10 ).toInt();
    }
    return 0;
}
QString Theme::buttonFontColor() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "buttonFontColor" ).toString();
    }
    return QString();
}
QString Theme::buttonFontColorActive() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "buttonFontColorActive", "purple" ).toString();
    }
    return QString();
}
QString Theme::buttonFontColorInactive() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "buttonFontColorInactive", "grey").toString();
    }
    return QString();
}
qreal Theme::buttonActiveOpacity() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "buttonActiveOpacity",  1.0 ).toReal();
    }
    return 0.0;
}
qreal Theme::buttonInactiveOpacity() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "buttonInactiveOpacity", 0.5 ).toReal();
    }
    return 0.0;
}

int Theme::toolbarFontPixelSize() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "toolbarFontPixelSize", 26 ).toInt();
    }
    return 0;
}
QString Theme::toolbarFontColor() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "toolbarFontColor", "#4e4e4e").toString();
    }
    return QString();
}

int Theme::thumbSize() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "thumbSize", 20 ).toInt();
    }
    return 0;
}
QString Theme::contextMenuBackgroundColor() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "contextMenuBackgroundColor", "grey" ).toString();
    }
    return QString();
}
QString Theme::contextMenuFontColor() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "contextMenuFontColor", "#666666" ).toString();
    }
    return QString();
}
int Theme::contextMenuFontPixelSize() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "contextMenuFontPixelSize", 20 ).toInt();
    }
    return 0;
}
int Theme::statusBarFontPixelSize() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "statusBarFontPixelSize", 10 ).toInt();
    }
    return 0;
}
QString Theme::statusBarFontColor() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "statusBarFontColor", "white" ).toString();
    }
    return QString();
}
QString Theme::statusBarBackgroundColor() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "statusBarBackgroundColor", "black" ).toString();
    }
    return QString();
}
qreal Theme::statusBarOpacity() const
{
    if( m_pSettings ) {
        return m_pSettings->value( "statusBarOpacity", 0.8 ).toReal();
    }
    return 0.0;
}
