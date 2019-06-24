import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3

ToolButton{
    id: button
    highlighted: mouseArea.containsMouse? true: false
    MouseArea{
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: button.clicked()
    }
}
