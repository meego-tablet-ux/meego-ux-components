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
  \qmlcm  int, the minimum width of the ActionMenu and the DropDown.

  \qmlproperty int maxWidth
  \qmlcm  int, the maximum width of the ActionMenu and the DropDown. Text that exceeds the maximum width will be elided.

  \qmlproperty alias selectedIndex
  \qmlcm int which stores the index of the currently selected item. Can be set from outside, but make
         sure it's set after a model is set, because setting a model resets the selectedIndex
         to -1. See the example below where selectedIndex is set onCompleted.

  \section2 Signals
  \qmlproperty [signal] expandingChanged
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

            Component.onCompleted: {
                selectedIndex = 0
            }
        }
  \endqml
*/

import Qt 4.7
import MeeGo.Ux.Kernel 0.1
import MeeGo.Ux.Gestures 0.1
import MeeGo.Ux.Components.Common 0.1

Item {
    id: dropDown

    property bool opened: false    
    property alias titleColor: titleText.color    
    property alias iconRow: iconArea.children    
    property alias model: actionMenu.model
    property alias payload: actionMenu.payload

    property string title: ""
    property string selectedTitle: "" // DEPRECATED
    property int selectedIndex: 0
    signal triggered( int index )
    signal expandingChanged( bool expanded )

    property alias currentWidth: actionMenu.currentWidth
    property alias highlightSelectedItem: actionMenu.highlightSelectedItem

    property bool replaceDropDownTitle: true
    property bool showTitleInMenu: false

    property real minWidth: 120
    property real maxWidth: 10000
    property real minHeight: 24
    property real maxHeight: 10000

    property real dynamicWidth: 0 // readOnly
    property real dynamicHeight: 0 // readOnly

    property int margin: 5 // readOnly
    property int marginCount: 6 // readOnly

    function updateSize() {

        var valueWidth = iconArea.width + titleText.dynamicWidth + expandButton.width + ( margin * marginCount )

        if( valueWidth > maxWidth ) {
            dynamicWidth = maxWidth
        } else if( valueWidth < minWidth ) {
            dynamicWidth = minWidth
        } else if( valueWidth != dynamicWidth ) {
            dynamicWidth = valueWidth
        }

        var valueHeight = Math.max( ( titleText.dynamicHeight + 2 * dropDown.margin ), iconArea.childrenRect.height )

        if( valueHeight > maxHeight )
            dynamicHeight = maxHeight
        else if( valueHeight < minHeight)
            dynamicHeight = minHeight
        else if( dynamicHeight != valueHeight )
            dynamicHeight = valueHeight

    }

    width:  dynamicWidth
    height: dynamicHeight

    onMinWidthChanged:  updateSize()
    onMaxWidthChanged:  updateSize()
    onMinHeightChanged: updateSize()
    onMaxHeightChanged: updateSize()
    onSelectedIndexChanged: {
        actionMenu.selectedIndex = selectedIndex
        updateSize()
    }  
    Component.onCompleted: {
        highlightSelectedItem = true
        actionMenu.selectedIndex = selectedIndex
        updateSize()
    }
    
    // the border image is the background graphic for the header and the content
    ThemeImage {
      
	id: pulldownImage
	
        anchors.fill: parent

        source: dropDown.opened ? "image://themedimage/widgets/common/combobox/combobox-background-active"
                                : "image://themedimage/widgets/common/combobox/combobox-background"
	
        // the header item contains the title, the image for the button which indicates
        // the expanded state and a GestureArea to change the expanded state on click
        Item {

            id: header
            anchors.fill: parent
            
            Row {
                id: iconArea
                anchors { left: parent.left; top: parent.top; bottom: parent.bottom; leftMargin: dropDown.margin; }
                spacing: dropDown.margin
            }

            LayoutTextItem {
                id: titleText

                anchors.left: iconArea.right
                anchors.leftMargin: dropDown.margin
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                property real textMinWidth: dropDown.minWidth - ( iconArea.width + expandButton.width + 25 )
                property real textMaxWidth: dropDown.maxWidth - ( iconArea.width + expandButton.width + 25 )

                minWidth:  textMinWidth
                maxWidth:  textMaxWidth
                minHeight: dropDown.minHeight
                maxHeight: dropDown.maxHeight

                verticalAlignment: Text.AlignVCenter
                font.pixelSize: theme.fontPixelSizeLarge
                color: theme.fontColorHighlight
                elide: Text.ElideRight
                
		text: replaceDropDownTitle ? model[selectedIndex] : title
		
                onTextChanged: dropDown.updateSize()
		onFontChanged: dropDown.updateSize()
                onDynamicWidthChanged: dropDown.updateSize()
            }

            ThemeImage {
                id: expandButton

                anchors.right: parent.right
                anchors.margins: dropDown.margin * 2
                anchors.verticalCenter: parent.verticalCenter
                source:dropDown.opened ? "image://themedimage/widgets/common/combobox/combobox-item-open-active" :
                "image://themedimage/widgets/common/combobox/combobox-item-open"
            }
        
	    GestureArea {
	      anchors.fill: parent
	      acceptUnhandledEvents: true

	      Tap {
		  onFinished: {
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
	      TapAndHold {
		  onFinished: {
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
	}
        ContextMenu {

            id: contextMenu

            parent: topItem

            title: dropDown.showTitleInMenu ? dropDown.title : ""

            forceFingerMode: dropDown.engouhSpaceLeft ? 1 : -1

            content: ActionMenu {
                id: actionMenu

                highlightSelectedItem: true

                maxWidth: dropDown.maxWidth
                minWidth: dropDown.minWidth		

                onTriggered: {
                    dropDown.selectedIndex = index
                    dropDown.triggered( index )
                    dropDown.opened = false                    
                    contextMenu.hide()
                }
            }

            onClosed: {
                dropDown.opened = false
            }
        }    
    	
    }

    TopItem {
        id: topItem

        onGeometryChanged: {
            if(dropDown.visible){
                contextMenu.setPosition(
                            mapToItem( topItem.topItem, expandButton.x + expandButton.width / 2, 0 ).x,
                            mapToItem( topItem.topItem, 0, expandButton.y + expandButton.height / 2 ).y  )
            }
        }
    }

    Theme { id: theme }
}
