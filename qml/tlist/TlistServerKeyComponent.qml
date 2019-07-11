import QtQuick 2.12
import QtQuick.Controls 2.12

Button{
    id: button
    property string hostName: "unknow"
    property bool mounted: false
    signal deleteTriggered(var button, var key)
    signal editTriggered(var key, var host, var mounted)
    signal mountedAction(var hostName, var mounted)
    ToolTip {
        text: qsTr("Host Name: ") + parent.hostName
        delay: 1000
        timeout: 5000
        visible: parent.hovered
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            if (mouse.button === Qt.RightButton){
                contextMenu.popup()
            }else{
                mountedAction(parent.hostName, parent.mounted)
            }
        }

        Menu {
            id: contextMenu
            MenuItem {
                text: "Edit"
                onTriggered: {
                    button.editTriggered(button.text, button.hostName, button.mounted)
                }
            }
            MenuItem {
                text: "Delete"
                onTriggered:{
                    button.deleteTriggered(button, button.text)
                }
            }
        }
    }


}

