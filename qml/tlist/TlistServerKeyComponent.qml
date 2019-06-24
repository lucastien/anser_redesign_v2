import QtQuick 2.12
import QtQuick.Controls 2.12

Component{
    Button{
        id: button
        property string hostName: "unknow"
        property bool mounted: false
        ToolTip{
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
                    tlistController.updateDiskModel(parent.hostName)
                }
            }

            Menu {
                id: contextMenu
                MenuItem {
                    text: "Edit"
                    onTriggered: {
                        serverPickKeyDiag.editMode = true
                        serverPickKeyDiag.serverName = button.text
                        serverPickKeyDiag.hostName = button.hostName
                        serverPickKeyDiag.mounted = button.mounted
                        serverPickKeyDiag.open()
                    }
                }
                MenuItem {
                    text: "Delete"
                    onTriggered:{
                        removeServerKey(button.text)
                        button.destroy()
                    }
                }
            }
        }
    }
}
