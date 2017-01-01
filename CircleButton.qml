import QtQuick 2.0

Rectangle {
    id: root

    property int r
    property alias text: label.text
    signal click

    Behavior on color {
        ColorAnimation {
            duration: 300
            easing.type: Easing.OutCirc
        }
    }

    width: r * 2
    height: r * 2
    radius: r
    border.color: "#5175f9"
    Text {
        id: label
        font.pointSize: 10
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered:
            root.color = "#bcc9f9"
        onExited:
            root.color = "white"
        onClicked:
            root.click()
    }
}
