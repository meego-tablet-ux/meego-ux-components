/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass ToggleButton
  \title ToggleButton
  \section1 ToggleButton

  This is a button which let's the user switch between two options. The
  button can be toggled by a single click or by swiping in the desired direction.

  \section2  API properties
      \qmlproperty alias onLabel
      \qmlcm points to the text of the left button label (on state)

      \qmlproperty alias offLabel
      \qmlcm points to the text of the right button label (off state)

      \qmlproperty bool on
      \qmlcm true if the button is currently set to the left option (on state)

      \qmlproperty alias labelColorOn
      \qmlcm points to the color of the left label (on state)

      \qmlproperty alias labelColorOff
      \qmlcm points to the color of the right label (off state)

  \section2  Private Properties

      \qmlproperty real width
      \qmlcm per default the width of the source image.

      \qmlproperty real height
      \qmlcm per default the height of the source image.

  \section2  Signals
      \qmlsignal toggled
      \qmlcm emitted if the button is toggled.
        \param bool isOn
        \qmlpcm indicates if the button was set to the left or right option. \endparam

  \section2 Functions
      \qmlfn  toggle
      \qmlcm switches the button from its current option to the other option and emits the toggled signal

  \section2  Example
  \qml
      ToggleButton {
          id: onOffToggle

          onLabel: qsTr("On")
          offLabel: qsTr("Off")
          anchors.centerIn: parent

          onToggled: {
              on ? console.log("Now I'm on") : console.log("Now I'm off")
          }
      }
  \endqml
*/

import Qt 4.7
import MeeGo.Components 0.1

Image {
    id: toggleSwitch

    property alias onLabel: elementLabelOn.text
    property alias offLabel: elementLabelOff.text
    property alias labelColorOn: elementLabelOn.color
    property alias labelColorOff: elementLabelOff.color
    property bool on: false
    signal toggled(bool isOn);

    function toggle() {
        toggleSwitch.on = !toggleSwitch.on
        toggleSwitch.toggled( toggleSwitch.on );
    }

    width: sourceSize.width
    height: sourceSize.height

    source: "image://themedimage/widgets/common/lightswitch/lightswitch-background"

    MouseArea {
        id: toggleElementArea

        //used to allow only one toggle for each swipe
        property bool active: true
        property int tempx: 0
        property int tempy: 0

        z: 5
        anchors.fill: parent

        onClicked: {
        }

        onPressed: {
            tempx = mouseX
            tempy = mouseY
        }

        onReleased: {
            if( active && Math.abs( tempx - mouseX ) < 10 && Math.abs( tempy - mouseY ) < 10 ){
                toggleSwitch.toggle()
            }
            active = true
        }

        onMousePositionChanged: {
            if( pressed && active ) {
                if( Math.abs( mouseY - tempy ) < Math.abs( mouseX - tempx ) ){
                    if( toggleSwitch.on ) {
                        if( tempx - mouseX > 20 ) {
                            active = false
                            toggleSwitch.toggle()
                        }
                    }else {
                        if( mouseX - tempx > 20 ) {
                            active = false
                            toggleSwitch.toggle()
                        }
                    }
                }
            }
        }
    }

    //left option label
    Text {
        id: elementLabelOn

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.15
        text: qsTr("On")
        visible: toggleSwitch.on
        color: theme.fontColorHighlightBlue
        font.pointSize: toggleElement.height < toggleElement.width ? toggleElement.height/3 : toggleElement.width/4
    }

    //right option label
    Text {
        id: elementLabelOff

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.15
        text: qsTr("Off")
        visible: !toggleSwitch.on
        color: theme.fontColorInactive
        font.pointSize: toggleElement.height < toggleElement.width ? toggleElement.height/3 : toggleElement.width/4
    }

    Image {
        id: toggleElement

        z: 0
        source: "image://themedimage/widgets/common/lightswitch/lightswitch-handle"
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        width:  height
        fillMode: Image.PreserveAspectCrop
        smooth:  true
    }

    Image {
        id: toggleElement2

        z: 1
        opacity:  1
        source: "image://themedimage/widgets/common/lightswitch/lightswitch-handle-disabled"
        anchors.centerIn: toggleElement
        height: parent.height
        width:  height
        fillMode: Image.PreserveAspectCrop
        smooth:  true
    }

    Theme { id: theme }

    states: [
        State {
            name: "on"
            PropertyChanges {
                target: toggleElement
                x: parent.width - width
            }
            PropertyChanges {
                target: toggleElement2
                opacity: 0
            }
            when: toggleSwitch.on == true
        },
        State {
            name: "off"
            PropertyChanges {
                target: toggleElement
                x: 0
            }
            PropertyChanges {
                target: toggleElement2
                opacity: 1
            }
            when: toggleSwitch.on == false
        }
    ]

    transitions: [
        Transition {
            NumberAnimation {
                properties: "x"
                duration: 200
                easing.type: Easing.InCubic
            }
            NumberAnimation {
                properties: "opacity"
                duration: 200
                easing.type: Easing.InCubic
            }
        }
    ]
} // end ToggleButton
