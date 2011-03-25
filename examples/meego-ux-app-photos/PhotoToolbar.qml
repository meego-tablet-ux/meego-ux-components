/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
    \page PhotoToolbar
    \title  MeeGo-Ux-App-Photos - PhotoToolbar
    \qmlclass PhotoToolbar.qml
    \section1 PhotoToolbar.qml

    This component offers a toolbar with several buttons for navigation and
    manipulation. Depending on the current mode, different buttons are shown.

    A property stores the current mode and can be set from outside.
    \qml
    // View Modes:
    // 0 - single photo view toolbar
    // 1 - grid view toolbar
    // 2 - grid view toolbar with cancel multiple select
    property int mode:2
    \endqml

    A bunch of signals is used to propagate the activation of the controls.
    \qml
    signal play()
    signal prev()
    signal next()
    signal favorite()
    signal rotateLeft()
    signal rotateRight()
    signal cancel()
    signal deleteSelected()
    signal addToAlbum()
    \endqml

    A row of buttons for navigation. In mode 1 (the initial mode when the application
    is started and shows the PhotosView, only the playButton is shown which then usually
    tells the application to show the slideshow view. In mode 0 (the mode when in slideshow
    view) all three buttons are visible. The backButton and nextButton are used to go back
    and forth manually between a set of photos. The playButton now starts an automated
    slideshow which jumps from photo to photo at a set interval. The buttons only emit
    the correct signals, the final functionality is implemented in the files using the
    toolbar.
    \qml
    Row {
        id: mode01Buttons

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

        IconButton {
            id: backButton

            opacity: mode == 0 ? 1.0 : 0.0
            anchors.verticalCenter: parent.verticalCenter
            icon: "image://themedimage/media/icn_back_up"
            iconDown: "image://themedimage/media/icn_back_dn"
            onClicked: container.prev()
        }
        IconButton {
            id: playButton

            opacity: mode == 0 | mode == 1 ? 1.0 : 0.0
            anchors.verticalCenter: parent.verticalCenter
            icon: "image://themedimage/icn_play_up"
            iconDown: "image://themedimage/icn_play_dn"
            onClicked: container.play()
        }
        IconButton {
            id: nextButton

            opacity: mode == 0 ? 1.0 : 0.0
            anchors.verticalCenter: parent.verticalCenter
            icon: "image://themedimage/media/icn_forward_up"
            iconDown: "image://themedimage/media/icn_forward_dn"
            onClicked: container.next()
        }
    }
    \endqml

    Another button row which shows up when in mode 2 (the multiple selection mode).
    The trashButton is used to initialize the deletion of the selected photos, the
    addButton is used to add the selected photos to an album and the cancelButton
    leaves the multiple selection mode. The buttons only emit the correct signals,
    the final functionality is implemented in the files using the toolbar.
    \qml
    Row {
        id: mode2Buttons

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: container.height -10
        spacing: (width - 400)/3
        visible: mode == 2

        IconButton {
            id: trashButton

            anchors.verticalCenter: parent.verticalCenter
            icon: "image://themedimage/media/icn_trash_up"
            iconDown: "image://themedimage/media/icn_trash_dn"
            onClicked: container.deleteSelected()
        }
        IconButton {
            id: addButton

            anchors.verticalCenter: parent.verticalCenter
            icon: "image://themedimage/media/icn_addtoalbum_up"
            iconDown: "image://themedimage/media/icn_addtoalbum_dn"
            onClicked: container.addToAlbum()
        }

        IconButton {
            id: cancelButton

            icon: "image://themedimage/media/icn_cancel_ms_up"
            iconDown: "image://themedimage/media/icn_cancel_ms_dn"
            onClicked: container.cancel()
        }
    }
    \endqml

    The rotationButton is used to initialize the rotation of a photo.
    \qml
    IconButton {
        id: rotationButton

        opacity: mode == 0 ? 1.0 : 0.0
        anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 10 }
        icon: "image://themedimage/media/icn_rotate_cw_up"
        iconDown: "image://themedimage/media/icn_rotate_cw_dn"
        onClicked: container.rotateRight()
    }
    \endqml
