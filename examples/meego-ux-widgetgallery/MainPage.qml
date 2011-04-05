/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* The MainPage lets the user switch between different contents which
   show the widgets available in these components. */

import Qt 4.7
import MeeGo.Components 0.1

AppPage {
    id: mainPage

    state: "setters"

    pageTitle: "Book 1, widget gallery"

    actionMenuModel: [ "Landscape", "Potrait", "Inv. Landscape", "Inv. Potrait" ]
    actionMenuPayload: [  1, 2, 3, 4 ]
    actionMenuTitle: "Action Menu"

    onActionMenuTriggered: {

        if( selectedItem == 1) {
            window.orientation = 1
        } else if( selectedItem == 2) {
            window.orientation = 2
        } else if( selectedItem == 3) {
            window.orientation = 3
        } else if( selectedItem == 4) {
            window.orientation = 0
        }
    }

    Item {
        id: contentButtons

        property int buttonWidth: parent.width * 0.2 //200
        property int buttonHeight: 60
        property int buttonMargins: 2

        property string activeButtonImage: "image://theme/widgets/common/button/button-default"
        property string buttonImage: "image://theme/widgets/common/button/button"
        property string buttonImagePressed: "image://theme/widgets/common/button/button-default-pressed"

        width: 3 * buttonWidth + 4 * buttonMargins
        height: buttonHeight
        anchors.top: parent.top
        anchors.topMargin:  10
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            id: buttonsButton

            width:  parent.buttonWidth; height: parent.buttonHeight
            anchors { margins: parent.buttonMargins; right: settersButton.left }
            text: "Buttons"

//            bgSourceUp: (mainPage.state == "buttons") ? contentButtons.activeButtonImage : contentButtons.buttonImage
//            bgSourceDn: contentButtons.buttonImagePressed
//            active: (mainPage.state == "buttons")

            onClicked: {
                mainPage.state = "buttons"
                active = true
                settersButton.active = false
                pickersButton.active = false
            }
        }

        Button {
            id: settersButton

            width:  parent.buttonWidth; height: parent.buttonHeight
            anchors { margins: parent.buttonMargins; horizontalCenter: parent.horizontalCenter }

            text: "Widgets"

            active: true

//            bgSourceUp: (mainPage.state == "setters") ? contentButtons.activeButtonImage : contentButtons.buttonImage
//            bgSourceDn: contentButtons.buttonImagePressed
//            active: (mainPage.state == "setters")

            onClicked: {
                mainPage.state = "setters"
                active = true
                pickersButton.active = false
                buttonsButton.active = false
            }
        }

        Button {
            id: pickersButton

            width:  parent.buttonWidth; height: parent.buttonHeight
            anchors { margins: parent.buttonMargins; left: settersButton.right }
            text: "Dialogs"

//            bgSourceUp: (mainPage.state == "pickers") ? contentButtons.activeButtonImage : contentButtons.buttonImage
//            bgSourceDn: contentButtons.buttonImagePressed
//            active: (mainPage.state == "pickers")

            onClicked: {
                mainPage.state = "pickers"
                active = true
                settersButton.active = false
                buttonsButton.active = false
            }
        }
    }

    Item {
        id: contentSpace

        anchors { top: contentButtons.bottom; bottom: parent.bottom; left: parent.left; right: parent.right }
    }

    ButtonContent { id: buttonContent; anchors.fill: contentSpace }
    SettersContent { id: settersContent; anchors.fill: contentSpace }
    PickerContent { id: pickerContent; anchors.fill:  contentSpace }

    Rectangle { z: -1; anchors.fill: parent; color: "grey" } //background

    states:  [
        State {
            name: "buttons"
            PropertyChanges { target: buttonContent; visible: true }
            PropertyChanges { target: settersContent; visible: false }
            PropertyChanges { target: pickerContent; visible: false }            
        },
        State {
            name: "setters"
            PropertyChanges { target: buttonContent; visible: false }
            PropertyChanges { target: settersContent; visible: true }
            PropertyChanges { target: pickerContent; visible: false }        
        },
        State {
            name: "pickers"
            PropertyChanges { target: buttonContent; visible: false }
            PropertyChanges { target: settersContent; visible: false }
            PropertyChanges { target: pickerContent; visible: true }         
        }

    ]
}
