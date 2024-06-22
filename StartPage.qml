import QtQuick
import QtQuick.Controls


Item {

    // 开始界面
    Page {
        id: startPage
        width: 450
        height: 800
        title: "Start Page"
        opacity: 0//关闭动画测试时请注释这条

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

        Button{
            text: "更多"
            width: 80
            height: 40
            onClicked: stackView.push("more.qml")
        }

        Row {
            anchors.centerIn: parent
            spacing: 20

            Button {
                text: "双人联机对战"
                width: 150
                height: 100
                onClicked: stackView.push("board.qml")

                background: Rectangle {
                    anchors.fill: parent
                    color: "gray" // 背景颜色
                    opacity: 0.5 // 半透明效果
                    radius: 5
                }
            }
            Button {
                text: "双人单机对战"
                width: 150
                height: 100
                onClicked: stackView.push("board.qml") // 假设 StackView 的 id 是 stackView
            }
        }
    }

    // 开始时的黑屏效果
    Rectangle {
        id: black
        anchors.fill: parent
        color: "black"
        state: "visible"

        states: [
            State {
                name: "visible"
                PropertyChanges {
                    target: black
                    color: "black"
                }
            },
            State {
                name: "invisible"
                PropertyChanges {
                    target: black
                    color: "transparent"
                }
            }
        ]

        transitions: Transition {
            from: "visible"
            to: "invisible"
            SequentialAnimation {
                ColorAnimation {
                    target: black
                    duration: 1000
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: text
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 700
                    easing.type: Easing.InQuart
                }
                NumberAnimation {
                    target: logo
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 700
                    easing.type: Easing.InQuart
                }
                NumberAnimation {
                    target: startPage
                    property: "opacity"
                    from: 0
                    to: 0.8
                    duration: 500
                    easing.type: Easing.InQuart
                }
            }
        }
    }

    //动画中间的logo展示
    Column {
        anchors.centerIn: parent
        spacing: 40

        // logo
        Image {
            id: logo
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/img/icon.png"
            fillMode: Image.PreserveAspectFit
            sourceSize: Qt.size(250, 150)
            opacity: 0

            NumberAnimation {
                id: logoShow
                target: logo
                property: "opacity"
                from: 0
                to: 1
                duration: 1000
                easing.type: Easing.InQuart
                onFinished: {
                    textShow.start()
                }
            }
        }

        Text {
            id: text
            text: "广告位招租"
            font.pixelSize: 20
            color: "white"
            opacity: 0
            anchors.horizontalCenter: parent.horizontalCenter

            NumberAnimation {
                id: textShow
                target: text
                property: "opacity"
                from: 0
                to: 1
                duration: 1000
                easing.type: Easing.InQuart
            }

            Timer {
                id: timer
                repeat: true
                interval: 500
                triggeredOnStart: false
                running: text.opacity === 1
                onTriggered: {
                    progressValue += 0.1
                    if (progressValue >= 1.0) {
                        progressValue = 1.0
                        black.state = "invisible"
                        stop()
                    }
                }
            }
        }
    }

    property real progressValue: 0.0

    Timer {
        id: startTimer
        repeat: false
        interval: 3000
        triggeredOnStart: false
        onTriggered: {
            logoShow.start()
            stop()
        }
    }

    function start() {
        startTimer.start()
    }

    Component.onCompleted: {
        start()
    }
}
