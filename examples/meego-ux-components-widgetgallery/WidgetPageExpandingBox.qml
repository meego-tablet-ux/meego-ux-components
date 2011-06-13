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

    property bool lazyExpandingBoxCreation: false

    pageTitle: "Expanding Box"

    controlContent: [
        LabeledEntry {
            id: widthEntry

            label:  "width: "
            defaultValue: "400"

            onTextUpdated: {
                ebox1.width = value
                ebox1.buttonWidth = value
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

        Row {
            id:colBox

            spacing: 5

            Column{
                id:colBox2

                spacing: 2

                ExpandingBox {
                    id: ebox1
                    lazyCreation: widgetPage.lazyExpandingBoxCreation

                    height: 50
                    width: 400
                    titleText: "Expanding Box"
                    titleTextColor: "black"

                    iconRow: [
                        Image {
                            fillMode: Image.PreserveAspectFit
                            source: "image://themedimage/icons/toolbar/camera-photo"
                        }
                    ]

                    detailsComponent: demoComponent1

                    Component {
                        id: demoComponent1

                        Rectangle {

                            height: 50
                            color: "steelblue"
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
                    lazyCreation: widgetPage.lazyExpandingBoxCreation

                    width: widgetPage.width / 3
                    height: 50
                    titleTextColor: "black"

                    headerContent: Item {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.fill: parent

                        Column{
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left:  parent.left
                            anchors.leftMargin: 5
                            id: box
                            Text {
                                id: text
                                text: "Example"
                                font.pixelSize: 20
                            }
                            Text {
                                id: subtext
                                text: "for custom header"
                                font.pixelSize: 15

                            }
                        }
                        Image {
                            anchors.left: box.right
                            anchors.leftMargin: 5
                            anchors.verticalCenter: parent.verticalCenter
                            fillMode: Image.PreserveAspectFit
                            source: "image://themedimage/icons/toolbar/camera-photo"
                        }
                        Text {
                            id: text2
                            text: "24hrs"
                            font.pixelSize: 20
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                        }
                    }

                    detailsComponent: demoComponent2

                    Component {
                        id: demoComponent2

                        Rectangle {

                            height: 50
                            color: "lightblue"
                            width: parent.width

                            Text {
                                id: text2

                                text: "Demo Component2"
                            }
                        }
                    }
                }
            }

            ExpandingBox {
                id: ebox3
                lazyCreation: widgetPage.lazyExpandingBoxCreation

                width: 120
                height: 200
                titleTextColor: "black"
                orientation: "vertical"
                Button {
                    y: 2
                    x: 2
                    text: "Switch"
                    onClicked: {
                        if( ebox3.orientation == "horizontal" ){
                            ebox3.width = 120
                            ebox3.height = 200
                            ebox3.buttonWidth = 120
                            ebox3.buttonHeight = 200
                            ebox3.orientation = "vertical"
                        }
                        else{
                            ebox3.width = 200
                            ebox3.height = 75
                            ebox3.buttonWidth = 200
                            ebox3.buttonHeight = 75
                            ebox3.orientation = "horizontal"
                        }
                    }
                }

                headerContent: Item {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.fill: parent

                    Column{
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        id: box2
                        Text {
                            id: text3
                            text: "Example"
                            font.pixelSize: 20
                        }
                        Text {
                            id: subtext3
                            text: "vertical"
                            font.pixelSize: 15

                        }

                    }
                }

                detailsComponent: demoComponent3

                Component {
                    id: demoComponent3

                    Rectangle {

                        height: 150//parent.height
                        color: "lightblue"
                        width: 150

                        Text {
                            id: text2

                            text: "Click me"
                        }
                        Button {
                            anchors.top: text2.bottom
                            text: "Switch"
                            onClicked: {
                                if( ebox3.orientation == "horizontal" ){
                                    ebox3.width = 120
                                    ebox3.height = 200
                                    ebox3.buttonWidth = 120
                                    ebox3.buttonHeight = 200
                                    ebox3.orientation = "vertical"
                                }
                                else{
                                    ebox3.width = 200
                                    ebox3.height = 75
                                    ebox3.buttonWidth = 200
                                    ebox3.buttonHeight = 75
                                    ebox3.orientation = "horizontal"
                                }
                            }
                        }
                    }
                }
            }
        }// end row
    }

    TopItem {
        id: topItem
    }
}


