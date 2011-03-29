/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass TextField
  \title TextField
  \section1 TextField
  \qmlcm The TextField is a text entry for multiple lines of text.
         It will turn scrollable if the text is too big for the text field.

  \section2 API Properties
  \qmlproperty string text
  \qmlcm the text fields text

  \qmlproperty alias font
  \qmlcm the texts font item

  \qmlproperty bool readOnly
  \qmlcm sets the text read only. The text can not be altered if set to true.

  \section2 Private Properties
  \qmlnone

  \section2 Signals
  \qmlsignal textChanged
  \qmlcm emitted when the text has changed

  \section2 Functions
  \qmlnone

  \section2 Example
  \qml
    TextField {
        id: textField

       text: "Type here."
   }
  \endqml
*/

import Qt 4.7
import MeeGo.Components 0.1

BorderImage {
    id: container

    property alias text: edit.text
    property alias font: edit.font
    property alias readOnly: edit.readOnly

    signal textChanged

    border.top: 6
    border.bottom: 6
    border.left: 6
    border.right: 6

    height: 50
    source: (edit.focus && !readOnly) ? "image://themedimage/text-area/text-area-background-active" : "image://themedimage/text-area/text-area-background"
    clip: true

    opacity: readOnly ? 0.5 : 1.0

    onHeightChanged: {
        if( flick.contentHeight <= flick.height ){
            flick.contentY = 0
        }
        else if( flick.contentY + flick.height > flick.contentHeight ){
            flick.contentY = flick.contentHeight - flick.height
        }
    }

    Theme { id: theme }

    Flickable {
        id: flick

        function ensureVisible(r) {
            if (contentX >= r.x){
                contentX = r.x
            }
            else if (contentX+width <= r.x+r.width) {
                contentX = r.x+r.width-width
            }
            if (contentY >= r.y){
                contentY = r.y
            }
            else if (contentY+height <= r.y+r.height) {
                contentY = r.y+r.height-height
            }
        }


        anchors.fill: parent
        anchors.margins: 4      // this value is the hardcoded margin to keep the text within the backgrounds text field
        contentWidth: edit.paintedWidth
        contentHeight: edit.paintedHeight

        flickableDirection: Flickable.VerticalFlick
        interactive: ( contentHeight > flick.height ) ? true : false

        clip: true

        TextEdit {
            id: edit

            width: flick.width
            height: flick.height
            focus: false
            wrapMode: TextEdit.Wrap
            onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
            font.pixelSize: theme.fontPixelSizeNormal
        }
    }
}
