import QtQuick
import "."

Item {
    id: manage

    property alias modes: modes

    Modes{
        id:modes
        Mode{
            name:"start"
            onEnter:{
                startLoader.opacity=1
                console.log("have started!")
            }
            onLeave: startLoader.opacity=0
        }
        Mode{
            name:"board"
            onEnter:{
                onBack(function(){modes.set("start")})
                boardLoader.opacity=1
            }
            onLeave: boardLoader.opacity=0
        }
        Mode{
            name:"help"
            onEnter:{
                onBack(function(){modes.set("board")})
                helpLoader.opacity=1
            }
            onLeave: helpLoader.opacity=0
        }
        Mode{
            name:"white"
            onEnter:{
                onBack(function(){modes.set("start")})
                whiteLoader.opacity=1
            }
            onLeave: whiteLoader.opacity=0
        }
        Mode{
            name:"black"
            onEnter:{
                onBack(function(){modes.set("start")})
                blackLoader.opacity=1
            }
            onLeave: blackLoader.opacity=0
        }
        Mode{
            name:"setting"
            onEnter:{
                onBack(function(){modes.set("start")})
                settingLoader.opacity=1
            }
            onLeave: settingLoader.opacity=0
        }
        Mode{
            name:"developer"
            onEnter:{
                onBack(function(){modes.set("start")})
                developLoader.opacity=1
            }
            onLeave: developLoader.opacity=0
        }
        Mode {
            name: 'quit'
            onEnter: Qt.quit()
        }
    }
    Item {
        id:loader
        Loader {
            id: startLoader
            anchors { fill: parent }
            source: 'Start.qml'
            active: opacity > 0//透明度大于0才会加载

            visible: status == Loader.Ready && opacity > 0//只有在加载和透明度大于0时可见

            opacity: 0
        }

        Loader {
            id: boardLoader
            anchors { fill: parent }
            source: 'Board.qml'
            active: opacity > 0
            visible: status == Loader.Ready && opacity > 0

            opacity: 0
            PropertyAnimation on opacity {
                id: boardAnimation
                duration: 500
                from: 0
                to: 1
                running: false // 初始状态为不运行
            }

            onOpacityChanged: {
                if (opacity === 1 && boardAnimation.from === 0) {
                        boardAnimation.running = true; // 仅在从 0 变为 1 时启动动画
                    console.log("加载单机")
                }
            }
        }

        Loader {
            id: helpLoader
            anchors { fill: parent }
            source: 'Help.qml'
            active: opacity > 0

            visible: status == Loader.Ready && opacity > 0

            opacity: 0
            Behavior on opacity {
                NumberAnimation { duration: 1000 }
            }
        }
        Loader {
            id: whiteLoader
            anchors { fill: parent }
            source: 'NetWorkWhite.qml'
            active: opacity > 0

            visible: status == Loader.Ready && opacity > 0

            opacity: 0
        }
        Loader {
            id: blackLoader
            anchors { fill: parent }
            source: 'NetWorkBlack.qml'
            active: opacity > 0

            visible: status == Loader.Ready && opacity > 0

            opacity: 0
        }
        Loader {
            id: settingLoader
            anchors { fill: parent }
            source: 'Setting.qml'
            active: opacity > 0

            visible: status == Loader.Ready && opacity > 0

            opacity: 0
        }
        Loader {
            id: developLoader
            anchors { fill: parent }
            source: 'Developer.qml'
            active: opacity > 0

            visible: status == Loader.Ready && opacity > 0

            opacity: 0
        }
    }
    property var backQueue: []
    function goBack() {
        if(backQueue.length > 0) {
            console.log('Popping from back queue')
            var func = backQueue.pop()
            var t = backQueue
            backQueue = t
            func()
        }
    }
    function onBack(func) {
        console.log('Pushing to back queue')
        backQueue.push(func)
        var t = backQueue
        backQueue = t
    }
}
