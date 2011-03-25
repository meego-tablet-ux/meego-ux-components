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

    /* generic font point sizes */
    property int fontPixelSizeLargest3: 40
    property int fontPixelSizeLargest2: 35
    property int fontPixelSizeLargest: 26

    property int fontPixelSizeLarger: 22
    property int fontPixelSizeLarge: 20
    property int fontPixelSizeMediumLarge: 17
    property int fontPixelSizeMedium: 14
    property int fontPixelSizeNormal: 14

    property int fontPixelSizeSmall: 10

    property int fontPixelSizeSmaller: 8
    property int fontPixelSizeSmallest: 6

    /* generic font colors */
    property string fontColorNormal: "#4e4e4e"
    property string fontColorHighlight: "white"
    property string fontColorHighlightBlue: "#2fa7d4"
    property string fontColorInactive: "grey"
    property string fontColorMediaHighlight: "white"
    property string fontBackgroundColor: "#fba2ff"

    /* dialog properties */
    property string dialogFogColor: "slategray"
    property string dialogTitleFontColor: "#4e4e4e"
    property string dialogBackgroundColor: "slategray"
    property int dialogTitleFontPixelSize: 18
    property real dialogFogOpacity: 0.8
    property int dialogAnimationDuration: 250
    property int dialogMargins: 10

    /* button properties */
    property string buttonFontColor: "white"
    property string buttonFontColorActive: "purple"
    property string buttonFontColorInactive: "grey"
    property real buttonActiveOpacity: 1.0
    property real buttonInactiveOpacity: 0.5

    /* toolbar properties */
    property int toolbarFontPixelSize: 26
    property string toolbarFontColor: "#4e4e4e"

    /* thumbnail properties */
    property int thumbSize: 230
    property int thumbColumnCount: 5

    /* search bar properties */
//    qreal searchbarFontPixelSize()
//        { return realValue("searchbarFontPixelSize", 20); }
//    QString searchbarFontColor()
//        { return stringValue("searchbarFontColor", "white"); }

    /* context menu properties */
    property string contextMenuBackgroundColor: "grey"
    property string contextMenuFontColor: "#666666" // "white"
    property int contextMenuFontPixelSize: 20

    /* application menu properties */
//    QString appMenuBackgroundColor()
//        { return stringValue("appMenuBackgroundColor", "grey"); }
//    QString appMenuFontColor()
//        { return stringValue("appMenuFontColor", "white"); }
//    int appMenuFontPixelSize()
//        { return intValue("appMenuFontPixelSize", 30); }

    /* window properties */
//    QString backgroundColor()
//        { return stringValue("backgroundColor", "black"); }
//    QString sidepanelBackgroundColor()
//        { return stringValue("sidepanelBackgroundColor", "black"); }
//    QString highlightColor()
//        { return stringValue("highlightColor", "yellow"); }
//    QString textInputBackgroundColor()
//        { return stringValue("textInputBackgroundColor", "white"); }

    /* launcher properties */
//    qreal iconFontPixelSize()
//        { return realValue("iconFontPixelSize", 16); }
//    QString iconFontColor()
//        { return stringValue("iconFontColor", "white"); }
//    QString iconFontBackgroundColor()
//        { return stringValue("iconFontBackgroundColor", "slategray"); }

    /* taskswitcher properties */
//    int taskSwitcherNumRows()
//        { return intValue("taskSwitcherNumRows", 3); }
//    int taskSwitcherNumCols()
//        { return intValue("taskSwitcherNumCols", 3); }
//    bool taskSwitcherShowGridIcon()
//        { return boolValue("taskSwitcherShowGridIcon", true); }
//    int taskSwitcherIconWidth()
//        { return intValue("taskSwitcherIconWidth", 100); }
//    int taskSwitcherIconHeight()
//        { return intValue("taskSwitcherIconHeight", 100); }
//    int taskSwitcherIconContainerWidth()
//        { return intValue("taskSwitcherIconContainerWidth", 120); }
//    int taskSwitcherIconContainerHeight()
//        { return intValue("taskSwitcherIconContainerHeight", 120); }

    property int statusBarFontPixelSize: 10
    property string statusBarFontColor: "white"
    property string statusBarBackgroundColor: "black"
    property real statusBarOpacity: 0.8
}
