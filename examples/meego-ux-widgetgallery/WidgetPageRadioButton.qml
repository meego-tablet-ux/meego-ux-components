/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This pages shows the RadioButton.qml and RadioButtonGroup.qml and offers controls to manipulate them.
 */

import Qt 4.7
import MeeGo.Components 0.1

WidgetPage {
    id: widgetPage

    property int buttonSize: 28
    property string buttonText: "Choice"

    pageTitle: "RadioButton"

    controlContent: [
        LabeledEntry {
            id: widthEntry

            label:  "height: "
            defaultValue: "28"

            onTextUpdated: {
                if( parseInt( value ) > 0 ){
                    buttonSize = parseInt( value )
                }
            }
        },

        LabeledEntry {
            id: textEntry

            label:  "text: "
            defaultValue: buttonText

            onTextUpdated: {
                buttonText =  value
            }
        }
    ]

    statusContent: [
        StatusEntry {
            id: statusEntry

            label: "Active RadioButton:"
            value: radioGroup.selectedValue
        }
    ]

    description: "The RadioButton and the RadioButtonGroup provide the logic for radio buttons. "
               + "Buttons have to be given a unique value and have to be added to a RadioButtonGoup. "
               + "The group will then manage the single buttons and know the selected value."
               + "The buttons label can be set. For demonstration the index is added to the text."

    RadioGroup { id: radioGroup }

    widget: Flickable {

        anchors.fill: parent
        contentHeight: height > radioBox.height ? height : radioBox.height
        contentWidth: width > radioBox.width ? width : radioBox.width
        clip: true

        Column {
            id: radioBox

            anchors.centerIn: parent

            Repeater {
                id: radioRepeater

                model: 3

                RadioButton {
                    id: button

                    height: buttonSize

                    group: radioGroup
                    value: index

                    text: buttonText  + " " + index

                    Component.onCompleted: {

                        radioGroup.add( button )
                        radioGroup.select(0)
                    }
                }
            }
        }
    }
}
