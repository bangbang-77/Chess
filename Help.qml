//教程页面，记录了游戏规则相关内容
import QtQuick
import QtQuick.Controls

Item {
    id: help
    Page {
        width: app.width
        height: app.height
        background: Image {
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
                width: parent.parent.width * 0.9
                height: parent.parent.height * 0.7
                border.color: "black"
                color: "transparent"
                anchors.left: parent.left; anchors.leftMargin: 20
                anchors.rightMargin: 20
                SwipeView{
                    id:view
                    anchors.fill: parent
                    Rectangle {
                        color: "transparent"
                        Column {
                            anchors.fill: parent
                            spacing: 20
                            anchors.leftMargin: 25
                            Text {
                                id: title1
                                text: qsTr("认识棋子")
                                color: "white"
                                wrapMode: Text.Wrap
                                font.pointSize: 20
                            }
                            Grid {
                                columns: 1
                                spacing: 10
                                anchors.topMargin: 10
                                height: parent.height - title1.height - parent.spacing
                                Repeater {
                                    model: [
                                        { source: "qrc:/img/king-white.svg", text: "王（K） King 头顶十字架的“短腿王子”，全局重点保护对象" },
                                        { source: "qrc:/img/queen-white.svg", text: "后（Q） Queen 头戴皇冠的“最强能力者”，威力最大的棋子" },
                                        { source: "qrc:/img/rook-white.svg", text: "车（R） Rook 城堡观状的棋子，横竖通行不受限" },
                                        { source: "qrc:/img/bishop-white.svg", text: "象（B） Bishop 戴着高帽子，斜线霸主" },
                                        { source: "qrc:/img/knight-white.svg", text: "马（N） Knight 马上的骑士，跳过棋子不受限" },
                                        { source: "qrc:/img/pawn-white.svg", text: "兵（P） Pawn “攻防小能手”，直走斜吃，只进不退" }
                                    ]
                                    Row {
                                        spacing: 10
                                        Image {
                                            source: modelData.source
                                            width: 60
                                            height: (intro.height - 120) / 6
                                        }
                                        Text {
                                            text: modelData.text
                                            width: intro.width - 110
                                            height: (intro.height-120)/6
                                            wrapMode: Text.Wrap
                                            verticalAlignment: Text.AlignVCenter
                                            color: "white"
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Rectangle {
                        color: "transparent"
                        Column {
                            anchors.fill: parent
                            spacing: 20
                            anchors.leftMargin: 25
                            Text {
                                id: title2
                                text: qsTr("棋子走法")
                                color: "white"
                                wrapMode: Text.Wrap
                                font.pointSize: 20
                            }
                            Grid {
                                columns: 1
                                spacing: 10
                                anchors.topMargin: 10
                                height: parent.height - title2.height - parent.spacing
                                Repeater {
                                    model: [
                                        { source: "qrc:/img/king-white.svg", text: "王一次只能行走一步，但所有方向（横、斜、直）都可以走。王被吃或者被将死意味着输棋" },
                                        { source: "qrc:/img/queen-white.svg", text: "皇后每步不限制格数，也不限制方向" },
                                        { source: "qrc:/img/rook-white.svg", text: "车横、竖直线都可以走，不可以斜线走棋。不限格数走棋，同样不能越子走棋。" },
                                        { source: "qrc:/img/knight-white.svg", text: "骑士可以竖走2格再向左或向右1格，也可以横走2格再向上或向下1格，形成一个字母L的形状，也可以无限制越过任何棋子" },
                                        { source: "qrc:/img/bishop-white.svg", text: "主教（象）只能沿着斜线走棋，不限格数，但不能越子" },
                                        { source: "qrc:/img/pawn-white.svg", text: "兵只能向前、不能后退，每次只能走1格。但兵走棋第一步时可以向前走1格或2格，之后每次只能1格。不能越子走棋" }
                                    ]
                                    Row {
                                        spacing: 10
                                        Image {
                                            source: modelData.source
                                            width: 60
                                            height: (intro.height - 120) / 6
                                        }
                                        Text {
                                            text: modelData.text
                                            width: intro.width - 110
                                            height: (intro.height-120)/6
                                            wrapMode: Text.Wrap
                                            verticalAlignment: Text.AlignVCenter
                                            color: "white"
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Rectangle {
                        color: "transparent"
                        Column {
                            anchors.fill: parent
                            spacing: 20
                            anchors.leftMargin: 25
                            Text {
                                id: title3
                                text: qsTr("特殊规则")
                                color: "white"
                                wrapMode: Text.Wrap
                                font.pointSize: 20
                                anchors.margins: 10 // 设置文字和边框的距离
                            }
                            Grid {
                                columns: 1
                                spacing: 10
                                anchors.topMargin: 10
                                height: parent.height - title3.height - parent.spacing
                                Repeater {
                                    model: [
                                        { text: "1.王车易位\n把王向车的方向横向移动两格，再把车直接移到王的另一侧，放在王的相邻一格。" },
                                        { text: "2.底线升变\n当已方兵到达对方底线的时候，兵需要升变为除了王之外的任何棋子。并且后面以升变后的棋子走棋规则走棋。这里需要注意，兵的升变是必须的，只能升变一次，且不可逆向降回为兵，不能变成王，也不能不变。" },
                                        { text: "3.吃过路兵\n当对方兵第一步走两格，我方兵与之并排时，则可以吃它，并且放置其前一格。" }
                                    ]
                                    Text {
                                        text: modelData.text
                                        width: intro.width - 50
                                        height: (intro.height - 120) / 3
                                        wrapMode: Text.Wrap
                                        verticalAlignment: Text.AlignVCenter
                                        color: "white"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
