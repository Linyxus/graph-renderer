import QtQuick 2.7
import QtQuick.Window 2.2

Window {
    visible: true
    width: 500
    height: 680
    title: qsTr("Hello World")

    Rectangle {
        id: root
        anchors.fill: parent

        Rectangle {
            id: renderView

            Connections {
                target: dataMap
                onMapChanged: {
                    console.log("DataMap changed!")

                    //canvas draw lines
                    renderView.cols = dataMap.getCol()
                    renderView.rows = dataMap.getRow()
                    renderView.showGrid = dataMap.getShowGrid()
                    cvs.update()
                    cvs.requestPaint()

                    //labels
                    textData.clear()
                    for (var ii = 0; ii < dataMap.getLabelCnt(); ii++) {
                        var xx = dataMap.getLabelX(ii) * renderArea.width
                        var yy = dataMap.getLabelY(ii) * renderArea.height
                        var tt = dataMap.getLabelText(ii)
                        textData.append({
                                            px: xx,
                                            py: yy,
                                            txt: tt
                                        })
                    }
                }
            }

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: root.height * 0.7
            property int cols: 10
            property int rows: 10
            property bool showGrid: true
            Rectangle {
                id: renderTitle
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: 30
                color: "#6897d9"

                Text {
                    anchors.centerIn: parent
                    text: "Render View"
                }
            }
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: renderTitle.bottom
                anchors.bottom: parent.bottom
                anchors.margins: 10
                Rectangle {
                    id: renderArea
                    anchors.centerIn: parent
                    width: parent.width < parent.height ? parent.width : parent.height
                    height: width

                    Canvas {
                        id: cvs
                        anchors.fill: parent

                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.clearRect(0, 0, cvs.width, cvs.height)
                            ctx.lineWidth = 1
                            ctx.strokeStyle = "#4f9cf3"
                            ctx.beginPath()
                            for (var ii = 0; ii < dataMap.getLineCnt(); ii++) {
                                var sx = dataMap.getStartX(
                                            ii) * renderArea.width
                                var sy = dataMap.getStartY(
                                            ii) * renderArea.height
                                var ex = dataMap.getEndX(ii) * renderArea.width
                                var ey = dataMap.getEndY(ii) * renderArea.height
                                ctx.moveTo(sx, sy)
                                ctx.lineTo(ex, ey)
                            }
                            ctx.stroke()
                        }
                    }

                    ListModel {
                        id: textData

                        //                        ListElement {
                        //                            px: 50
                        //                            py: 50
                        //                            txt: "Hello!"
                        //                        }
                    }

                    Repeater {
                        model: textData
                        Text {
                            text: txt
                            x: px
                            y: py
                            font.pointSize: 8
                        }
                    }

                    Grid {
                        columns: renderView.cols
                        spacing: -1
                        Repeater {
                            model: datas
                            Rectangle {
                                width: renderArea.width / renderView.cols
                                height: renderArea.height / renderView.rows
                                color: "transparent"
                                border.width: renderView.showGrid ? 1 : 0
                                border.color: "#6897d9"

                                Rectangle {
                                    visible: vis
                                    anchors.centerIn: parent
                                    width: parent.width > parent.height ? parent.height * 0.8 : parent.height * 0.8
                                    height: width
                                    radius: width / 2
                                    border.color: "#37819e"
                                    Text {
                                        anchors.centerIn: parent
                                        text: i
                                        font.pointSize: 12
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: cmdView
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: renderView.bottom
            anchors.bottom: parent.bottom
            Rectangle {
                id: cmdTitle
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: 30
                color: "#6897d9"

                Text {
                    anchors.centerIn: parent
                    text: "Command View"
                }
            }
            Rectangle {
                id: cmdArea

                clip: true
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: cmdTitle.bottom
                anchors.bottom: parent.bottom
                anchors.margins: 10

                Rectangle {
                    id: textArea

                    anchors.left: parent.left
                    anchors.right: btnArea.left
                    anchors.bottom: parent.bottom
                    anchors.top: parent.top
                    anchors.margins: 10
                    clip: true
                    Flickable {
                        id: flick
                        anchors.fill: parent
                        contentWidth: edit.contentWidth
                        contentHeight: edit.contentHeight
                        flickableDirection: Flickable.VerticalFlick
                        TextEdit {
                            id: edit
                            focus: true
                            onTextChanged: {
                                flick.contentY = edit.cursorRectangle.y - flick.height
                                        > 0 ? edit.height - flick.height : 0
                            }
                        }
                    }

                    AnimationCircle {
                        id: clearCircle

                        centerX: parent.width
                        centerY: parent.height - btnClear.height / 2 - 5
                        anchors.bottomMargin: 10
                        color: "#93a8f5"
                        d: 0
                    }
                }

                Rectangle {
                    id: btnArea

                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 60

                    CircleButton {
                        id: btnRender
                        r: parent.width * 0.45
                        text: "Render"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.margins: 5
                        onClick: {
                            if (edit.text != "") {
                                var str = cmd.command(edit.text)
                                console.log(str)
                                resLabel.display(str)
                            }
                        }
                    }

                    CircleButton {
                        id: btnClear
                        r: parent.width * 0.45
                        text: "Clear"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.margins: 5

                       SequentialAnimation {
                           id: clrAni

                           PauseAnimation {
                               duration: 300
                           }

                           ScriptAction {
                               script: {
                                   edit.text = ""
                               }
                           }
                        }
                        onClick: {
                            var r = Math.sqrt(clearCircle.centerX * clearCircle.centerX + clearCircle.centerY * clearCircle.centerY)
                            clearCircle.d = 0
                            clearCircle.expandThenFade(r * 2)
                            clrAni.start()
                        }
                    }
                }

                AnimationLabel {
                    id: resLabel

                    anchors.right: btnArea.left
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    width: 200
                    height: 50
                }
            }
        }
    }
}
