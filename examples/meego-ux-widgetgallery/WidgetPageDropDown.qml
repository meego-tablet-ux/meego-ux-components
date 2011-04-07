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
        LabeledEntry {
            id: widthEntry

            label:  "width: "
            defaultValue: "400"

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

            width: 400
//            minWidth: 400
//            maxWidth: 440

            model: [  "First choice", "Second choice", "Third choice" ]
            payload: [ 1, 2, 3 ]

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