*/

import Qt 4.7
import MeeGo.Components 0.1

Item {
    id: container

    // View Modes:
    // 0 - single photo view toolbar
    // 1 - grid view toolbar
    // 2 - grid view toolbar with cancel multiple select
    property int mode:2

    property bool isFavorite: true

    signal play()
    signal prev()
    signal next()
    signal favorite()
    signal rotateLeft()
    signal rotateRight()
    signal cancel()
    signal deleteSelected()
    signal addToAlbum()

    height: rotationButton.height

    BorderImage {
        id: backgroundImage

        anchors.fill: parent
        source: "image://themedimage/media/nextbox_landscape"
        border.top: 10
        border.bottom:10
        border.left: 10
        border.right: 10
    }

    Row {
        id: mode01Buttons

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: ( parent.width - 5 * 100 ) / 6   // 5 buttons should be possible, so substract 5 * IconButton.width divided by 5+1

        IconButton {
            id: backButton

            opacity: mode == 0 ? 1.0 : 0.0
            anchors.verticalCenter: parent.verticalCenter
            icon: "image://themedimage/media/icn_back_up"
            iconDown: "image://themedimage/media/icn_back_dn"

            width: 100

            onClicked: container.prev()
        }
        IconButton {
            id: playButton

            opacity: mode == 0 | mode == 1 ? 1.0 : 0.0
            anchors.verticalCenter: parent.verticalCenter
            icon: "image://themedimage/icn_play_up"
            iconDown: "image://themedimage/icn_play_dn"

            width: 100

            onClicked: container.play()
        }
        IconButton {
            id: nextButton

            opacity: mode == 0 ? 1.0 : 0.0
            anchors.verticalCenter: parent.verticalCenter
            icon: "image://themedimage/media/icn_forward_up"
            iconDown: "image://themedimage/media/icn_forward_dn"

            width: 100

            onClicked: container.next()
        }
    }
    Row {
        id: mode2Buttons

        anchors.horizontalCenter: parent.horizontalCenter
        height: container.height -10
        anchors.verticalCenter: parent.verticalCenter
        spacing: (parent.width - 3 * 100) / 4       // 3 buttons should be possible, so substract 3 * IconButton.width divided by 3+1
        visible: mode == 2

        IconButton {
            id: trashButton

            anchors.verticalCenter: parent.verticalCenter
            icon: "image://themedimage/media/icn_trash_up"
            iconDown: "image://themedimage/media/icn_trash_dn"

            width: 100

            onClicked: container.deleteSelected()
        }
        IconButton {
            id: addButton

            anchors.verticalCenter: parent.verticalCenter
            icon: "image://themedimage/media/icn_addtoalbum_up"
            iconDown: "image://themedimage/media/icn_addtoalbum_dn"

            width: 100

            onClicked: container.addToAlbum()
        }

        IconButton {
            id: cancelButton

            anchors.verticalCenter: parent.verticalCenter
            icon: "image://themedimage/media/icn_cancel_ms_up"
            iconDown: "image://themedimage/media/icn_cancel_ms_dn"

            width: 100

            onClicked: container.cancel()
        }
    }

    IconButton {
        id: rotationButton

        opacity: mode == 0 ? 1.0 : 0.0
        anchors { verticalCenter: parent.verticalCenter; left: parent.left; }
        anchors.leftMargin: ( parent.width - 500 ) / 6  // 5 buttons should be possible, so substract 5 * IconButton.width divided by 5+1
        icon: "image://themedimage/media/icn_rotate_cw_up"
        iconDown: "image://themedimage/media/icn_rotate_cw_dn"

        width: 100

        onClicked: container.rotateRight()
    }   

    states: [
        State {
            name: "multisel"
            when: mode == 2
        },
        State {
            name: "normal"
            when: mode != 2
        }
    ]

//    transitions: [
//        Transition {
//            from: "normal"
//            to: "multisel"
//            ScriptAction {
//                script: sharing.clearItems();
//            }
//        }
//    ]
}

