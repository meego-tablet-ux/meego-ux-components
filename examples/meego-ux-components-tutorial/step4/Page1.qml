import Qt 4.7
import MeeGo.Components 0.1

/* MeeGo-Components tutorial - step 4 */
AppPage {
    id: page1

    function doActionOne() {
        area.color = "lightgreen"
    }
    function doActionTwo() {
        area.color = "lightblue"
    }

    pageTitle: qsTr("ContextMenu Test")

    Rectangle {
        id: area

        anchors.fill: parent
        anchors.margins: 30
        color: "lightgrey"

        MouseArea {
            anchors.fill: parent

            onClicked: {
                contextMenu.setPosition( mapToItem( topItem.topItem, mouseX, mouseY ).x, mapToItem( topItem.topItem, mouseX, mouseY ).y )
                contextMenu.show()
            }
        }
    }

    TopItem{ id: topItem }

    ContextMenu {
        id: contextMenu

        forceFingerMode: -1

        content: ActionMenu{
            id: colorMenu

            maxWidth: 200
            minWidth: 100

            model: [ "lightgreen", "lightblue"]

            onTriggered: {
                if( index == 0 )
                    page1.doActionOne()
                if( index == 1 )
                    page1.doActionTwo()

                contextMenu.hide()
            }
        }
    }
}
