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
  \qmlproperty bool opened
  \qmlcm true if the dropdown is currently opened

  \qmlproperty string title
  \qmlcm sets the text shown on the header

  \qmlproperty string titleColor
  \qmlcm sets the color of the text shown on the header

  \qmlproperty bool replaceDropDownTitle
  \qmlcm on true the title of the DropDown box will be replaced to the selectedItem

  \qmlproperty bool showTitleInMenu
  \qmlcm on true the title of the DropDown box will be shown in the ActionMenu

  \qmlproperty alias model
  \qmlcm contains the model of the ActionMenu

  \qmlproperty alias payload
  \qmlcm contains the payload of the ActionMenu

  \qmlproperty alias iconRow
  \qmlcm area to put a row of icons

  \qmlproperty int minWidth
  \qmlcm  int, the minimum width of the ActionMenu.

  \qmlproperty int maxWidth
  \qmlcm  int, the maximum width of the ActionMenu. Text that exceeds the maximum width will be elided.

  \qmlproperty string selectedTitle
  \qmlcm the currently selected title

  \qmlproperty int selectedIndex
  \qmlcm the currently selected index

  \section2  Private properties
  \qmlnone

  \section2 Signals
  \qmlsignal expandingChanged
  \qmlcm emitted if the box switches between expanded and not expanded
        \param bool expanded
        \qmlpcm indicates if the box is expanded or not \endparam

  \qmlfn triggered
  \qmlcm returns the index of the clicked entry.
        \param int parameter
        \qmlpcm index of the currentItem. \endparam

  \section2 Functions
  \qmlnone

  \section2 Example
  \qml
      DropDown {
            id: ddown

            anchors.centerIn: parent

            title: "DropDown"
            titleColor: "black"

            width: 400
            minWidth: 400
            maxWidth: 440

            model: [  "First choice", "Second choice", "Third choice" ]
            payload: [ 1, 2, 3 ]

            iconRow: [
                Image {
                    height: parent.height * 0.9
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "image://themedimage/images/camera/camera_lens_sm_up"
                }
            ]

            onTriggered: {

            }

        }
  \endqml
*/

import Qt 4.7
import MeeGo.Components 0.1

Item {  
    id: dropDown

    property bool opened: false    
    property alias titleColor: titleText.color    
    property alias iconRow: iconArea.children    
    property alias model: actionMenu.model
    property alias payload: actionMenu.payload
    property alias minWidth: actionMenu.minWidth
    property alias maxWidth: actionMenu.maxWidth
    property alias currentWidth: actionMenu.currentWidth

    property bool replaceDropDownTitle: false
    property bool showTitleInMenu: false

    property string title: undefined
    property string selectedTitle: undefined
    property int selectedIndex: undefied
    signal triggered( int index )
    signal expandingChanged( bool expanded )

    property bool engouhSpaceLeft: mapToItem( topItem.topItem, dropDown.x + dropDown.width, dropDown.y ).x > actionMenu.width

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
        source: dropDown.opened ? "image://themedimage/images/pulldown_box" :
                                  "image://themedimage/images/pulldown_box"

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

                font.pixelSize: theme.fontPixelSizeLarge
                color: theme.fontColorHighlight
                elide: Text.ElideRight
                anchors.left: iconArea.right
                anchors.right: expandButton.left
                anchors.leftMargin: 5
                anchors.verticalCenter: expandButton.verticalCenter
                text: replaceDropDownTitle ? selectedTitle : title
            }

            Image {
                id: expandButton

                anchors.right: parent.right
                anchors.rightMargin: 6
                anchors.verticalCenter: parent.verticalCenter
                source:dropDown.opened ? "image://themedimage/images/settings/pulldown_arrow_up" :
                                         "image://themedimage/images/settings/pulldown_arrow_dn"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    opened = !opened;
                    if( opened ) {
                        contextMenu.setPosition(
                            mapToItem( topItem.topItem, expandButton.x + expandButton.width / 2, 0 ).x,
                            mapToItem( topItem.topItem, 0, expandButton.y + expandButton.height / 2 ).y  )
                        contextMenu.show()
                    } else {
                        contextMenu.hide()
                    }
                    expandingChanged( opened )
                }
            }
        }

        ModalContextMenu {

            id: contextMenu

            parent: topItem

            title: dropDown.showTitleInMenu ? dropDown.title : ""

            forceFingerMode: dropDown.engouhSpaceLeft ? 1 :  -1

            content: ActionMenu {
                id: actionMenu

                onTriggered: {
                    dropDown.triggered( index )
                    dropDown.opened = false                    
                    contextMenu.hide()

                    dropDown.selectedTitle = model[index]
                    dropDown.selectedIndex = index
                }
            }

            onFogHideFinished: {
                dropDown.opened = false
            }
        }    
    }

    TopItem {
        id: topItem

        onGeometryChanged: {
            contextMenu.setPosition(
            mapToItem( topItem.topItem, expandButton.x + expandButton.width / 2, 0 ).x,
            mapToItem( topItem.topItem, 0, expandButton.y + expandButton.height / 2 ).y  )
        }
    }

    Theme { id: theme }

    Component.onCompleted: {
        selectedTitle = title;
    }

}
