/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
   \qmlclass IconButton
   \title IconButton
   \section1 IconButton
   This is a button with a customizable text, font and text-color as well as released
   and pressed state images. Additionally icons for the pressed and released state
   can be set.

   \section2 API properties

      \qmlproperty string icon
      \qmlcm sets the icon displayed on the button.

      \qmlproperty string iconPressed
      \qmlcm sets the icon displayed on the pressed button.

      \qmlproperty bool iconFill
      \qmlcm determines wheather the icon should fill the button automatically

      \qmlproperty property alias iconFillMode: image.fillMode
      \qmlcm the fillMode of the Icon

      \qmlproperty bool hasBackground
      \qmlcm determines if the IconButton uses the properties bgSourceUp and bgSourceDown to
      render the Icon button. default is set to false. I set to true, the button will be painted
      as a button with

      \qmlproperty string bgSourceUp
      \qmlcm path to an image file used for released state.

      \qmlproperty string bgSourceDn
      \qmlcm path to an image file used for pressed state.

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
      IconButton {
         id: myButton

         icon: "myImage.png"
         iconPressed: "myImagePressed.png"
      }
  \endqml
*/

import Qt 4.7
import MeeGo.Components 0.1

Item {
    id: container

    property string icon: "image://themedimage/camera/camera_lens_sm_up"
    property string iconDown: "image://themedimage/camera/camera_lens_sm_dn"
    property bool iconFill: false
    property alias iconFillMode: image.fillMode

    property bool hasBackground: false
    property string bgSourceUp: "image://themedimage/btn_grey_up"
    property string bgSourceDn: "image://themedimage/btn_grey_dn"

    property bool active: true
    property bool pressed: false

    signal clicked( variant mouse )

    // lower the button's opacity to mark it inactive
    opacity: active ? 1.0 : 0.5

    width: image.sourceSize.width // 210
    height: image.sourceSize.height // 60
    clip: true

    Theme { id: theme }

    // iconsButtons Background Image    
    BorderImage {

        id: bgImage

        visible: hasBackground
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
                    target: bgImage
                    source: bgSourceDn
                }
            }
        ]
    }    

    Image {
        id: image

        anchors.centerIn: parent
        width: iconFill ? container.width : sourceSize.width //Math.min( sourceSize.width, container.width )
        height: iconFill ? container.height : sourceSize.height //Math.min( sourceSize.height, container.height )
        source: icon
        fillMode: Image.PreserveAspectFit

        // if the button didn't get width or height, set them so that they at least cover the icon
        Component.onCompleted: {
            if ( container.width == 0 )
                container.width = image.paintedWidth + 20;

            if ( container.height == 0 )
                container.height = image.paintedHeight + 20;
        }

        states: [
            State {
                name: "pressed"
                when: container.pressed
                PropertyChanges {
                    target: image
                    source: iconDown == "" ? icon : iconDown
                }
            }
        ]
    }

    MouseArea {
        id: mouseArea

        anchors.fill: hasBackground ? bgImage : image

        onClicked: {
            if (container.active) {
                container.clicked(mouse)
            }
        }
        onPressed: if (container.active) parent.pressed = true
        onReleased: if (container.active) parent.pressed = false
    }
}
