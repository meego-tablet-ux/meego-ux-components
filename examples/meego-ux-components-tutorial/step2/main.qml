import Qt 4.7
import MeeGo.Components 0.1

/* MeeGo-Components tutorial - step 2 */
Window {

    id: window

    toolBarTitle: "Book menu test"

    bookMenuModel: [ qsTr("Book1"), qsTr("Book2") ]
    bookMenuPayload: [ book1Component, book2Component ]

    Component { id: book1Component; Page1 {} }
    Component { id: book2Component; Page2 {} }

    Component.onCompleted: {
        switchBook( book1Component )
    }
}
