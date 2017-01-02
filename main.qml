import QtQuick 2.7
import QtQuick.Window 2.2

Window {
    visible: true
    width: 1000
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
                    renderView.cols = dataMap.getCol()
                    renderView.rows = dataMap.getRow()
                    renderView.showGrid = dataMap.getShowGrid()
                    cvs.update()
                    cvs.requestPaint();
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
                id: renderArea
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: renderTitle.bottom
                anchors.bottom: parent.bottom
                anchors.margins: 10

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
                            var sx = dataMap.getStartX(ii) * renderArea.width
                            var sy = dataMap.getStartY(ii) * renderArea.height
                            var ex = dataMap.getEndX(ii) * renderArea.width
                            var ey = dataMap.getEndY(ii) * renderArea.height
                            ctx.moveTo(sx, sy)
                            ctx.lineTo(ex, ey)
                        }
                        ctx.stroke()
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
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: cmdTitle.bottom
                anchors.bottom: parent.bottom
                anchors.margins: 10

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
                                var str = cmd.command(edit.text);
                                console.log(str)
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
                        onClick: {
                            edit.text = ""
                        }
                    }
                }

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
                                flick.contentY = edit.cursorRectangle.y - flick.height > 0 ? edit.height - flick.height : 0
                            }
                        }
                    }
                }
            }
        }
    }
}
