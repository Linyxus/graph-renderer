import QtQuick 2.4

Rectangle {
    id: root

    color: "transparent"
    opacity: 0.0
    clip: true

    AnimationCircle {
        id: animator

        centerX: parent.width
        centerY: parent.height / 2
        d: 0
        color: "#93a8f5"
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCirc
        }
    }

    Text {
        id: label
        opacity: 0.0
        anchors.centerIn: parent

        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCirc
            }
        }
    }

    SequentialAnimation {
        id: showTextAni
        ScriptAction {
            script: {
                animator.d = 0
                label.opacity = 0.0
                root.opacity = 1.0
                var r = Math.sqrt(animator.centerX * animator.centerX + animator.centerY * animator.centerY)
                animator.expand(r * 2)
            }
        }

        PauseAnimation {
            duration: 350
        }

        ScriptAction {
            script: {
                label.opacity = 1.0
            }
        }

        PauseAnimation {
            duration: 2000
        }

        ScriptAction {
            script: {
                root.opacity = 0.0
            }
        }
    }

    function display(text) {
        label.text = text
        showTextAni.start()
    }
}
