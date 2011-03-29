/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This pages shows the BottomToolBar.qml and offers controls to manipulate it.
 */
import Qt 4.7
import MeeGo.Components 0.1

WidgetPage {
    id: widgetPage

    property bool mute: false

    pageTitle: "BottomBar"

    controlContent: [
        CheckBoxEntry {
            id: showExampleRow
            isChecked: true
            label: "show Example Row:"
        },
        LabeledEntry {
            id: titleText

            label: "height: "
            defaultValue: bottomToolbar.height

            onTextUpdated: {
                bottomToolbar.height = value;
            }
        }
    ]

    statusContent: [
        StatusEntry {
            label: "shown:"
            value: bottomToolbar.visible
        }
    ]

    description: "This is a BottomToolBar with customizable content, value ranges and options to set the current value. \n"
               + "Note: the 'value' entry under API Properties is not linked to the current value property for demonstration reasons."

    widget: Flickable {

        anchors.fill: parent
        contentHeight: height > showBottomBar.height ? height : showBottomBar.height
        contentWidth: width > showBottomBar.width ? width : showBottomBar.width
        clip: true

        Button {
            id: showBottomBar

            anchors.centerIn: parent
            width: 400
            height: 60
            text: bottomToolbar.visible? qsTr( "Hide BottomToolBar" ) :qsTr( "Show BottomToolBar" )

            onClicked: {
                if( bottomToolbar.visible )
                    bottomToolbar.hide()
                else
                    bottomToolbar.show()
            }
        }

        BottomToolBar {
            id: bottomToolbar
            parent: widgetPage

            content: BottomToolBarRow {
                id: bottomToolbarRow
                visible: showExampleRow.isChecked

                leftContent: [
                    IconButton {
                        id: button1
                    },
                    IconButton {
                        id: button2
                    }
                ]

                centerContent: [
                    Slider {
                        id: slider
                        width: 250
                    }
                ]


                rightContent: [
                    IconButton {
                        id: button5
                    },
                    IconButton {
                        id: button6
                    }
                ]




            }

        }
    }


}
