/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass BottomToolBarRow
  \title BottomToolbarRow
  \section1 BottomToolBarRow
  \qmlcm The BottonToolbarRow is one layout implementation for the BottomToolBar, which contains a left, center and a
  right content field.

  \section2  API Properties
    \qmlproperty alias leftContent
    \qmlcm the alias to the left content of the row
    \qmlproperty alias centerContent
    \qmlcm the alias to the centered content of the row
    \qmlproperty alias rightContent
    \qmlcm the alias to the right content of the row
    \qmlproperty int contentVerticalMargins
    \qmlcm the vertical margin of the content areas
    \qmlproperty int contentHorizontalMargins
    \qmlcm the horizontal margin of the content areas
    \qmlproperty int spacing
    \qmlcm ths spacing between the content areas

  \section2 Signal
  \qmlnone

  \section2 Example
  \qml
        BottomToolBar {

            content: BottomToolBarRow {

                id: bottomToolbarRow

                leftContent: [
                    IconButton {
                        id: button1
                        icon: "image://themedimage/images/media/icn_addtoalbum_up"
                        iconDown: "image://themedimage/images/media/icn_addtoalbum_dn"
                        width: 60
                        hasBackground: false
                    },
                    IconButton {
                        id: button2
                        icon: "image://themedimage/images/media/icn_addtoalbum_up"
                        iconDown: "image://themedimage/images/media/icn_addtoalbum_dn"
                        width: 60
                        hasBackground: false
                    }
                ]
                centerContent: [
                    Slider {
                        id: slider
                        width: 320
                        textOverlayVisible: false
                    }
                ]
                rightContent: [
                    IconButton {
                        id: button5
                        icon: "image://themedimage/images/media/icn_addtoalbum_up"
                        iconDown: "image://themedimage/images/media/icn_addtoalbum_dn"
                        width: 60
                        hasBackground: false
                    },
                    IconButton {
                        id: button6
                        icon: "image://themedimage/images/media/icn_addtoalbum_up"
                        iconDown: "image://themedimage/images/media/icn_addtoalbum_dn"
                        width: 60
                        hasBackground: false
                    }
                ]
            }
        }
    \endqml
*/

import Qt 4.7

Item {
    id : bottomToolBarRow

    // API
    property alias leftContent: contentLeft.children
    property alias centerContent: contentCenter.children
    property alias rightContent: contentRight.children

    property int contentVerticalMargins: 5
    property int contentHorizontalMargins: 5
    property int spacing: 2

    anchors.fill: parent

    Row {
        id: contentLeft

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors {
            leftMargin: contentHorizontalMargins; rightMargin: contentHorizontalMargins;
            topMargin: contentVerticalMargins; bottomMargin: contentVerticalMargins
        }
        spacing: spacing

        visible: parent.visible
        opacity: visible ? 1 : 0    // force repaint
    }
    Row {
        id: contentCenter

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors {
            leftMargin: contentHorizontalMargins; rightMargin: contentHorizontalMargins;
            topMargin: contentVerticalMargins; bottomMargin: contentVerticalMargins
        }
        spacing: spacing

        visible: parent.visible
        opacity: visible ? 1 : 0    // force repaint
    }
    Row {
        id: contentRight

        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors {
            leftMargin: contentHorizontalMargins; rightMargin: contentHorizontalMargins;
            topMargin: contentVerticalMargins; bottomMargin: contentVerticalMargins
        }
        spacing: spacing

        visible: parent.visible
        opacity: visible ? 1 : 0    // force repaint
    }
}

