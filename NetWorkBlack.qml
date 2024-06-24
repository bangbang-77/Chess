import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MyNetWork 1.0
Item {

       Page {
           id:_black_page
           width: 450
           height: 800
           visible: true


           Ipv4{id:ip;
               send: _inToSend.text;
               onReciveChanged: {
               _black_page.splitAndConvert(ip.recive);
               console.log("ip4  "+ip.recive)
               chessBoard.setWhitePlayer()
               chessBoard.move(_inToRecive.num1,_inToRecive.num2,_inToRecive.num3,_inToRecive.num4)
               chessBoard.setBlackPlayer()
               }
           }



              TextField {
                      id: _textField
                      width: 220//parent.width
                      height: 50//parent.height
                      z:2
                      placeholderText: "请输入对方的ipv4地址..."
                      anchors.centerIn: parent

                      // 添加一个按钮来触发获取文本的操作
                      Button {
                          id: okButton
                          text: "OK"
                          anchors.top: _textField.bottom
                          anchors.right: _textField.right
                          onClicked: {
                              ip.myip4=_textField.text
                              console.log(ip.myip4)
                              chessBoard.setWaitPlayer()
                              parent.visible=false
                          }
                      }
                      Button {
                          id: cancelButton
                          text: "cancel"
                          anchors.top: _textField.bottom
                          anchors.left: _textField.left
                          onClicked: {
                              console.log(ip.send+"   "+ip.recive)
                              stackView.pop()

                          }
                      }
                  }

              property int fromX: -1
              property int fromY: -1
              property int toX: -1
              property int toY: -1

              Text{
                  id:_inToSend
                  //记录发送数据
                  visible: false
                  property int num1: -1
                  property int num2: -1
                  property int num3: -1
                  property int num4: -1
                  text:num1+" "+num2+" "+num3+" "+num4

              }
              function splitAndConvert(inputString) {
                      var numbers = inputString.split(" ")  // 将字符串分割成单个字符的数组
                      _inToRecive.num1=numbers[0];
                      _inToRecive.num2=numbers[1];
                      _inToRecive.num3=numbers[2];
                      _inToRecive.num4=numbers[3];
                  }


              Text {
                  id: _inToRecive
                  //记录处理后的接收数据
                  visible: false
                  property int num1: -1
                  property int num2: -1
                  property int num3: -1
                  property int num4: -1
              }

              Text {
                  id:show
                  text: "              收到了："+ip.recive+"  发送了："+ip.send
                  width: 220
                  height: 60
              }


           // 返回
           Row{

               Button {
                   text: "Back"
                   onClicked: stackView.pop() // 返回上一页
               }
           }
           // 棋盘
           Rectangle {
               id: board
               width: parent.width
               height: parent.width
               anchors.centerIn: parent
               z: -1

               Grid {
                   rows: 8
                   columns: 8
                   anchors.horizontalCenter: parent.horizontalCenter
                   anchors.verticalCenter: parent.verticalCenter

                   Repeater {
                       model: 8 * 8

                       Rectangle {
                           width: board.width / 8
                           height: board.height / 8
                           color: {
                               var cols = index % 8 //列
                               var rows = (index - cols) / 8 //行 (减去cols再除，得到整数)
                               return ((rows + cols) % 2 === 0) ? "white" : "gray"
                           }
                       }
                   }
               }
           }



           // 显示可以走的位置
           function getMoves(x, y) {
               var movelist = chessBoard.possibleMoves(x, y);

               for(var i = 0; i < movelist.length; i++) {
                   console.log("可走位置：" + movelist[i]);
                   if(gridRep.itemAt(movelist[i]).children.length > 0) {
                       gridRep.itemAt(movelist[i]).children[1].visible = true
                       gridRep.itemAt(movelist[i]).children[1].z = 1
                   }
               }
           }

           // 清除可以走的位置
           function clearColor(x, y) {
               var movelist = chessBoard.possibleMoves(x, y);

               for(var i = 0; i < movelist.length; i++) {
                   console.log("清除color：" + movelist[i]);
                   // rec.visible = false
                   if(gridRep.itemAt(movelist[i]).children.length > 0) {
                       gridRep.itemAt(movelist[i]).children[1].visible = false
                       gridRep.itemAt(movelist[i]).children[1].z = -1
                   }
               }
           }


           Grid {
               id: grid
               rows: 8
               columns: 8
               anchors.horizontalCenter: parent.horizontalCenter
               anchors.verticalCenter: parent.verticalCenter
               Repeater {
                   id: gridRep
                   model: chessBoard

                   Image {
                       id: girdImg
                       width: board.width / 8
                       height: board.height / 8
                       fillMode: Image.PreserveAspectFit
                       source: model.pieceImg !== undefined ? model.pieceImg : ""

                       Text {
                           z: 1
                           text: index
                       }

                       Rectangle {
                           id: rec
                           anchors.fill: parent
                           color: "lightgreen"
                           opacity: 0.8
                           visible: false
                           z: -1

                           TapHandler {
                               id:taphandler

                               onTapped: {

                                   _black_page.clearColor(_black_page.fromX, _black_page.fromY)
                                   _black_page.toX = index % 8
                                   _black_page.toY = (index - _black_page.toX) / 8
                                    _inToSend.num3 = _black_page.toX
                                    _inToSend.num4 = _black_page.toY
                                   console.log(".fromX:" + _black_page.fromX + " fromY:" + _black_page.fromY+" toX:"+_black_page.toX+" toY:"+_black_page.toY);
                                   chessBoard.move(_black_page.fromX, _black_page.fromY, _black_page.toX, _black_page.toY)
                                    ip.sendMessage()
                                    console.log("发送："+ip.send)
                                   chessBoard.setWaitPlayer()
                               }
                           }
                       }

                       TapHandler {
                           id:taphandler1
                           onTapped: {
                               console.log("tap1")
                                _black_page.clearColor(_black_page.fromX, _black_page.fromY)
                               _black_page.fromX = index % 8
                               _black_page.fromY = (index - _black_page.fromX) / 8
                                _inToSend.num1 = _black_page.fromX
                                _inToSend.num2 = _black_page.fromY
                                _black_page.getMoves(_black_page.fromX, _black_page.fromY);
                           }
                       }
                   }
               }
           }
    }
}
