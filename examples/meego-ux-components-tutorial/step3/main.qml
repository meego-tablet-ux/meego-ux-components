import Qt 4.7
import MeeGo.Components 0.1

/* MeeGo-Ux-Components tutorial - step 3 */
Window {

    id: window

    bookMenuModel: [ qsTr("Page1"), qsTr("Page2") ]
    bookMenuPayload: [ page1Component, page2Component ]

    Component { id: page1Component; Page1 {} }
    Component { id: page2Component; Page2 {} }

    Component.onCompleted: {
        console.log("Window loaded")
        switchBool( page1Component )
    }

    onActionMenuTriggered: {
        // selectedItem contains the selected payload entry
    }

}
