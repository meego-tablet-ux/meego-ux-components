/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

import Qt 4.7
import MeeGo.Ux.Kernel 0.1

MouseArea {
    id: box
    property int clickCount: 0
    property int selectionStart: 0
    property int selectionEnd: 0

    property real xOffset: 0
    property real yOffset: 0
    property int pendingCursorPosition: 0

    property int mouseX: 0
    property int mouseY: 0

    // The Item this mouse area handles
    property Item editor: null

    // Set to true when we are actually currently dragging a selection
    // to prevent the context menu activating in the middle of the
    // drag
    property bool currentlySelecting: false

    // this stores whether the CCP area is pressed. We can't use MouseArea's pressed because
    //  we have to consider the SelectionHandleSurface's state too.
    property bool isPressed: false

    property bool copyOnly: false
    property bool pasteOnly: false
    property bool pasteEmpty: false

    // Shows the context menu at cx,cy. cx & cy are in the root windows
    // coordinate space, not the CCPContextArea's.
    function showContextMenu (cx, cy) {

        pasteCheck.text = ""
        pasteCheck.paste()
        if( pasteCheck.text == "" ){
            pasteEmpty = true
        }
        else{
            pasteEmpty = false
        }

        if( selectionStart == selectionEnd ){
            box.pasteOnly = true

            if(  state != "selection" ){
                // this is a workaround for problems pasting contents into the middle of a TextInput
                // this ensures something is 'selected'
                var mapHelp = mapFromItem (top.topItem, cx, cy)
                selectionStart = editor.positionAt (mapHelp.x, mapHelp.y);
                selectionEnd = selectionStart;
            }
        }
        else{
            box.pasteOnly = false
        }

        if( (selectionStart == selectionEnd && copyOnly ) || ( box.pasteOnly && box.pasteEmpty ) )
            return

        clipboardContextMenu.setPosition(  cx, cy )
        clipboardContextMenu.show()

        var map = mapFromItem (top.topItem, cx, cy)
        box.mouseX = map.x
        box.mouseY = map.y
        editor.forceActiveFocus ();
    }

    function ensureSelection() {
        // ensure selection is visible
        editor.select (selectionStart, selectionEnd);
    }

    // We set the position here, which in turn controls where the
    // selectionHandleSurface places the handles.
    // It looks like the user is dragging the handles and that controls the
    // selection, but it is actually the opposite way round
    function setStartPosition (px, py) {

        // check if you are too low and set y to last row to ease selection when you're at the same height as the selectionEnd
        var rect = editor.positionToRectangle (selectionEnd);
        console.log(py)
        if( rect.y + rect.height / 2 < py ){
            py = rect.y + rect.height / 2
        }
        // check if you are too high and set y to 1 to ease selection of parts of the firts row
        if( py <= 0 ){
            py = 1
        }

        var s = editor.positionAt (px, py);
        if (s > selectionEnd) {
            s = selectionEnd;
        }

        editor.select (s, selectionEnd);
        selectionStart = s;

        rect = editor.positionToRectangle (selectionStart);

        var map = mapToItem (top.topItem, rect.x, rect.y);
        selectionHandleSurface.startHandle.setPosition (map.x, map.y, rect.height);
    }

    function setEndPosition (px, py) {
        // check if you are higher than the start and set y to fit the start height to ease selection
        var rect = editor.positionToRectangle (selectionStart);
        if( rect.y + rect.height / 2 > py ){
            py = rect.y + rect.height / 2
        }

        // check if you've reached the end of the text and set y appropriately to ease selection
        rect = editor.positionToRectangle( editor.positionAt (px, py) )
        if( py > rect.y + rect.height / 2 ){
            py = rect.y + rect.height / 2
        }

        var e = editor.positionAt (px, py);
        if (e < selectionStart) {
            e = selectionStart;
        }

        editor.select (selectionStart, e);
        selectionEnd = e;

        rect = editor.positionToRectangle (selectionEnd);

        var map = mapToItem (top.topItem, rect.x, rect.y);
        selectionHandleSurface.endHandle.setPosition (map.x, map.y, rect.height);
    }

    TextInput {
        id: pasteCheck
        visible: false
    }

    TopItem {
        id: top
        onGeometryChanged: {
            var rect = editor.positionToRectangle (selectionStart);

            var map = mapToItem (top.topItem, rect.x, rect.y);

            selectionHandleSurface.startHandle.setPosition (map.x, map.y, rect.height);

            rect = editor.positionToRectangle (selectionEnd);
            map = mapToItem (top.topItem, rect.x, rect.y);

            selectionHandleSurface.endHandle.setPosition (map.x, map.y, rect.height);

            map = mapToItem (top.topItem, box.mouseX, box.mouseY);
            clipboardContextMenu.setPosition ( map.x, map.y )
        }
    }

    Timer {
        id: doubleClickTimer
        interval: 250
        onTriggered: {
            parent.clickCount = 0;
            editor.cursorPosition = pendingCursorPosition;
            editor.forceActiveFocus ();
        }
    }

    onPressed: {
        doubleClickTimer.stop ();
        clickCount++;
        // Start double click timer
        // If the timer expires before another press event
        // then the click count will be reset
        doubleClickTimer.start ();

        box.isPressed = true

        if (clickCount == 2) {
            state = "selection"

            selectionHandleSurface.initiate()

            selectionStart = editor.positionAt (mouse.x, mouse.y);
            selectionEnd = selectionStart;

            var rect = editor.positionToRectangle (selectionStart);
            var map = mapToItem (top.topItem, rect.x, rect.y);
            selectionHandleSurface.startHandle.setPosition (map.x, map.y, rect.height);
            selectionHandleSurface.endHandle.setPosition (map.x, map.y, rect.height);

            currentlySelecting = true;
        } else {
            pendingCursorPosition = editor.positionAt (mouse.x, mouse.y);
        }
    }

    onReleased: {

        if (state == "selection") {
            ensureSelection()
        }
        currentlySelecting = false;
        box.isPressed = false
    }

    onPositionChanged: {
        if (state != "selection") {
            return;
        }

        setEndPosition( mouse.x, mouse.y )
    }

    onPressAndHold: {

        box.isPressed = true
        if (currentlySelecting == true) {
            return;
        }

        selectionHandleSurface.initiate()
        var map = mapToItem (top.topItem, mouse.x, mouse.y);

        showContextMenu (map.x, map.y);
    }

    // The mouse area needs to expand outside of the parent
    // so that the selection handles can be clicked when they
    // are in the gutter
    x: 0
    y: 0
    width: parent.width
    height: parent.height

    Connections {
        target: editor

        onTextChanged: {
            // QML's TextEdit emits textChanged() even when the cursor moves or focus changes,
            // so we have to ignore textChanged() while interacting with the CCPContextArea
            if (box.isPressed) {    // if the area is not pressed
                return;
            }
            box.state = "";         // reset the states and hide
            box.selectionStart = 0;
            box.selectionEnd = 0;

            clipboardContextMenu.hide()
        }
    }

    ContextMenu {
        id: clipboardContextMenu

        content: ActionMenu {
            id: ccpMenu

            model: if(box.copyOnly){
                       [qsTr ("Copy")] }
                   else if( box.pasteOnly ){
                       [qsTr ("Paste")]
                   }else{
                       if(box.pasteEmpty){
                           [qsTr ("Copy"), qsTr ("Cut")]
                       }
                       else{
                           [qsTr ("Copy"), qsTr ("Cut"), qsTr ("Paste")]
                       }
                   }

            onTriggered: {

                editor.select ( box.selectionStart, box.selectionEnd);
                switch (index) {
                case 0:
                    if( box.pasteOnly ){
                        box.parent.paste();
                    }
                    else {
                        box.parent.copy();
                    }
                    break;

                case 1:
                    box.parent.cut();
                    break;

                case 2:
                    box.parent.paste();
                    break;

                default:
                    break;
                }

                box.state = "";
                editor.select (box.editor.cursorPosition, box.editor.cursorPosition);

                box.selectionStart = 0;
                box.selectionEnd = 0;

                clipboardContextMenu.hide()
            }
        }

        onOpacityChanged: {
            if(opacity == 1)
                box.isPressed = false
        }
    }

    SelectionHandleSurface {
        id: selectionHandleSurface

        editor: parent
        z: 1

        onClose: {
            parent.state = "";
            parent.editor.select (editor.cursorPosition, editor.cursorPosition);
            parent.editor.cursorPosition = selectionStart;
            selectionStart = 0;
            selectionEnd = 0;
        }

        onPressedChanged: {
            box.isPressed = pressed
        }
    }

    states: [
        State {
            name: "selection"
            PropertyChanges {
                target: selectionHandleSurface
                visible: true
            }
        }
    ]
}
