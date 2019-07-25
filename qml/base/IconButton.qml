import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "../js/AnserGlobal.js" as Global
import "qrc:/Icon.js" as MdiFont

Rectangle{
    id: iconButton
    height: Global.ChannelBoxHeight
    color: mouseChan.containsMouse? Global.BoxHoverColor:Global.StripChartColor
    border.color: Global.StripChartBorder
    property alias text: switchBtn.text
    signal clicked(int mouseButton)
    signal wheeled(var wheel)
    property alias mouseHover: mouseChan.containsMouse
    property alias mouseX: mouseChan.mouseX
    property alias mouseY: mouseChan.mouseY

    Label{
        id: switchBtn
        font.bold: true
        font.pointSize: 10
        font.family: "Material Design Icons"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.fill: parent

        MouseArea{
            id: mouseChan
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            hoverEnabled: true
            onClicked: {
                iconButton.clicked(mouse.button)
            }
            onWheel: {
                iconButton.wheeled(wheel)
            }
        }

    }
}
