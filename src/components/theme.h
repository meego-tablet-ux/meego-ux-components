#ifndef THEME_H
#define THEME_H

#include <QObject>
#include <QString>
#include <QDeclarativeItem>
#include <QSettings>

class Theme : public QDeclarativeItem
{
    Q_OBJECT

    Q_PROPERTY( QString loadedThemeName READ loadedTheme NOTIFY signalLoadedTheme )

    Q_PROPERTY( QString fontFamily READ fontFamily )

    Q_PROPERTY( int fontPixelSizeLargest3 READ fontPixelSizeLargest3 NOTIFY fontPixelSizeLargest3 )
    Q_PROPERTY( int fontPixelSizeLargest2 READ fontPixelSizeLargest2 NOTIFY signalFontPixelSizeLargest2 )
    Q_PROPERTY( int fontPixelSizeLargest READ fontPixelSizeLargest NOTIFY signalFontPixelSizeLargest )
    Q_PROPERTY( int fontPixelSizeLarger READ fontPixelSizeLarger NOTIFY signalFontPixelSizeLarger )
    Q_PROPERTY( int fontPixelSizeLarge READ fontPixelSizeLarge NOTIFY signalFontPixelSizeLarge )
    Q_PROPERTY( int fontPixelSizeMediumLarge READ fontPixelSizeMediumLarge NOTIFY signalFontPixelSizeMediumLarge )
    Q_PROPERTY( int fontPixelSizeMedium READ fontPixelSizeMedium NOTIFY signalFontPixelSizeMedium )
    Q_PROPERTY( int fontPixelSizeNormal READ fontPixelSizeNormal NOTIFY signalFontPixelSizeNormal )
    Q_PROPERTY( int fontPixelSizeSmall READ fontPixelSizeSmall NOTIFY signalFontPixelSizeSmall )
    Q_PROPERTY( int fontPixelSizeSmaller READ fontPixelSizeSmaller NOTIFY signalFontPixelSizeSmaller )
    Q_PROPERTY( int fontPixelSizeSmallest READ fontPixelSizeSmallest NOTIFY signalFontPixelSizeSmallest )

    Q_PROPERTY( QString fontColorNormal READ fontColorNormal NOTIFY signalFontColorNormal )
    Q_PROPERTY( QString fontColorHighlight READ fontColorHighlight NOTIFY signalFontColorHighlight )
    Q_PROPERTY( QString fontColorInactive READ fontColorInactive NOTIFY signalFontColorInactive )
    Q_PROPERTY( QString fontColorMediaHighlight READ fontColorMediaHighlight NOTIFY signalFontColorMediaHighlight )
    Q_PROPERTY( QString fontBackgroundColor READ fontBackgroundColor NOTIFY signalFontBackgroundColor )
    Q_PROPERTY( QString dialogFogColor READ dialogFogColor NOTIFY signalDialogFogColor )

    Q_PROPERTY( QString dialogTitleFontColor READ dialogTitleFontColor NOTIFY signalDialogTitleFontColor )
    Q_PROPERTY( QString dialogBackgroundColor READ dialogBackgroundColor NOTIFY signalDialogBackgroundColor )
    Q_PROPERTY( int dialogTitleFontPixelSize READ dialogTitleFontPixelSize NOTIFY signalDialogTitleFontPixelSize )

    Q_PROPERTY( int dialogTitleFontPixelSize READ dialogTitleFontPixelSize NOTIFY signalDialogTitleFontPixelSize )
    Q_PROPERTY( qreal dialogFogOpacity READ dialogFogOpacity NOTIFY signalDialogFogOpacity )
    Q_PROPERTY( int dialogAnimationDuration READ dialogAnimationDuration NOTIFY signalDialogAnimationDuration )
    Q_PROPERTY( int dialogMargins READ dialogMargins NOTIFY signalDialogMargins )

    Q_PROPERTY( QString buttonFontColor READ buttonFontColor NOTIFY signalButtonFontColor )
    Q_PROPERTY( QString buttonFontColorActive READ buttonFontColorActive NOTIFY signalButtonFontColorActive )
    Q_PROPERTY( QString buttonFontColorInactive READ buttonFontColorInactive NOTIFY signalButtonFontColorInactive )
    Q_PROPERTY( qreal buttonActiveOpacity READ buttonActiveOpacity NOTIFY signalButtonActiveOpacity )
    Q_PROPERTY( qreal buttonInactiveOpacity READ buttonInactiveOpacity NOTIFY signalButtonInactiveOpacity )

