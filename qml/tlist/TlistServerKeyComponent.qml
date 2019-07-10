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

        function removeServerKey(key){
            var index = -1
            for(var i = 0; i < rightPanel.serverKeys.length; i++){
                var keys = rightPanel.serverKeys[i].split(",")
                if(keys !== null && keys[0] === key){
                    index = i;
                    break;
                }
            }

            if( index !== -1 && index < rightPanel.serverKeys.length){
                rightPanel.serverKeys.splice(index, 1)
            }
        }
    }
}
