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
                width: parent.parent.width*0.9
                height:parent.parent.height*0.65
                border.color: "blue"
                color: "transparent"
                anchors.left: parent.left;
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                SwipeView {
                    id: view
                    anchors.fill: parent
                    Rectangle {

                        color: "transparent"

                        Text {
                            text: qsTr("游戏规则

棋盘：国际象棋的棋盘是一个8x8的方格棋盘，由64个交替的黑色和白色方格组成。
棋子：每方有16枚棋子，包括1个国王、1个皇后、2个车、2个马、2个象和8个兵。

棋子的移动规则

国王（K）：可以移动到相邻的方格，包括斜向移动。
皇后（Q）：可以横向、纵向或斜向移动，没有距离限制。
车（R）：可以横向或纵向移动，没有距离限制。
马（N）：走“日”字形，即先横向或纵向移动2格，再斜向移动1格。
象（B）：走斜线，没有距离限制，但不能越子。
兵（P）：初次移动可以向前走1格或2格，之后只能向前走1格。吃子时，兵走斜线。

游戏目标

将军（Check）：一方的国王被对方威胁，即处于将军状态。
将死（Checkmate）：一方的国王被将军，且无法通过任何合法移动来解除将军状态，此时游戏结束，对方获胜。

特殊规则

吃过路兵（En passant）：当一方的兵在其初始移动后，横向经过对方的兵旁边时，对方的兵可以立即吃掉它。
王车易位（Castling）：在特定条件下，国王和车可以同时移动，进行王车易位。
升变（Promotion）：当兵到达对方底线时，可以升变为皇后、车、马或象。

游戏流程

开局：双方玩家从标准开局开始。
中局：玩家交替移动棋子，尝试控制棋盘、攻击对方国王并保护自己的国王。
残局：棋子数量减少，通常进入决定性的阶段。
结束：直到出现将死、和棋或双方同意和棋。")
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
                            text: qsTr("策略和技巧

国际象棋是一种需要深度思考和策略规划的游戏。玩家需要考虑棋子的位置、可能的威胁、未来的移动和对手的策略。游戏中有许多著名的开局、中局和残局策略，玩家需要不断学习和实践以提高自己的水平。

国际象棋组织

国际象棋有多个国际和国家级的组织，其中最著名的是国际象棋联合会（FIDE）。FIDE负责组织国际象棋的世界锦标赛和其他重要赛事，并负责制定和更新国际象棋的规则。

竞技国际象棋

国际象棋是一种竞技运动，拥有自己的等级分系统。顶尖的国际象棋选手会参加各种国际比赛，争夺世界冠军头衔。国际象棋比赛通常采用时间控制，以确保游戏的公平性和效率。

文化影响

国际象棋不仅是一种游戏，也是一种文化现象。它出现在文学、电影、艺术和音乐中，被视为智力训练和策略思维的象征。许多国家和地区都有自己的国际象棋传统和历史。

国际象棋是一种深受人们喜爱的游戏，它不仅提供了娱乐，还有助于培养逻辑思维、决策能力和耐心。无论是作为业余爱好还是竞技运动，国际象棋都有着丰富的内涵和无限的魅力。")
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
                            text: qsTr("
    ")
                            anchors.fill: parent
                            color: "white"
                            wrapMode: Text.Wrap
                            font.pointSize: 10
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
        }
    }
}