    Q_PROPERTY( int toolbarFontPixelSize READ toolbarFontPixelSize NOTIFY signalToolbarFontPixelSize )
    Q_PROPERTY( QString toolbarFontColor READ toolbarFontColor NOTIFY signalToolbarFontColor )

    Q_PROPERTY( int thumbSize READ thumbSize NOTIFY signal )

    Q_PROPERTY( QString contextMenuBackgroundColor READ contextMenuBackgroundColor NOTIFY signalContextMenuBackgroundColor )
    Q_PROPERTY( QString contextMenuFontColor READ contextMenuFontColor NOTIFY signalContextMenuFontColor )
    Q_PROPERTY( int contextMenuFontPixelSize READ contextMenuFontPixelSize NOTIFY signalContextMenuFontPixelSize )

    Q_PROPERTY( int statusBarFontPixelSize READ statusBarFontPixelSize NOTIFY signalStatusBarFontPixelSize )
    Q_PROPERTY( QString statusBarFontColor READ statusBarFontColor NOTIFY signalStatusBarFontColor )
    Q_PROPERTY( QString statusBarBackgroundColor READ statusBarBackgroundColor NOTIFY signalStatusBarBackgroundColor )
    Q_PROPERTY( qreal statusBarOpacity READ statusBarOpacity NOTIFY signalStatusBarOpacity )

    public:
    explicit Theme(QDeclarativeItem* parent = 0);
    virtual ~Theme();

    QString loadedTheme() const;
    QString fontFamily() const;

    int fontPixelSizeLargest3() const;
    int fontPixelSizeLargest2() const;
    int fontPixelSizeLargest() const;
    int fontPixelSizeLarger() const;
    int fontPixelSizeLarge() const;
    int fontPixelSizeMediumLarge() const;
    int fontPixelSizeMedium() const;
    int fontPixelSizeNormal() const;

    int fontPixelSizeSmall() const;
    int fontPixelSizeSmaller() const;
    int fontPixelSizeSmallest() const;

    QString fontColorNormal() const;
    QString fontColorHighlight() const;
    QString fontColorInactive() const;
    QString fontColorMediaHighlight() const;
    QString fontBackgroundColor() const;

    QString dialogFogColor() const;
    QString dialogTitleFontColor() const;
    QString dialogBackgroundColor() const;
    int dialogTitleFontPixelSize() const;

    qreal dialogFogOpacity() const;
    int dialogAnimationDuration() const;
    int dialogMargins() const;

    QString buttonFontColor() const;
    QString buttonFontColorActive() const;
    QString buttonFontColorInactive() const;
    qreal buttonActiveOpacity() const;
    qreal buttonInactiveOpacity() const;

    int toolbarFontPixelSize() const;
    QString toolbarFontColor() const;

    int thumbSize() const;

    QString contextMenuBackgroundColor() const;
    QString contextMenuFontColor() const;
    int contextMenuFontPixelSize() const;

    int statusBarFontPixelSize() const;
    QString statusBarFontColor() const;
    QString statusBarBackgroundColor() const;
    qreal statusBarOpacity() const;

signals:
    void signalLoadedTheme();
    void signalFontFamily();

    void signalFontPixelSizeLargest3();
    void signalFontPixelSizeLargest2();
    void signalFontPixelSizeLargest();
    void signalFontPixelSizeLarger();
    void signalFontPixelSizeLarge();
    void signalFontPixelSizeMediumLarge();
    void signalFontPixelSizeMedium();
    void signalFontPixelSizeNormal();

    void signalFontPixelSizeSmall();
    void signalFontPixelSizeSmaller();
    void signalFontPixelSizeSmallest();

    void signalFontColorNormal();
    void signalFontColorHighlight();
    void signalFontColorInactive();
    void signalFontColorMediaHighlight();
    void signalFontBackgroundColor();

    void signalDialogFogColor();
    void signalDialogTitleFontColor();
    void signalDialogBackgroundColor();
    void signalDialogTitleFontPixelSize();

    void signalDialogFogOpacity();
    void signalDialogAnimationDuration();
    void signalDialogMargins();

    void signalButtonFontColor();
    void signalButtonFontColorActive();
    void signalButtonFontColorInactive();
    void signalButtonActiveOpacity();
    void signalButtonInactiveOpacity();

    void signalToolbarFontPixelSize();
    void signalToolbarFontColor();

    void signalThumbSize();

    void signalContextMenuBackgroundColor();
    void signalContextMenuFontColor();
    void signalContextMenuFontPixelSize();

    void signalStatusBarFontPixelSize();
    void signalStatusBarFontColor();
    void signalStatusBarBackgroundColor();
    void signalStatusBarOpacity();

private:
     QSettings* m_pSettings;

};
#endif // THEME_H
