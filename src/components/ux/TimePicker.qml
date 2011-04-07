/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass TimePicker
  \title TimePicker
  \section1 TimePicker

  Offers controls to select time by hours and minutes. 12 and 24
  hours systems supported. If OK is clicked, the selected hours
  and minutes are stored and can be accessed through the properties.

  \section2  API properties
  \qmlproperty int hours
  \qmlcm currently selected hours.  This value is from 0-23, regardless of the value of hr24

  \qmlproperty int minutes
  \qmlcm currently selected minutes

  \qmlproperty string minutesPadded
  \qmlcm currently selected minutes with a 0 added at the beginning in case of 0 - 9 minutes

  \qmlproperty string time
  \qmlcm contains the current hours and minutes separated by a colon
         and followed by the content of the property ampm.  This property is
         only valid once a time has been picked

  \qmlproperty bool hr24
  \qmlcm set to true if 24 hour system should be used.  Default is false (12 hr am/pm)

  \qmlproperty int minutesIncrement
  \qmlcm sets the step width used to select minutes

  \section2  Private Properties
  \qmlproperty string ampm
  \qmlcm contains "AM", "PM" or nothing, depending on the current time system

  \section2  Signals
  \qmlnone

  \section2 Functions
  \qmlnone

  \section2  Example
  \qml
      //a button labeled with the selected time
      Button {
          id: timeButton

          text: timePicker.time

          TimePicker {
              id: timePicker

              hr24: true
          }

          onClicked: {
              timePicker.show()
          }
      }
  \endqml
*/

import Qt 4.7
import MeeGo.Components 0.1

ModalDialog {
    id: timePicker

    // the timePicker doesn't return a time. Access these properties to get the info you want
    property int hours: 0
    property int minutes: 0
    property string minutesPadded: ( minutes < 10 ? "0" : "" ) + minutes
    property string ampm: ""
    property string time: ""

    property bool hr24: false
    property int minutesIncrement: 1

    property bool oldToggleState: false


    aligneTitleCenter: true

    buttonWidth: tPicker.width / 2.5
    //buttonWidth: pickerContents.width / 2.5

    onShowCalled:  {
        oldToggleState = ampmToggle.on
        hours = hourSpinner.value
        minutes = minutesSpinner.value
    }

    // if ok button is clicked, store the selected time
    onAccepted:  {
        minutes = minutesSpinner.value
        if( !hr24 ) {
            ampm = " " + (ampmToggle.on ? ampmToggle.onLabel : ampmToggle.offLabel);
        }else {
            ampm = ""
        }
        hours = hourSpinner.value
	time = hours + ":" + minutesPadded + ampm;
	hours = hr24 ? hours : ((ampmToggle.on) ? ((hours==12)?0:hours):((hours<12)?(hours+12):hours))
    }

    // if cancel button is clicked, restore the old values
    onRejected: {
        hourSpinner.setValue( hours )
        minutesSpinner.setValue( minutes )
        ampmToggle.on = oldToggleState
        if( !hr24 ) {
            ampm = " " + (ampmToggle.on ? ampmToggle.onLabel : ampmToggle.offLabel);
        }else {
            ampm = ""
        }
    }

    //on a switch between the 12 and 24 hour systems, some special cases have to be caught
    onHr24Changed: {
        if( hr24 ){ //switched from 12 to 24 hour system
            hourSpinner.min = 0
            hourSpinner.count = 24
            if( !ampmToggle.on ) {
                if( hours < 12 ){
                    hours += 12
                }else{
                    hours = 0
                }
            }
        }else { //switched from 24 to 12 hour system
            hourSpinner.min = 1
            hourSpinner.count = 12
            if( hours > 12 ){
                hours -= 12
                ampmToggle.on = false
            }else if( hours == 0 ) {
                hours = 12
                ampmToggle.on = true
            }else {
                ampmToggle.on = true
            }
        }
        hourSpinner.setValue( hours )
    }

    height: tPicker.height + decorationHeight
    width: tPicker.width

    title: qsTr("Pick a time")

    content: Item {
        id: tPicker

        clip: true
        width: 300
        height:  spinnerBox.height + ( hr24 ? 0 : ampmToggleBox.height )
        anchors { top: parent.top; horizontalCenter: parent.horizontalCenter }

        Theme { id: theme }

        Item {
            id: spinnerBox

            anchors { top: parent.top; horizontalCenter: parent.horizontalCenter }
            height: 130
            width : tPicker.width

            Item {
                id: innerBox

                anchors.centerIn: parent
                height: spinnerBox.height
                width: spinnerBox.width - 20

                // spinner to select hours
                TimeSpinner {
                    id: hourSpinner

                    height: spinnerBox.height - anchors.bottomMargin - anchors.topMargin
                    incr: 1
                    pad: false
                    anchors { left: parent.left; right: parent.horizontalCenter; top: parent.top; bottom: parent.bottom;
                        leftMargin: 14; rightMargin: 14; topMargin: 14; bottomMargin: hr24 ? 14 : 0;
                    }
                } // hourSpinner

                // a colon between the spinners makes it look more like a time selector
                Item {
                    id: colonBox

                    height: spinnerBox.height
                    anchors.left: hourSpinner.right
                    anchors.right: minutesSpinner.left

                    Text {
                        id: colon

                        text: ":"
                        anchors.centerIn: parent
                        color: theme.fontColorNormal
                        font.pixelSize: theme.fontPixelSizeLargest3
                    }//colon
                }

                // spinner to select minutes
                TimeSpinner {
                    id: minutesSpinner

                    min: 0
                    incr: timePicker.minutesIncrement
                    count: 60 / incr
                    pad: true
                    anchors { left: parent.horizontalCenter; right: parent.right; top: parent.top; bottom: parent.bottom;
                        leftMargin: 14; rightMargin: 14; topMargin: 14; bottomMargin: hr24 ? 14 : 0;
                    }
                } // minutesSpinner
            } // innerBox
        } // spinnerBox

        // used to choose between AM or PM time, if 12 hour system is active
        Item {
            id: ampmToggleBox

            anchors.top: spinnerBox.bottom

            width: tPicker.width
            height: ampmToggle.height + 28

            ToggleButton {
                id: ampmToggle

                visible: !timePicker.hr24
                onLabel: qsTr("AM")
                offLabel: qsTr("PM")
                anchors.centerIn: parent

                onToggled: {
                    timePicker.ampm = ampmToggle.on ? ampmToggle.onLabel : ampmToggle.offLabel;
                }
            }// ampmToggle
        }// ampmToggleBox
    }// timePicker

    TopItem { id: topItem }
}

