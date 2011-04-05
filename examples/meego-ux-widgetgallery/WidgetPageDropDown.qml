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
            defaultValue: ddown.titleText

            onTextUpdated: {
                ddown.titleText = value;
            }
        }
    ]

    statusContent: [
        StatusEntry {
            id: triggeredBox

            label: "selectedItem:"
            value: ddown.selectedIndex
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

            anchors.top: parent.top
            anchors.margins: 10
            anchors.verticalCenter: parent.verticalCenter

            width: 550
            height: 60

            titleText: "DropDown"
            titleTextColor: "black"

            model: [  "First choice", "Second choice", "Third choice" ]
            payload: [ 1, 2, 3 ]

            onTriggered: {

            }

        }
    }

    TopItem {
        id: topItem
    }
}


