import Qt 4.7
import MeeGo.Components 0.1

/* MeeGo-Components tutorial - step 1 */
Window {
    id: window

    toolBarTitle: "My Window"

    Component.onCompleted: {
        console.log("Window loaded")
    }
}
