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
                if( showCornerDropDowns.isChecked == true ) {
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
            id: widthEntry

            label:  "width: "
            defaultValue: "450"

            onTextUpdated: {
                ddown.width = value
            }
        },
        LabeledEntry {
            id: heightEntry

            label:  "height: "
            defaultValue: ddown.height

            onTextUpdated: {
                ddown.height = value
            }
        },
        LabeledEntry {
            id: titleText

            label: "titleText: "
            defaultValue: ddown.title

            onTextUpdated: {
                ddown.title = value;
            }
        },
        LabeledEntry {
            id: maxWidthEntry

            label:  "ContextMenu maxWidth: "
            defaultValue: ""

            onTextUpdated: {
                ddown.maxWidth = value
            }
        },
        LabeledEntry {
            id: minwidthEntry

            label:  "minWidth: "
            defaultValue: "0"

            onTextUpdated: {
                ddown.minWidth = value
            }
        },
        CheckBoxEntry {
            id: replaceTitleOnSel

            label: "change title"

            onCheckedChanged: {
                ddown.replaceDropDownTitle = replaceTitleOnSel.isChecked
            }
            isChecked: false
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
            value: "none"
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

            width: 450

            model: [  qsTr( "First choice" ), qsTr( "Second choice" ), qsTr ( "Third choice" ) , qsTr ( "4th choice very long text that is" ) ]
            payload: [ 1, 2, 3, 4 ]

            iconRow: [
                Image {
                    height: parent.height * 0.9
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "image://themedimage/images/camera/camera_lens_sm_up"
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

            width: ddown.width

            model: ddown.model
            payload: ddown.payload

            iconRow: [
                Image {
                    height: parent.height * 0.9
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "image://themedimage/images/camera/camera_lens_sm_up"
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

            width: ddown.width

            model: ddown.model
            payload: ddown.payload

            iconRow: [
                Image {
                    height: parent.height * 0.9
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "image://themedimage/images/camera/camera_lens_sm_up"
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

            width: ddown.width

            model: ddown.model
            payload: ddown.payload

            iconRow: [
                Image {
                    height: parent.height * 0.9
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "image://themedimage/images/camera/camera_lens_sm_up"
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


