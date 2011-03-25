import Qt 4.7
import MeeGo.Components 0.1

/* MeeGo-Ux-Components tutorial - step 4 */
Window {
    id: window

    property variant myModel [ "Foo", "Bar" ]

    TopItem {
        id: topItem
    }

    Rectangle {

        anchors.centerIn: parent
        id: area
        width: 550
        height: 400
        color: blue

        MouseArea {
           anchors.fill: parent
           onClicked: {
             contextMenu.setPosition( mapToItem( topItem.topItem, mouseX, mouseY ).x, mapToItem( topItem.topItem, mouseX, mouseY ).y )
             contextMenu.show()
        }
    }

    ModalContextMenu {
        id: contextMenu
        forceFingerMode: -1

        content: ActionMenu {
            id: actionMenu

            maxWidth: 400

            model: myModel

            onTriggered: {
                if( index == 0 )
                    doFoo() // your implementation
                if( index == 1 )
                    doBar() // your implementation
                contextMenu.hide()
            }
        }
    }

    function doFoo() { }
    function doBar() { }
}
