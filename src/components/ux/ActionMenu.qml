/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
   \qmlclass ActionMenu
   \title ActionMenu
   \section1 ActionMenu
         The ActionMenu provides a list of text entries that can be clicked.
         The triggered() signal returns the selected index. The payload property can
         store a second list with additional data for the entry list.
         The ActionMenu will elide text that exceeds its maximum width set via maxWidth.
         Otherwise the width will always be as small as possible, with minimum minWidth.
         If the entries height exceeds the windows height, it will enable flicking.

  \section2 API Properties
  \qmlproperty  model
  \qmlcm list, the entries texts.

  \qmlproperty variant payload
  \qmlcm an array which contains the entries needed additional data.

  \qmlproperty int minWidth
  \qmlcm  int, the minimum width of the ActionMenu.

  \qmlproperty int maxWidth
  \qmlcm  int, the maximum width of the ActionMenu. Text that exceeds the maximum width will be elided.

  \qmlproperty int textMargin
  \qmlcm left and right margin of the text entries.

  \qmlproperty item currentItem
  \qmlcm stores the currently pressed Item to reset the pressed state on move.

  \qmlproperty int selectedIndex
  \qmlcm stores the index of the currently selected item. Can be set from outside, but make
         sure it's set after a model is set, because setting a model resets the selectedIndex
         to -1.

  \section2 Private Properties
  \qmlproperty int currentWidth
  \qmlcm computed minimum width to show the text completely, clamped by minWidth and maxWidth.

  \section2 Signals
  \qmlfn triggered
  \qmlcm returns the index of the clicked entry.
        \param int parameter
        \qmlpcm index of the currentItem. \endparam

  \section2 Functions
  \qmlnone

  \section2 Example
  \qmlcm see ModalContextMenu
  \qml
    // -
  \endqml
*/

import Qt 4.7

Flickable {
    id: container

    property alias model: repeater.model
    property variant payload

    property int minWidth : 200
    property int maxWidth : 500
    property bool highlightSelectedItem: true

    property int currentWidth: minWidth
    property int textMargin : 16

    property Item currentItem: null
    property Item oldItem: null
    property int selectedIndex: -1

    signal triggered( int index )

    onMovingChanged: {          // This slot deselects the current item when the flickable movement changed
        if( !highlightSelectedItem ){   // onPositionChanged() was to to touchy on the touchpad
            currentItem = null
            oldItem = null
        }
        currentItem = null
    }

    Connections {
        target: topItem.topItem

        onHeightChanged: {
            if( container.contentHeight <= container.height ){
                container.contentY = 0
            }
            else if( container.contentY + container.height > container.contentHeight ){
                container.contentY = container.contentHeight - container.height
            }
        }
    }

    // currentWidth is the current width of the largest text width, clamped between minWidth and maxWidth
    width: currentWidth
    height: layout.height

    interactive: ( height < layout.height )

    // this has to be set explicitly or the flickable will strangly not recognize the layouts height
    contentHeight: layout.height

    flickDeceleration: 250

    clip: true

    TopItem {
        id: topItem

        onGeometryChanged: {
            container.contentY = 0
        }
    }

    Column {
        id: layout

        property bool elideEnabled: false

        width: parent.width

        Theme{ id: theme }

        Repeater {
            id: repeater

            width: parent.width

            delegate: Item {
                id: delegateThingy

                property int selectedIndex: container.selectedIndex

                onSelectedIndexChanged: {
                    if( index == selectedIndex ) {
                        container.oldItem = highlight
                    }
                }

                width: repeater.width
                height: textItem.paintedHeight + textMargin * 2

                clip : true

                Rectangle {

                    id: highlight

                    color: theme.fontColorHighlightBlue
                    anchors.centerIn: parent
                    width:  parent.width
                    height: parent.height + 1
                    anchors.verticalCenterOffset: -1

                    opacity: ( highlight == container.currentItem || highlight == container.oldItem ) ? 1 : 0 // this forces a repaint
                    visible: opacity != 0

                }

                Text {
                    id: textItem

                    x: textMargin

                    width: parent.width - textMargin * 2
                    height: delegateThingy.height - 1   // -1 to leave space for the seperator

                    verticalAlignment: Text.AlignVCenter

                    color: ( highlight == container.currentItem || highlight == container.oldItem ) ? "white" : theme.contextMenuFontColor
                    font.pixelSize: theme.contextMenuFontPixelSize

                    // elide has to be turned off to correctly compute the paintedWidth. It is re-enabled after the width computing
                    elide: if(layout.elideEnabled){ Text.ElideRight; }else{ Text.ElideNone; }

                    text: modelData

                    Component.onCompleted: {
                        // This compares the paintedWidth to minWidth and maxWidth and sets the widgets width accordingly
                        if( paintedWidth + textMargin * 2  > container.currentWidth ){
                            if( paintedWidth + textMargin * 2 > maxWidth )
                                container.currentWidth = maxWidth;
                            else{
                                container.currentWidth = paintedWidth + textMargin * 2;
                            }
                        }
                        if( currentWidth > maxWidth ){
                            currentWidth = maxWidth;
                        }
                    }
                }

                Image {
                    id: seperatorImage

                    anchors.top: textItem.bottom
                    anchors.horizontalCenter: textItem.horizontalCenter
                    width: parent.width

                    visible: index < repeater.count - 1     // Seperator won't be visible for the last item

                    source: "image://themedimage/widgets/common/menu/menu-item-separator"
                }

                MouseArea {
                    anchors.fill: parent

                    // pressed state for the text entry:
                    onClicked: {
                        container.triggered( index )
                        container.selectedIndex = index


                        if( !highlightSelectedItem ) {
                            container.currentItem = null
                        }
//                        else {
//                            container.oldItem = highlight
//                        }
                    }

                    onPressed: {
                        container.currentItem = highlight
                    }

                    onExited: {
                        container.currentItem = null
                    }
                }             
            }

            onModelChanged: {       // if the model changed, the width has to be calculated again, so reset values
                currentWidth = minWidth
                container.selectedIndex = -1
                layout.elideEnabled = false
            }
        }
    }

    onVisibleChanged: {

        if( !highlightSelectedItem )
             oldItem = null

        layout.elideEnabled = true  // elide text that exceeds the maxWidth
        contentY = 0    // reset position

        opacity = visible ? 1 : 0 // force repaint
    }

    states: [
        State {
           PropertyChanges {
                target: container
                height: ( topItem.topHeight - topItem.topDecorationHeight ) * 0.8   // defines the maximum height of the ActionMenu
            }
           when: layout.height > ( topItem.topHeight - topItem.topDecorationHeight ) * 0.8
        }
    ]
}
