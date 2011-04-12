import Qt 4.7
import MeeGo.Components 0.1

/* MeeGo-Ux-Components tutorial - step 6 */
AppPage {
    id: page1

    pageTitle: "Page 1 of Book 1"
    anchors.fill: parent

    Button {
        id: button
        width:  300
        height:  80
        text: "Show Message Box"

        onClicked: {
            messageBox.show()
        }
    }

    ModalMessageBox {
        id: messageBox

        title: "Do you wanted to click the button?"
        text: "Do you wanted to click the button?"

        showAcceptButton: true
        showCancelButton: true

        fogClickable: true

        onAccepted: { doAccept() } // your implementation of accept
        onRejected: { doReject() } // your implementation of reject
    }

    function doAccept() { }
    function doReject() { }
}
