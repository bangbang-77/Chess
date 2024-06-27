import QtQuick
import QtQuick.Controls
import "."

Item {
    id: help
    Page {
        width: app.width
        height: app.height
        background:Image {
                source: "qrc:/img/start.png"
                fillMode: Image.Stretch
                anchors.fill: parent
                opacity: 0.5
            }
        Column {
            spacing: 40
            Button {
                id: back
                text: "Back"
                onClicked: manage.goBack() // 返回上一页
            }
            Text {
                text: qsTr("国际象棋介绍：")
                font.pixelSize: 20
                anchors.left: parent.left; anchors.leftMargin: 20
            }
            Rectangle {
                id: intro
                width: 400
                height: 500
                border.color: "blue"
                color: "transparent"
                anchors.left: parent.left; anchors.leftMargin: 20
                SwipeView {
                    id: view
                    anchors.fill: parent
                    Rectangle {
                        color: "transparent"
                        Text {
                            text: qsTr("None")
                            anchors.fill: parent
                            color: "white"
                            wrapMode: Text.Wrap
                            font.pointSize: 10
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Rectangle {
                        color: "transparent"
                        Text {
                            text: qsTr("总介绍")
                            anchors.fill: parent
                            color: "white"
                            font.pointSize: 24
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Rectangle {
                        color: "transparent"
                        Text {
                            text: qsTr("总介绍")
                            anchors.fill: parent
                            color: "white"
                            font.pointSize: 24
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
        }
    }
}
