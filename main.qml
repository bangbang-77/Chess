import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 450
    height: 800
    title: "Chess"

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: "StartPage.qml" // 初始时为空，不显示任何页面
    }
}
