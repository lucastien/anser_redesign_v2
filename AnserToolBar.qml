import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.3

ToolBar {
    id: anserToolBar
    RowLayout{
        anchors.fill: parent
        spacing: 5
        ToolButton{
            id: tlistLaunchBtn
            text: qsTr("TLIST")
            Layout.alignment: Qt.AlignLeft
            highlighted: mouseArea.containsMouse? true: false
            onClicked: {console.log("Tlist button was clicked")}
            MouseArea{
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
            }
        }
        Item {
            Layout.fillWidth: true
        }
    }
}
