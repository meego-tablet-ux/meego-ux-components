import Qt 4.7

Item {
    id: container

    property alias color: ar.color

    Rectangle {
        id: ar

        anchors.centerIn: parent

        width: 110
        height: 10

        border.width: 0

    }
    Rectangle {
        id: row

        rotation: 45
        anchors.left: ar.right
        anchors.leftMargin: -5
        anchors.top: ar.top
        width: 10
        height: 10
        color: ar.color

        border.width: 0
    }
}
