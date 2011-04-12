import Qt 4.7
import MeeGo.Components 0.1

/* MeeGo-Components tutorial - step 5 */
AppPage {
    id: page1

    pageTitle: "Page 1 of Book 1"
    anchors.fill: parent

    onActionMenuIconClicked: {
        contextActionMenu.setPosition( mouseX, mouseY )
        contextActionMenu.show()
    }

    ModalContextMenu {
        id: contextActionMenu
        forceFingerMode: 2

        content:  Item {
            width: 300
            height: 300

            Column {
                id: column

                width: parent.width

                anchors.fill: parent
                anchors.margins: 10

                spacing: 10

                Text{
                    font.pixelSize: 24
                    text:  "Custom ContextMenu"
                }
                TextEntry{
                    width: 250
                    defaultText:"some entry"
                }
                Text{
                    width: parent.width
                    font.pixelSize: 20
                    wrapMode: Text.WordWrap
                    text:  "This is an example of a completely own customizable context menu each page can set."
                }
            }
        }
    }
}
