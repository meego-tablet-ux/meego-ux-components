/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This pages opens the ModalMessageBox.qml and offers controls to manipulate it.
 */

import Qt 4.7
import MeeGo.Components 0.1

WidgetPage {
    id: widgetPage

    property string lastSignal: "none"

    pageTitle: "ModalMessageBox Testing"

    controlContent: [
        LabeledEntry {
            id: widthEntry

            label:  "width: "
            defaultValue: messageBox.width

            onTextUpdated: {
                if( value >= 0 ){
                    messageBox.width = value
                }
            }
        },

        LabeledEntry {
            id: heightEntry

            label:  "height: "
            defaultValue: messageBox.height

            onTextUpdated: {
                if( value >= 0 ){
                    messageBox.height = value
                }
            }
        },

        LabeledEntry {
            id: titleEntry

            label:  "title: "
            defaultValue: messageBox.title

            onTextUpdated: {
                messageBox.title = value
            }
        },

        LabeledEntry {
            id: textEntry2

            label:  "text: "
            defaultValue: messageBox.text

            onTextUpdated: {
                messageBox.text = value
            }
        },

        CheckBoxEntry {
            id: elideBoxAccept

            isChecked: true
            label: "showAcceptButton:"
        },

        CheckBoxEntry {
            id: elideBoxCancel

            isChecked: true
            label: "showCancelButton:"
        },

        CheckBoxEntry {
            id: elideBoxfog

            isChecked: false
            label: "fogClickable"
        }
    ]

    statusContent: [
        StatusEntry {
            id: outputEntry

            label: "Last signal sent:"
            value: lastSignal
        }
    ]

    description: "The ModalMessageBox is a ModalDialog used as a message box by simply setting a 'Text' element as content. <br>"
               + "The buttons can be hidden and fog clicks can be blocked. "
               + "Note that the dialog can't be closed if all means of input are disabled.<br><br>"
               + "fogClickable: sets if the dialog can be closed by clicking into the background<br><br>"
               + "The text can be formatted as you like, but the demo entry field does not allow it."

    widget: Button {
        id: button

        anchors.centerIn: parent
        width:  300
        height:  80
        text: "Show Message Box"

        onClicked: {
            messageBox.show()
        }
    }

    ModalMessageBox {
        id: messageBox

        text: "Any kind of message can be displayed here. More text. Click ok or cancel. \n"
            + "The text can be formatted as you like, but the demo entry field does not allow it."

        title: "Example Message Box"

        showAcceptButton: elideBoxAccept.isChecked
        showCancelButton: elideBoxCancel.isChecked

        fogClickable: elideBoxfog.isChecked

        onAccepted: lastSignal = "accepted()"
        onRejected: lastSignal = "rejected()"
    }
}
