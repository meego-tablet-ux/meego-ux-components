/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

import Qt 4.7

import MeeGo.Ux.Kernel 0.1
import MeeGo.Ux.Gestures 0.1

Item {
    id: container
    visible: false

    property alias startHandle: startHandle
    property alias endHandle: endHandle
    property bool pressed: false

    property Item editor: null

    signal close()

    // this function allows to determine the time and place in stack when the handles
    // are created. This way we can ensure SelectionHandleSurface is always behind the
    // CCP ContextMenu.
    function initiate(){
        topItem.calcTopParent()
        innerItem.parent = topItem.topItem
    }

    TopItem { id: topItem }

    Item {
        id: innerItem

        visible: false

        anchors.fill: parent

        Image {
            id: startHandle
            source: "image://themedimage/widgets/common/text-selection/text-selection-marker-start"

            // mh is unused here
            function setPosition (mx, my, mh) {
                x = mx - (width / 2);
                y = (my + mh) - height;
            }
        }

        Image {
            id: endHandle
            source: "image://themedimage/widgets/common/text-selection/text-selection-marker-end"

            function setPosition (mx, my, mh) {
                x = mx - (width / 2);
                y = my;
            }
        }

        GestureArea {
            anchors.fill: parent
            Tap {}
            TapAndHold {}
            Pan {}
            Pinch {}
            Swipe {}
        }

        MouseArea {
            id: mouseArea

            property Item selectedHandle: null

            property int initialX: 0
            property int initialY: 0
            property int xOffset: 0
            property int yOffset: 0
            property bool ignoreRelease: false
            property bool ignorePressAndHold: true
            property int minimumTouchSize: 80   // This value should be set by the theme and units

            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            // we need a single function for each handle, because the areas a user can touch have to be
            // bigger than the image and do not have the same shape for each handle
            // *0.3 and *0.7 reduce the overlapping area
            function insideStartHandle (mx, my) {

                if( startHandle.width >= minimumTouchSize ){
                    return (
                                mx >= startHandle.x + startHandle.width
                                && mx <= startHandle.x + startHandle.width
                            ) && (
                                my >= startHandle.y
                                && my <= startHandle.y + startHandle.height  * 0.7
                            );
                }
                else{
                    if( ( mx >= startHandle.x + (startHandle.width - minimumTouchSize) / 2
                          && mx <= startHandle.x + startHandle.width )
                     && ( my >= startHandle.y  + (startHandle.width - minimumTouchSize) / 2
                          && my <= startHandle.y + startHandle.height * 0.7 ) )
                        return true

                    // additional rect
                    if( (mx >= startHandle.x
                        && mx < startHandle.x + startHandle.width + ( minimumTouchSize - startHandle.width ) / 2)
                     && (my >= startHandle.y  + (startHandle.width - minimumTouchSize) / 2
                        && my <= startHandle.y + startHandle.width + (minimumTouchSize - startHandle.width) / 2 )
                            )
                        return true

                    return false
                }
            }

            function insideEndHandle (mx, my) {
                if( endHandle.width >= minimumTouchSize ){
                    return (mx >= endHandle.x && mx <= endHandle.x + endHandle.width)
                            && (my >= endHandle.y + endHandle.height * 0.3 && my <= endHandle.y + endHandle.height );
                }
                else{
                    if (( mx >= endHandle.x
                          && mx <= endHandle.x + endHandle.width + ( minimumTouchSize - endHandle.width ) / 2 )
                       && ( my >= endHandle.y + endHandle.height * 0.3
                          && my <= endHandle.y + endHandle.height  + ( minimumTouchSize - endHandle.width ) / 2 ))
                        return true

                    // additional rect
                    if(( mx >= endHandle.x + ( endHandle.width - minimumTouchSize ) / 2
                            && mx <= endHandle.x)
                         && ( my >= endHandle.y + endHandle.height - endHandle.width + ( endHandle.width - minimumTouchSize ) / 2
                            && my <= endHandle.y + endHandle.height + ( minimumTouchSize - endHandle.width ) / 2 )
                            )
                        return true

                    return false
                }
            }

            function triggerMenu() {
                var map = mapToItem (container, mouseArea.initialX, mouseArea.initialY);

                // if the click is not on the handles or the textInput, return
                if( !mouseArea.insideStartHandle (mouseArea.initialX, mouseArea.initialY) && !mouseArea.insideEndHandle (mouseArea.initialX, mouseArea.initialY) ){
                    if( map.x < 0 || map.x > container.parent.width ){
                        return
                    }

                    if( map.y < 0 || map.y > container.parent.height ){
                        return
                    }
                }

                map = mapToItem (topItem.topItem, mouseArea.initialX, mouseArea.initialY);
                container.editor.showContextMenu (map.x, map.y);
                container.editor.ensureSelection()
            }

            Timer {
                id: longPressTimer

                interval: 750
                onTriggered: {
                    mouseArea.triggerMenu();
                }
            }

            onPressed: {
                //if the longPressTimer hasn't been started yet, store the initial position and start the timer
                if( !longPressTimer.running ) {
                    mouseArea.initialX = mouse.x
                    mouseArea.initialY = mouse.y
                    longPressTimer.start();
                }
                ignorePressAndHold = false;
                container.pressed = true
                // We store the handle that the mouse pointer was over
                // so we can drag the correct end of the selection
                // on movement.
                if (insideStartHandle (mouse.x, mouse.y)) {
                    selectedHandle = startHandle;
                } else if (insideEndHandle (mouse.x, mouse.y)) {
                    selectedHandle = endHandle;
                } else {
                    selectedHandle = null;
                }

                if (selectedHandle) {
                    // Store the offset so that we can stick the handle to
                    // the mouse pointer to get the correct positioning
                    // Adding a fourth of the height makes you grab the handle in the middle of the letter.
                    // This gives you more freedom in fingermovement before the y-position changes
                    xOffset = mouse.x - selectedHandle.x
                    yOffset = mouse.y - selectedHandle.y + selectedHandle.height / 4;
                }
            }

            onReleased: {
                longPressTimer.stop();
                container.pressed = false
                if (ignoreRelease) {
                    ignoreRelease = false;
                    return;
                }

                if (selectedHandle == null) {
                    container.close ();
                }
            }

            onPressAndHold: {
                // Ignore press and hold if a click on the handle
                // initiated this signal so that we don't pop up the
                // menu in the middle of moving the handle
                if (ignorePressAndHold) {
                    return;
                }

                // Now a menu is popped up we don't want the release to
                // close the selection
                ignoreRelease = true;
                container.pressed = true

                var map = mapToItem (container, mouse.x, mouse.y);

                // if the click is not on the handles or the textInput, return
                if( !insideStartHandle (mouse.x, mouse.y) && !insideEndHandle (mouse.x, mouse.y) ){
                    if( map.x < 0 || map.x > container.parent.width ){
                        return
                    }

                    if( map.y < 0 || map.y > container.parent.height ){
                        return
                    }
                }

                map = mapToItem (topItem.topItem, mouse.x, mouse.y);
                container.editor.showContextMenu (map.x, map.y);
                container.editor.ensureSelection()
            }

            onPositionChanged: {
                if( longPressTimer.running ) {
                    //prevent the longPress if the mouse is moved
                    var distance = Math.abs( mouseArea.initialX - mouse.x ) + Math.abs( mouseArea.initialY - mouse.y )
                    if( distance > 10 ){
                        longPressTimer.stop()
                    }
                }

                if (selectedHandle) {
                    ignorePressAndHold = true;
                    var nx, ny;

                    // Work out where the handle would be moved to
                    nx = mouse.x - xOffset;
                    ny = mouse.y - yOffset;

                    if (selectedHandle == startHandle) {
                        // Convert the handle's position to the
                        // position of the selection
                        var sx = nx + (selectedHandle.width / 2);
                        var sy = ny + (selectedHandle.height);

                        var map = mapToItem (container.editor, sx, sy);

                        // Set the start of the selection
                        // the selection will then move the handle to
                        // the correct place.
                        container.editor.setStartPosition (map.x, map.y);
                    } else {
                        // Same explanation as above, but at the end of
                        // the selection
                        var sx = nx + (selectedHandle.width / 2);
                        var sy = ny;

                        var map = mapToItem (container.editor, sx, sy);
                        container.editor.setEndPosition (map.x, map.y);
                    }
                }
            }
        }
    }

    onVisibleChanged: {
        innerItem.visible = visible;
    }

    onClose: {
        if (visible) visible = false
    }
}
