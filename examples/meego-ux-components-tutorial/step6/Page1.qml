import Qt 4.7
import MeeGo.Components 0.1

/* MeeGo-Ux-Components tutorial - step 6 */
AppPage {
    id: page1

    pageTitle: "ModalDialog Test"
    anchors.fill: parent

    Button {
        id: button

        anchors.centerIn: parent
        width:  300
        height:  80
        text: "Show ModalMessageBox"

        onClicked: {
            messageBox.show()
        }
    }

    ModalMessageBox {
        id: messageBox

        title: "This is a ModalMessageBox"

        text: "Did you press the button gently?"

        showAcceptButton: true
        showCancelButton: true

        fogClickable: false //false means clicking outside the dialog won't close it

        onAccepted: { } // do something
        onRejected: { } // do something
    }
}
