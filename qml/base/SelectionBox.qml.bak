import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "../js/AnserGlobal.js" as Global


Rectangle{
    id: selectionBox
    height: Global.ChannelBoxHeight
    color: mouseChan.containsMouse? Global.BoxHoverColor:Global.StripChartColor
    border.color: Global.StripChartBorder
    property alias text: switchBtn.text
    signal clicked(int mouseButton)
    signal wheeled(var wheel)

    Label{
        id: switchBtn
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
                selectionBox.clicked(mouse.button)
            }
            onWheel: {
                selectionBox.wheeled(wheel)
            }
        }

    }
}
