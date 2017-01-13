import QtQuick 2.0

Rectangle {
    id: root

    property int d
    property int centerX
    property int centerY

    width: d
    height: d
    x: centerX - d / 2
    y: centerY - d / 2
    radius: d / 2

    SequentialAnimation {
        id: expandThenFadeAni
        running: false

        NumberAnimation {
            id: num1
            target: root
            property: "d"
            duration: 300
            easing.type: Easing.InOutCirc
        }

        NumberAnimation {
            target: root
            property: "opacity"
            from: 1.0
            to: 0.0
            duration: 200
            easing.type: Easing.OutCirc
        }
    }

    SequentialAnimation {
        id: expandAni
        running: false

        NumberAnimation {
            id: num2
            target: root
            property: "d"
            duration: 200
            easing.type: Easing.InCirc
        }
    }

    function expandThenFade(destD) {
        num1.to = destD
        root.opacity = 1.0
        root.visible = true
        expandThenFadeAni.start()
    }

    function expand(destD, callback) {
        num2.to = destD
        root.opacity = 1.0
        root.visible = true
        expandAni.start()
    }
}
