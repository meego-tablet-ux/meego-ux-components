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
      \qmlcm points to the text of the left button label (on state). If onLabel is
             either to long or empty, an icon will be displayed instead of onLabel
             as well as offLabel.

      \qmlproperty alias offLabel
      \qmlcm points to the text of the right button label (off state). If offLabel is
             either to long or empty, an icon will be displayed instead of offLabel
             as well as onLabel.

      \qmlproperty bool on
      \qmlcm true if the button is currently set to the left option (on state)

      \qmlproperty bool enabled
      \qmlcm if false, the toggleButton can't be clicked and uses dimmed graphics.

      \qmlproperty alias labelColorOn
      \qmlcm points to the color of the left label (on state)

      \qmlproperty alias labelColorOff
      \qmlcm points to the color of the right label (off state)

  \section2  Signals
      \qmlproperty [signal] toggled
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
    id: toggleButton

    property alias onLabel: elementLabelOn.text
    property alias offLabel: elementLabelOff.text
    property alias labelColorOn: elementLabelOn.color
    property alias labelColorOff: elementLabelOff.color
    property bool enabled: true
    property bool on: false

    signal toggled(bool isOn);

    function toggle() {
        toggleButton.on = !toggleButton.on
        toggleButton.toggled( toggleButton.on );
    }

    width: sourceSize.width
    height: sourceSize.height

    source: ( enabled ) ? "image://themedimage/widgets/common/lightswitch/lightswitch-background" : "image://themedimage/widgets/common/lightswitch/lightswitch-background-disabled"

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
            if( active && Math.abs( tempx - mouseX ) < 10 && Math.abs( tempy - mouseY ) < 10 && toggleButton.enabled){
                toggleButton.toggle()
            }
            active = true
        }

        onMousePositionChanged: {
            if( pressed && active && toggleButton.enabled ) {
                if( Math.abs( mouseY - tempy ) < Math.abs( mouseX - tempx ) ){
                    if( toggleButton.on ) {
                        if( tempx - mouseX > 20 ) {
                            active = false
                            toggleButton.toggle()
                        }
                    }else {
                        if( mouseX - tempx > 20 ) {
                            active = false
                            toggleButton.toggle()
                        }
                    }
                }
            }
        }
    }

    Item {
        id: itemOn

        property bool showIcons: ( elementLabelOn.paintedWidth > width * 0.8 || elementLabelOn.paintedWidth < 1
                                || elementLabelOff.paintedWidth > width * 0.8 || elementLabelOff.paintedWidth < 1 ) ? true : false

        anchors.left: parent.left
        anchors.right: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        Text {
            id: elementLabelOn

            anchors.centerIn: parent
            text: qsTr("On")
            color:  theme.fontColorSelected
            visible: !itemOn.showIcons
            font.pointSize: toggleElement.height < toggleElement.width ? toggleElement.height/3 : toggleElement.width/4
        }

        Image {
            id: imageOn

            source: "image://themedimage/widgets/common/lightswitch/lightswitch-default-on"
            anchors.centerIn: parent
            visible: itemOn.showIcons
        }
    }

    Item {
        id: itemOff

        anchors.left: parent.horizontalCenter
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        Text {
            id: elementLabelOff

            anchors.centerIn: parent
            text: qsTr("Off")
            color: theme.fontColorSelected
            visible: !itemOn.showIcons
            font.pointSize: toggleElement.height < toggleElement.width ? toggleElement.height/3 : toggleElement.width/4
        }

        Image {
            id: imageOff

            source: "image://themedimage/widgets/common/lightswitch/lightswitch-default-off"
            anchors.centerIn: parent
            visible: itemOn.showIcons
        }
    }

    Image {
        id: toggleElement

        z: 1
        source: ( toggleButton.enabled ) ? "image://themedimage/widgets/common/lightswitch/lightswitch-handle" : "image://themedimage/widgets/common/lightswitch/lightswitch-handle-disabled"
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        fillMode: Image.PreserveAspectCrop
        smooth:  true
    }

    Theme { id: theme }

    states: [
        State {
            name: "on"
            PropertyChanges {
                target: toggleElement
                x: parent.width - toggleElement.width
            }
            when: toggleButton.on == true
        },
        State {
            name: "off"
            PropertyChanges {
                target: toggleElement
                x: 0
            }
            when: toggleButton.on == false
        }
    ]

    transitions: [
        Transition {
            NumberAnimation {
                properties: "x"
                duration: 200
                easing.type: Easing.InCubic
            }
        }
    ]
} // end ToggleButton
