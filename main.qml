import QtQuick
import QtQuick.Controls
import QtMultimedia

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 450
    height: 800
    title: "Chess"

    //背景音乐
    MediaPlayer {
        id: mediaPlayer
        source: "qrc:/music/start_bgm.ogg"
        audioOutput: AudioOutput{id:audio}
        //无限循环
        loops:MediaPlayer.Infinite
        Component.onCompleted: {
            mediaPlayer.play();
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: "StartPage.qml"
    }
}
