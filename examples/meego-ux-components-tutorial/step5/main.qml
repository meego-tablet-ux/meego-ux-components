import Qt 4.7
import MeeGo.Components 0.1

/* MeeGo-Components tutorial - step 5 */
Window {

    id: window

    toolBarTitle: "My Window"

    bookMenuModel: [ qsTr("Page1") ]
    bookMenuPayload: [ page1Component]

    Component { id: page1Component; Page1 {} }

    Component.onCompleted: {
        console.log("Window loaded")
        switchBook( page1Component )
    }

    onActionMenuTriggered: {
        // selectedItem contains the selected payload entry
    }
}
