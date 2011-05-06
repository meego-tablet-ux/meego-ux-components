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

    pageTitle: "Expanding Box"

    controlContent: [
        LabeledEntry {
            id: widthEntry

            label:  "width: "
            defaultValue: "400"

            onTextUpdated: {
                ebox1.width = value
            }
        },
        LabeledEntry {
            id: heightEntry

            label:  "height: "
            defaultValue: ebox1.height

            onTextUpdated: {
                ebox1.height = value
                ebox1.buttonHeight = value
            }
        },
        LabeledEntry {
            id: titleText

            label: "titleText: "
            defaultValue: ebox1.titleText

            onTextUpdated: {
                ebox1.titleText = value;
            }
        }
    ]

    description: "This page shows an expanding box. The controls to the left can be used to change the width, "
                 + "height and the title of the box to see how its elements adapt to the new properties. "
                 + "Choosing too small sizes will break the expanding box."

    widget: Flickable {

        anchors.fill: parent
        contentHeight: height > colBox.height ? height : colBox.height
        contentWidth: width > colBox.width ? width : colBox.width
        clip: true

        Column{
            id:colBox
            anchors.centerIn: parent

        ExpandingBox {
            id: ebox1

            height: 0
            width: 400
            titleText: "Expanding Box"
            titleTextColor: "black"

            iconRow: [
                Image {
                    height: parent.height * 0.9
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "image://theme/camera/camera_lens_sm_up"
                }
            ]

            detailsComponent: demoComponent1

            Component {
                id: demoComponent1

                Rectangle {

                    height: 50
                    color: "blue"
                    width: parent.width

                    Text {
                        id: text1

                        text: "Demo Component1"
                    }
                }
            }
        }

        ExpandingBox {
            id: ebox2

            width: 400
            height: 50
            titleText: "Dummy Box"
            titleTextColor: "black"

            iconRow: [
                Image {
                    height: parent.height * 0.9
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "image://theme/camera/camera_lens_sm_up"
                }
            ]

            detailsComponent: demoComponent1

            Component {
                id: demoComponent2

                Rectangle {

                    height: 50
                    color: "blue"
                    width: parent.width

                    Text {
                        id: text2

                        text: "Demo Component1"
                    }
                }
            }
        }}
    }

    TopItem {
        id: topItem
    }
}


