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
            name:"about"
            onEnter:{
                onBack(function(){modes.set("start")})
                aboutLoader.opacity=1
            }
            onLeave: aboutLoader.opacity=0
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
            source: 'start.qml'
            active: opacity > 0

            visible: status == Loader.Ready && opacity > 0

            opacity: 0
            Behavior on opacity {
                NumberAnimation { duration: 1000 }
            }
        }

        Loader {
            id: boardLoader
            anchors { fill: parent }
            source: 'board.qml'
            active: opacity > 0
            visible: status == Loader.Ready && opacity > 0

            opacity: 0
            // Behavior on opacity {
            //     NumberAnimation { duration: 1500 }
            // }
        }

        Loader {
            id: aboutLoader
            anchors { fill: parent }
            source: 'about.qml'
            active: opacity > 0

            visible: status == Loader.Ready && opacity > 0

            opacity: 0
            Behavior on opacity {
                NumberAnimation { duration: 1000 }
            }
        }
    }
    property var backQueue: []
    function goBack() {
        if(backQueue.length > 0) {
            console.log('Popping from back queue') //¤
            var func = backQueue.pop()
            var t = backQueue
            backQueue = t
            func()
        }
    }
    function onBack(func) {
        console.log('Pushing to back queue') //¤
        backQueue.push(func)
        var t = backQueue
        backQueue = t
    }
}
