/*
* Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
\qmlclass DropDown
  \title DropDown
  \section1 DropDown
  This is a box which can be given any content and adapts its size accordingly.
  The default state of the box only show a header line and an icon which
  indicates if the box is expanded or not. Clicking on the header expands the
  box and shows the content.

  The behaviour isn't final because detailed specifications are missing.

  \section2 API properties
  \qmlproperty bool expanded
  \qmlcm true if the box is currently expanded

  \qmlproperty alias iconContent
  \qmlcm area to put a row of icons

  \qmlproperty string titleText
  \qmlcm sets the text shown on the header

  \qmlproperty string titleTextColor
  \qmlcm sets the color of the text shown on the header

  \qmlproperty component detailsComponent
  \qmlcm contains the content to be created

  \qmlproperty item detailsItem
  \qmlcm stores the contents when created

  \section2  Private properties
  \qmlnone

  \section2 Signals
  \qmlsignal expandingChanged
  \qmlcm emitted if the box switches between expanded and not expanded
        \param bool expanded
        \qmlpcm indicates if the box is expanded or not \endparam

  \section2 Functions
  \qmlnone

  \section2 Example
  \qml
      DropDown {
          id: DropDown

          width: 200
          titleText: "DropDown"
          titleTextColor: "black"
          anchors.centerIn:  parent


      }
  \endqml
*/

import Qt 4.7
import MeeGo.Components 0.1

Item {  
    id: dropDown

    property bool opened: false
    property alias title: titleText.text
    property alias titleColor: titleText.color    
    property alias iconRow: iconArea.children

    property alias model: actionMenu.model
    property alias payload: actionMenu.payload
    property alias minWidth: actionMenu.minWidth
    property alias maxWidth: actionMenu.maxWidth
    property alias currentWidth: actionMenu.currentWidth

    property bool replaceTitleOnSelection: false

    signal triggered( int index )
    signal expandingChanged( bool expanded )


    width: parent.width
    height: 20 + ( ( titleText.font.pixelSize > expandButton.height ) ? titleText.font.pixelSize : expandButton.height ) //pulldownImage.height

    // the border image is the background graphic for the header and the content
    BorderImage {
        id: pulldownImage

        property int borderSize: 5

        height: header.height
        width: parent.width
        border.top: borderSize
        border.bottom: borderSize
        border.right: 0
        border.left: 0
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
        source: dropDown.opened ? "image://theme/images/pulldown_box" : "image://theme/images/pulldown_box"

        // the header item contains the title, the image for the button which indicates
        // the expanded state and a MouseArea to change the expanded state on click
        Item {
            id: header

            // the header adapts its height to the height of the title and the button plus some space
            height: dropDown.height //20 + ( ( titleText.font.pixelSize > expandButton.height ) ? titleText.font.pixelSize : expandButton.height )
            width: parent.width
            anchors.top:  parent.top

            Row {
                id: iconArea

                anchors { left: parent.left; top: parent.top; bottom: parent.bottom; margins: 5; }
                spacing: anchors.margins
            }

            Text {
                id: titleText

                font.pixelSize: 20 //theme_fontPixelSizeLargest      //THEME
                color: "grey" //theme_fontColorHighlight         //THEME
                elide: Text.ElideRight
                anchors.left: iconArea.right
                anchors.right: expandButton.left
                anchors.leftMargin: 5
                anchors.verticalCenter: expandButton.verticalCenter
            }

            Image {
                id: expandButton

                anchors.right: parent.right
                anchors.rightMargin: 6
                anchors.verticalCenter: parent.verticalCenter
                source:dropDown.opened ? "image://theme/images/settings/pulldown_arrow_up" : "image://theme/images/settings/pulldown_arrow_dn"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    opened = !opened;
                    if( opened ) {
                        contextMenu.setPosition(
                            mapToItem( topItem.topItem, mouseX, mouseY ).x,
                            mapToItem( topItem.topItem, mouseX, mouseY ).y  )
                        contextMenu.show()
                    } else {
                        contextMenu.hide()
                    }
                }
            }
        }

        ModalContextMenu {

            id: contextMenu

            forceFingerMode: -1

            content: ActionMenu {
                id: actionMenu
                onTriggered: {
                    dropDown.triggered( index )
                    dropDown.opened = false                    
                    contextMenu.hide()

                    if( dropDown.replaceTitleOnSelection )
                        dropDown.title = model[index]
                }
            }

            onFogHideFinished: {
                dropDown.opened = false
            }
        }    
    }
}
