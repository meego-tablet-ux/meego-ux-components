/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass ModalDialog
  \title ModalDialog
  \section1 ModalDialog
  The ModalDialog component is the base component for message boxes and pickers.

  \section2 API Properties
    \qmlproperty item content
    \qmlcm the content can be added here

    \qmlproperty string title
    \qmlcm title of the message box

    \qmlproperty int buttonWidth
    \qmlcm width of buttons

    \qmlproperty int buttonHeight
    \qmlcm height of buttons

    \qmlproperty bool showCancelButton
    \qmlcm boolean to show/hide cancel button

    \qmlproperty bool showAcceptButton
    \qmlcm boolean to show/hide accept button

    \qmlproperty string cancelButtonText
    \qmlcm displayed button text for cancel button

    \qmlproperty string acceptButtonText
    \qmlcm displayed button text for accept button

    \qmlproperty string cancelButtonImage
    \qmlcm background image for cancel button

    \qmlproperty string cancelButtonImagePressed
    \qmlcm background image for pressed cancel button

    \qmlproperty string acceptButtonImage
    \qmlcm background image for accept button

    \qmlproperty string acceptButtonImagePressed
    \qmlcm background image for pressed accept button

    \qmlproperty int leftMargin
    \qmlcm left margin for the content

    \qmlproperty int rightMargin
    \qmlcm right margin for the content

    \qmlproperty int topMargin
    \qmlcm top margin for the content

    \qmlproperty int bottomMargin
    \qmlcm bottom margin for the content

    \qmlproperty int verticalOffset
    \qmlcm the vertical offset for centering the dialog. By default it centers in the content area, keeping the toolbar unobscured.

    \qmlproperty row buttonRow
    \qmlcm this property exposes the button row which holds the dialogs buttons.
           By setting both standard buttons invisible via showAcceptButton and
           showCancelButton you can add a custom row of buttons. Note that you have to
           call hide() and show() on your own then.

  \section2 Private Properties
    \qmlproperty int decorationHeight
    \qmlcm bound to the height of header and footer. decoration height plus the height
           of the added content is the dialogs total height.

  \section2 Signals
    \qmlnone

  \section2 Functions
    \qmlnone

  \section2 Example
  \qml
    AppPage {
       id: myPage

       // create ModalDialog:
       ModalDialog {
           id: myDialog

           title : qsTr("Are you sure?")
           buttonWidth: 200
           buttonHeight: 35
           showCancelButton: true
           showAcceptButton: true
           cancelButtonText: qsTr( "Yes" )
           acceptButtonText: qsTr( "No" )

           content: Rectangle {
               id: myContent
               width: 400
               height: 400
               color: "red"
           }

           // handle signals:
           onAccepted: {
               // do something
           }
           onRejected: {
               // do something
           }
       }
       // show on signal:
       Component.onCompleted: {
           myDialog.show()
       }
    }
   \endqml
*/

import Qt 4.7
import MeeGo.Components 0.1

ModalFog {
    id: modalDialogBox

    property alias showCancelButton: buttonCancel.visible
    property alias showAcceptButton: buttonAccept.visible

    property alias cancelButtonEnabled: buttonCancel.enabled
    property alias acceptButtonEnabled: buttonAccept.enabled

    property alias content: innerContentArea.children
    property alias buttonRow: footer.children

    property string cancelButtonText: "Cancel"
    property string acceptButtonText: "OK"

    property string title: ""
    property bool aligneTitleCenter: false

    property string cancelButtonImage: "image://themedimage/button/button"
    property string cancelButtonImagePressed: "image://themedimage/button/button-pressed"

    property string acceptButtonImage: "image://themedimage/button/button-default"
    property string acceptButtonImagePressed: "image://themedimage/button/button-default-pressed"

    property int leftMargin: 0
    property int rightMargin: 0
    property int topMargin: 0
    property int bottomMargin: 0

    property int buttonWidth: width / 3
    property int buttonHeight: 50

    property int decorationHeight: header.height + footer.height + topMargin + bottomMargin

    property int verticalOffset: topItem.topDecorationHeight

    width: 600
    height: 300

    fogClickable: false

    modalSurface: BorderImage {
        id: inner

        width: modalDialogBox.width
        height: modalDialogBox.height

        x: ( topItem.topWidth - modalDialogBox.width ) / 2
        y: ( topItem.topHeight - modalDialogBox.height + verticalOffset ) / 2

        border.left:   6
        border.top:    77
        border.bottom: 64
        border.right:  6

        source: "image://themedimage/modal-dialog/modal-dialog-background"

        clip: true

        MouseArea {
            id: blocker
            anchors.fill: parent
            z: -1
        }

        Text {
            id: header

            anchors.top: parent.top

            anchors.horizontalCenter: aligneTitleCenter ? parent.horizontalCenter : undefined
            anchors.left: aligneTitleCenter ? undefined : parent.left
            anchors.leftMargin: 20

            height: inner.border.top
            verticalAlignment: Text.AlignVCenter

            text: modalDialogBox.title
            font.weight: Font.Bold
            font.pixelSize: theme.dialogTitleFontPixelSize
            color: theme.dialogTitleFontColor
        }

        Item {
            id: innerContentArea

            clip: true

            anchors{
                left: parent.left;
                top: header.bottom;
                right: parent.right;
                bottom: footer.top;
                leftMargin: modalDialogBox.leftMargin
                rightMargin: modalDialogBox.rightMargin
                topMargin: modalDialogBox.topMargin
                bottomMargin: modalDialogBox.bottomMargin
            }
        }

        Button {
            id: defaultButtonCancel

            width: buttonWidth
            height: buttonHeight
            anchors.verticalCenter: footer.verticalCenter

            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr( cancelButtonText )

            visible: footer.width <=  footer.spacing + 2    // row size if all buttons are invisible and no custom ones set

            bgSourceUp: cancelButtonImage
            bgSourceDn: cancelButtonImagePressed

            onClicked: {
                modalDialogBox.rejected()
                modalDialogBox.hide()
            }
        }

        Row {
            id: footer

            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            height: inner.border.bottom
            spacing: 18
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true

            Button {
                id: buttonAccept

                width: visible ? modalDialogBox.buttonWidth : 1     // minimum width. Cannot be zero because button will choose its own width if zero
                height: buttonHeight
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr( acceptButtonText )

                bgSourceUp: acceptButtonImage
                bgSourceDn: acceptButtonImagePressed

                onClicked: {
                    modalDialogBox.accepted()
                    modalDialogBox.hide()
                }
            }

            Button {
                id: buttonCancel

                width: visible ? modalDialogBox.buttonWidth : 1
                height: buttonHeight
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr( cancelButtonText )

                bgSourceUp: cancelButtonImage
                bgSourceDn: cancelButtonImagePressed

                onClicked: {
                    modalDialogBox.rejected()
                    modalDialogBox.hide()
                }
            }
        }
    }

    Theme { id: theme }
    TopItem { id: topItem }
}
