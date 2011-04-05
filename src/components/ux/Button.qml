/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
   \qmlclass Button
   \title Button
   \section1 Button
   This is a button with a customizable text, font and text-color as well as released
   and pressed state images.

   \section2 API properties

      \qmlproperty string text
      \qmlcm sets the text displayed on the button.

      \qmlproperty alias font
      \qmlcm pointing to the button's font.

      \qmlproperty string textColor
      \qmlcm sets the color of the button's text.

      \qmlproperty string bgSourceUp
      \qmlcm path to an image file used for released state.

      \qmlproperty string bgSourceDn
      \qmlcm path to an image file used for pressed state.

      \qmlproperty bool elideText
      \qmlcm activates text eliding on true.  If this property is true, the width property must be explicitly set.

      \qmlproperty bool active
      \qmlcm stores if the button is clickable.

  \section2 Private properties

      \qmlfn bool pressed
      \qmlcm stores if the button is currently pressed.

  \section2 Signals

      \qmlsignal clicked
      \qmlcm emitted if the button is active and clicked.
        \param variant mouse
        \qmlpcm contains mouse event data. \endparam

  \section2 Functions
  \qmlnone

  \section2 Example
  \qml
      Button {
         id: myButton

         text: "Click me"
      }
  \endqml
*/

import Qt 4.7

Item {
    id: container

    property alias text: buttonText.text
    property alias font: buttonText.font
    property string bgSourceUp: "image://theme/widgets/common/button/button"
    property string bgSourceDn: "image://theme/widgets/common/button/button-pressed"
    property string bgSourceActive: "image://theme/widgets/common/button/button-default"
    property bool elideText: false
    property bool active: false
    property bool pressed: false
    property string textColor: theme.buttonFontColor
    signal clicked( variant mouse )

    // lower the button's opacity to mark it inactive
    opacity: enabled ? 1.0 : 0.5

    width:  if (!elideText) { buttonText.paintedWidth + 20 }
    height: buttonText.paintedHeight + 20
    clip:   true

    onActiveChanged: {
        if(active){
            icon.source = bgSourceActive
        }
        else{
            icon.source = bgSourceUp
        }

    }

    Theme { id: theme }

    // the button's image
    BorderImage {
        id: icon

        border.bottom: 10
        border.top: 10
        border.left: 10
        border.right: 10
        source: bgSourceUp
        anchors.fill: parent

        states: [
            State {
                name: "pressed"
                when: container.pressed
                PropertyChanges {
                    target: icon
                    source: bgSourceDn
                }
            }
        ]
    }

    // the button's text
    Text {
        id: buttonText

        width: if (elideText) { parent.width - 20 }
        anchors.centerIn: parent
        clip: true
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        elide: if( elideText ) { Text.ElideRight } else { Text.ElideNone }
        font.pixelSize: theme.fontPixelSizeLargest
        color: parent.textColor
    }

    // mouse area of the button surface
    MouseArea {
        id: mouseArea

        anchors.fill: parent

        onClicked: {
            container.pressed = false
            container.clicked(mouse)
            if(active){
                icon.source = bgSourceActive
            }
            else{
                icon.source = bgSourceUp
            }
        }

        onPressed: {
            icon.source = bgSourceDn
            container.pressed = true
        }

        onReleased: {
            container.pressed = false
            if(active){
                icon.source = bgSourceActive
            }
            else{
                icon.source = bgSourceUp
            }
        }
    }

} // end of button
