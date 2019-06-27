import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3

Rectangle{
    height: 50
    color: mouseChan.containsMouse? "red":"black"
    border.color: "white"
    property int currentChan: 3
    Label{
        id: switchBtn
        text: "CHAN " + currentChan
        font.bold: true
        font.pointSize: 12
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.fill: parent

        MouseArea{
            id: mouseChan
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            hoverEnabled: true
            onClicked: {
                if(mouse.button === Qt.RightButton){
                    currentChan--;
                }else if(mouse.button === Qt.LeftButton){
                    currentChan++;
                }
                if(currentChan >= 10)
                    currentChan = 0;
                else if(currentChan < 0)
                    currentChan = 9;
//                if(points){
//                    console.log("Switch to channel " + currentChan)
//                    drawStrip()
//                }
            }
        }

    }
}
