/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass TextEntry
  \title TextEntry
  \section1 TextEntry
  \qmlcm The TextEntry is a text entry for single lines of text.
         It will turn scrollable if the text is too big for the text field.

  \section2 API Properties
  \qmlproperty alias text
  \qmlcm provides access to the text of the TextInput

  \qmlproperty alias textInput
  \qmlcm provides access to the TextInput

  \qmlproperty alias font
  \qmlcm provides access to the font of TextInput

  \qmlproperty alias readOnly
  \qmlcm sets the text of TextInput to read only. The text can not be altered if set to true.

  \qmlproperty alias inputMethodHints
  \qmlcm provides access to the inputMethodHints property of TextInput.
  
  \qmlproperty alias defaultText
  \qmlcm sets a defaultText in case the TextEntry is empty. the Text will be displayed as single line

  \section2 Signals
  \qmlsignal textChanged
  \qmlcm emitted when the text has changed

  \qmlsignal accepted
  \qmlcm emitted when an enter was pressed and the input is in an acceptable state

  \section2 Functions
  \qmlnone

  \section2 Example
  \qml
    TextEntry {
        id: textEntry

       text: "Type here."
   }
  \endqml
*/

import Qt 4.7
import MeeGo.Components 0.1

BorderImage {
    id: container

    property alias text: input.text
    property alias textInput: input
    property alias inputMethodHints: input.inputMethodHints
    property alias readOnly : input.readOnly
    property alias defaultText: fakeText.text
    property alias font: input.font

    signal textChanged
    signal accepted

    border.top: 6
    border.bottom: 6
    border.left: 6
    border.right: 6

    height: 50
    source: (input.focus && !readOnly) ? "image://themedimage/widgets/common/text-area/text-area-background-active" : "image://themedimage/widgets/common/text-area/text-area-background"

    opacity: readOnly ? 0.5 : 1.0

    Theme{ id: theme }
    
    TextInput {
        id: input

        x: 15
        y: 15
        width: parent.width - 30
        anchors.verticalCenter: parent.verticalCenter

        font.pixelSize: theme.fontPixelSizeLarge

        onTextChanged: {            
            if( text.length > 0 ) {
                container.textChanged()
            }
        }
        
        onAccepted: {
            container.accepted()
        }

        CCPContextArea {
            editor: parent
        }
    }

    Text {
        id: fakeText


        x: 15
        y: 15
        anchors.verticalCenter: parent.verticalCenter

        font: input.font
        color: "slategrey"

        visible: ( input.text == ""  && !input.focus ) || ( input.text == "" && input.readOnly )

        Connections {
            target: input
            onTextChanged: {
                fakeText.visible = (input.text == "")
            }
        }
    }
}
