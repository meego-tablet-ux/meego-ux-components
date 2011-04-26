import Qt 4.7
import MeeGo.Components 0.1

/* MeeGo-Components tutorial - step 5 */
Window {
    id: window

    Component { id: page1Component; Page1 {} }

    Component.onCompleted: {
        console.log("Window loaded")
        switchBook( page1Component )
    }
}
