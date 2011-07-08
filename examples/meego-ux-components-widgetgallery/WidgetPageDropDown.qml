/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This pages can call up the ExpandingBox.qml and offers controls to manipulate it.
 */

import Qt 4.7
import MeeGo.Components 0.1

WidgetPage {
    id: widgetPage

    pageTitle: "Drop Down"

    controlContent: [

        CheckBoxEntry {
            id: showCornerDropDowns

            label: "show in corner"

            onCheckedChanged: {
                if( showCornerDropDowns.isChecked ) {
                    ddown2.visible = true
                    ddown3.visible = true
                    ddown4.visible = true
                } else {
                    ddown2.visible = false
                    ddown3.visible = false
                    ddown4.visible = false
                }
            }
            isChecked: false
        },
        LabeledEntry {
            id: minWidthEntry

            label:  "min width: "
            defaultValue: "0"

            onTextUpdated: {
                ddown.minWidth = value
            }
        },
        LabeledEntry {
            id: maxWidthEntry

            label:  "max width: "
            defaultValue: "10000"

            onTextUpdated: {
                ddown.maxWidth = value
            }
        },
        LabeledEntry {
            id: minHeightEntry

            label:  "min height: "
            defaultValue: ddown.height

            onTextUpdated: {
                ddown.minHeight = value
            }
        },
	LabeledEntry {
            id: maxHeightEntry

            label:  "max height: "
            defaultValue: ddown.height

            onTextUpdated: {
                ddown.maxHeight = value
            }
        },
        LabeledEntry {
            id: titleText

            label: "title: "
            defaultValue: ddown.title

            onTextUpdated: {
                ddown.title = value;
            }
        },

        LabeledEntry {
            id: selectedIndexBox

            label: "selectedIndex: "
            defaultValue: ddown.selectedIndex

            onTextUpdated: {
                ddown.selectedIndex = value;
            }
        },

        CheckBoxEntry {
            id: showTitle

            label: "show title in menu"

            onCheckedChanged: {
                ddown.showTitleInMenu = showTitle.isChecked
            }
            isChecked: false
        }
    ]

    statusContent: [
        StatusEntry {
            id: triggeredBox

            label: "selectedItem:"
            value: "2"
        }
    ]

    description: "This page shows an drop down box. The controls to the left can be used to change the width, "
                 + "height and the title of the box to see how its elements adapt to the new properties. "
                 + "Choosing too small sizes will break the dropdown box."

    widget: Flickable {

        anchors.fill: parent
        contentHeight: height > ddown.height ? height : ddown.height
        contentWidth: width > ddown.width ? width : ddown.width

        clip: true

        DropDown {
            id: ddown

            anchors.centerIn: parent

            title: "DropDown"
            titleColor: "black"

            minWidth: 0
            maxWidth: 1000
            minHeight: 32

            model: [  qsTr( "First choice" ), qsTr( "Second choice" ), qsTr ( "Third choice" ) , qsTr ( "4th choice very long text that is too long and will be elided" ) ]
            payload: [ 1, 2, 3, 4 ]

            selectedIndex: 2

            iconRow: [
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "image://themedimage/icons/toolbar/dev-home"
                }
            ]

            onTriggered: {
                triggeredBox.value = index
            }
        }

        DropDown {
            id: ddown2

            visible: false
            anchors.bottom: parent.bottom
            anchors.left: parent.left

            replaceDropDownTitle: ddown.replaceDropDownTitle
            showTitleInMenu: ddown.showTitleInMenu

            title: ddown.title
            titleColor: ddown.titleColor

            minWidth: 250
            maxWidth: 500
            minHeight: 32

            model: ddown.model
            payload: ddown.payload

            iconRow: [
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "image://themedimage/icons/toolbar/dev-home"
                }
            ]

            onTriggered: {
                triggeredBox.value = index
            }
        }

        DropDown {
            id: ddown3

            visible: false
            anchors.top: parent.top
            anchors.right: parent.right

            replaceDropDownTitle: ddown.replaceDropDownTitle
            showTitleInMenu: ddown.showTitleInMenu

            title: ddown.title
            titleColor: ddown.titleColor

            minWidth: 250
            maxWidth: 500
            minHeight: 32

            model: ddown.model
            payload: ddown.payload

            iconRow: [
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "image://themedimage/icons/toolbar/dev-home"
                }
            ]

            onTriggered: {
                triggeredBox.value = index
            }
        }

        DropDown {
            id: ddown4

            visible: false
            anchors.top: parent.top
            anchors.left: parent.left

            replaceDropDownTitle: ddown.replaceDropDownTitle
            showTitleInMenu: ddown.showTitleInMenu

            title: ddown.title
            titleColor: ddown.titleColor

            model: ddown.model

            minWidth: 250
            maxWidth: 500
            minHeight: 32

            payload: ddown.payload

            iconRow: [
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "image://themedimage/icons/toolbar/dev-home"
                }
            ]

            onTriggered: {
                triggeredBox.value = index
            }
        }

    }

    TopItem {
        id: topItem
    }
}


