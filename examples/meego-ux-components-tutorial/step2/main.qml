import Qt 4.7
import MeeGo.Components 0.1

/* MeeGo-Components tutorial - step 2 */
Window {

    id: window

    toolBarTitle: "My Window"

    bookMenuModel: [ qsTr("Page1"), qsTr("Page2") ]
    bookMenuPayload: [ page1Component, page2Component ]

    Component { id: page1Component; Page1 {} }
    Component { id: page2Component; Page2 {} }

    Component.onCompleted: {
        console.log("Window loaded")
        switchBook( page1Component )
    }

    onActionMenuTriggered: {
        // selectedItem contains the selected payload entry
    }
}
