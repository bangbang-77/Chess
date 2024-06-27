import QtQuick
import QtQuick.Controls
import "."
Item{
    id: start
    anchors.fill: parent
    Page {
        width: app.width
        height: app.height

        background: Image {
            source: "qrc:/img/start.png"
            fillMode: Image.Stretch
            anchors.fill: parent
            onStatusChanged: {
                if (status === Image.Error) {
                    console.log("Image load error:", source)
                }
            }
        }

        Button {
            text: "关于"
            width: 80
            height: 40
            onClicked: manage.modes.set('about')
        }


        Row {
            anchors.centerIn: parent
            spacing: 20
            Button {
                text: "双人联机对战"
                width: 150
                height: 100
                onClicked: chooseColor.open()
                background: Rectangle {
                    anchors.fill: parent
                    color: "gray"
                    opacity: 0.5
                    radius: 5
                }
            }
            Button {
                text: "双人单机对战"
                width: 150
                height: 100
                onClicked: manage.modes.set('board')
                background: Rectangle {
                    anchors.fill: parent
                    color: "gray"
                    opacity: 0.5
                    radius: 5
                }
            }
        }
        Dialog {
            id: chooseColor
            title: "选择颜色"
            width: 300
            height: 150
            anchors.centerIn: parent

            contentItem:
                Column {
                    spacing: 20
                    Text {
                        text: "请选择成为黑方/白方（不可选择同样颜色）"
                        width: parent.width
                        wrapMode: Text.Wrap
                        color:"red"
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Row {
                        spacing: 10
                        anchors.horizontalCenter: parent.horizontalCenter

                    Button {
                        text: "黑色"
                        width: 100
                        height: 50
                        onClicked: {
                            manage.modes.set('black')
                            chooseColor.close()
                        }
                    }

                    Button {
                        text: "白色"
                        width: 100
                        height: 50
                        onClicked: {
                            manage.modes.set('white')
                            chooseColor.close()
                        }
                    }
                }
            }
        }
    }
}


