/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
   \qmlclass Theme
   \title Theme
   \section1 Theme
   The Theme contains all theme defined values. For example font sizes and colors. You can access them by creating a Theme object
   in your qml and get the desired value via <objectname>.<value>. It's recommended to create the Theme object in the highest possible
   parent to  give all children access.

  \section2 Example
  \qml
    Text {
      id: textItem

      Theme { id: theme }

      font.pixelSize: theme.fontPixelSizeLargest
    }
  \endqml
*/

import Qt 4.7

Item {
    // This qml holds theme variables for the entire components.
    // Instantiate it in the top most parent of your widgets to gain access to the values

    /* font family */
    property string fontFamily: "Droid Sans"

    /* Headers, Places */
    property int fontPixelSizeLarge: 21

    /* Standard Text, Menus
       this was formerly 14, changing to follow new specs*/
    property int fontPixelSizeNormal: 18

    /* Dimmed Text, Lists
       this was formerly 10, changing to follow new specs*/
    property int fontPixelSizeSmall: 15

    /* Calendars, Disclaimer Text
       this was formerly 6, changing to follow new specs*/
    property int fontPixelSizeTiny: 13

    /* THIS STUFF IS DEPCRECATED. Please merge in the 'font-sizes' branch found in your app's repo soon. */
    property int fontPixelSizeLargest3: 40
    property int fontPixelSizeLargest2: 35
    property int fontPixelSizeLargest: 26
    property int fontPixelSizeLarger: 22
    property int fontPixelSizeMediumLarge: 17
    property int fontPixelSizeMedium: 14
    property int fontPixelSizeSmaller: 8
    property int fontPixelSizeSmallest: 6
    /* END DEPCRECATED BLOCK */

    /* generic font colors */
    property string fontColorNormal: "#4e4e4e"
    property string fontColorHighlight: "white"
    property string fontColorHighlightBlue: "#2fa7d4"
    property string fontColorInactive: "grey"
    property string fontColorMediaHighlight: "white"
    property string fontBackgroundColor: "#fba2ff"
    // generic font colors from intel theme.ini
    property string fontColorSelected: "#ffffff"

    /* modal dialog properties */
    property string dialogFogColor: "#000000"
    property real dialogFogOpacity: 0.6
    property string dialogTitleFontColor: "#383838"
    property int dialogTitleFontPixelSize: 18
    property int dialogAnimationDuration: 300
    property string dialogBackgroundColor: "white"
    property int dialogLeftMarginPixelSize: 20
    property int dialogRightMarginPixelSize: 20
    property int dialogWidthPixelSize: 504
    property int dialogTitleAreaHeightPixelSize: 55
    property int dialogTitleBaselineFromTopPixelSize: 35
    property int dialogButtonsBottomMarginPixelSize: 10
    property int dialogButtonSpacingPixelSize: 10
    property int dialogContentAreaTopAndBottomMarginPixelSize: 20
    property int dialogMargins: 10 //deprecated

    /* button properties */
    property string buttonFontColor: "white"
    property string buttonFontColorActive: "#1fa0d3"
    property string buttonFontColorInactive: "grey"
    property real buttonActiveOpacity: 1.0
    property real buttonInactiveOpacity: 0.5
    property int buttonRowSpacingPixelSize: 10

    /* list properties ( One and Two refer to the lines of text in each list item ) */
    property int listBackgroundPixelHeightOne: 75
    property int listBackgroundPixelHeightTwo: 90

    /* toolbar properties */
    property int toolbarFontPixelSize: 21
    property string toolbarFontColor: "#3d3d3d"

    /* thumbnail properties */
    property int thumbSize: 230
    property int thumbColumnCountLandscape: 5
    property int thumbColumnCountPortrait: 3

    /* search bar properties */
    property int searchbarFontPixelSize: 20
    property string searchbarFontColor: "#383838"

    /* context menu properties */
    property string contextMenuBackgroundColor: "white"
    property string contextMenuFontColor: "#666666"
    property int contextMenuFontPixelSize: 20

    /* application menu properties */
    property string appMenuBackgroundColor: "white"
    property string appMenuFontColor: "#383838"
    property int appMenuFontPixelSize: 35

    /* window properties */
    property string backgroundColor: "black"
    property string sidepanelBackgroundColor: "black"
    property string highlightColor: "#def1f9"
    property string textInputBackgroundColor: "white"

    /* progress bar properties */
    property string fontColorProgress: "black"
    property string fontColorProgressFilled: "white"

    /* task switcher / homescreen icon properties */
    property int iconTextPadding: 5
    property int iconFontPixelSize: 18
    property string iconFontColor: "white"
    property string iconFontBackgroundColor: "#000000"
    property real iconFontBackgroundOpacity: 0.15
    property string iconFontDropshadowColor: "#383838"


    /* taskswitcher properties */
    property int taskSwitcherNumRows: 3
    property int taskSwitcherNumCols: 3
    property bool taskSwitcherShowGridIcon: true
    property int taskSwitcherIconWidth: 100
    property int taskSwitcherIconHeight: 100
    property int taskSwitcherIconContainerWidth: 120
    property int taskSwitcherIconContainerHeight: 120
    property string taskSwitcherVerticalSeperatorColor: "#3d3d3d"
    property int taskSwitcherVerticalSeperatorMargin: 20
    property int taskSwitcherVerticalSeperatorThickness: 1
    property string taskSwitcherHorizontalSeperatorColor: "#3d3d3d"
    property int taskSwitcherHorizontalSeperatorMargin: 0
    property int taskSwitcherHorizontalSeperatorThickness: 1
    property int taskSwitcherDialogMargin: 20

    /* status bar properties */
    property string statusBarBackgroundColor: "#000000"
    property real statusBarOpacity: 1.0
    property string statusBarFontColor: "#ffffff"
    property int statusBarFontPixelSize: 11
    property int statusBarHeight: 25

    /* temporary value for controlling just the statusbar used for the
       application grid and the panels view. As soon as the normal Window
       can correctly place the statusbar on top of the application background,
       then this should be removed. */
    property real panelStatusBarOpacity: 0.4
    property string panelFontColor: "white"

    /* add a value to control where the inner child of the panels should be placed relative to the background image */
    property int panelBodyMargin: 12

    /* notifications properties */
    property string statusBatteryPowerGoodColor: "#57e601"
    property string statusBatteryPowerMediumColor: "#e6b301"
    property string statusBatteryPowerLowColor: "#e60101"

    /* lockscreen properties */
    property int lockscreenTimeFontPixelSize: 60
    property string lockscreenTimeFontColor: "white"
    property string lockscreenTimeFontDropshadowColor: "#383838"
    property int lockscreenDateFontPixelSize: 21
    property string lockscreenDateFontColor: "white"
    property string lockscreenDateFontDropshadowColor: "#383838"
    property string lockscreenShapeTimeColor: "#111212"
    property real lockscreenShapeTimeOpacity: 0.1
    property string lockscreenShapeMusicColor: "#daele5"
    property real lockscreenShapeMusicAlbumOpacity: 0.5
    property real lockscreenShapeMusicMetadataOpacity: 0.8

    /* box properties */
    property string commonBoxColor: "#ffffff"
    property int commonBoxHeight: 100

    /* autocomplete drop list properties */
    property int suggestionItemPixelHeight: 57
    property string suggestionColor: "4e4e4e"

    /* Omnibox properties */
    property string urlBarHighlightColor: "#2CACE3"

    /* Media grid title background */
    property string mediaGridTitleBackgroundColor: "#000000"
    property real mediaGridTitleBackgroundAlpha: 0.7

    /* date picker properties */
    property string datePickerSelectedColor: "#2fa7d4"
    property string datePickerUnselectedColor: "white"
    property string datePickerUnselectableColor: "lightgrey"
}
