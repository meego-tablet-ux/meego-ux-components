import Qt 4.7
import MeeGo.Components 0.1

/* MeeGo-Ux-Components tutorial - step 3 */
Window {

    id: window

    bookMenuModel: [ qsTr("Book1"), qsTr("Book2") ]
    bookMenuPayload: [ book1Component, book2Component ]

    Component { id: book1Component; Page1 {} }
    Component { id: book2Component; Page2 {} }

    Component.onCompleted: {
        console.log("Window loaded")
        switchBook( book1Component )
    }

    onActionMenuTriggered: {
        // selectedItem contains the selected payload entry
    }

}
