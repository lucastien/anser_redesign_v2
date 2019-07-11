import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import "../js/CreateServerKeyButtonsComponent.js" as ButtonCreation

Dialog {
    id: root
    objectName: "tlistServerPickPopup"
    title: qsTr("Create server key")
    modal: true
    dim: false
    focus: true
    closePolicy: Popup.CloseOnEscape
    property alias serverName: serverKeyName.text
    property alias hostName: hostName.text
    property alias mounted: mountedCheck.checked    
    property bool editMode: false
//    property var serverKeys: []
    property Component keyLayout: null
    signal newServerKeyAdded(var key, var host, var mounted)
    signal serverKeyModified(var key, var host, var mounted)
    onAccepted:
    {
        console.log("Accepted")
        createOrUpdateServerKey()
    }



    ColumnLayout {
        anchors.fill: parent
        Item {
            Layout.preferredHeight: 4
        }
        RowLayout{
            Label {
                id: serverNameLabel
                text: qsTr("Key name:")
                horizontalAlignment: Text.AlignHCenter
            }
            TextField{
                id: serverKeyName
                placeholderText: qsTr("LCL")
                enabled: !editMode
            }
        }
        RowLayout{
            Label {
                id: hostLabel
                text: qsTr("Host Name:")
                horizontalAlignment: Text.AlignHCenter
            }
            TextField{
                id: hostName
                placeholderText: qsTr("type ip/host name")
            }
        }
        CheckBox{
            id: mountedCheck
            text: qsTr("Update mounted list")
        }

     }



    footer: DialogButtonBox {
        Button {
            objectName: "serverPickOkButton"
            text: qsTr("OK")

            DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
        }
        Button {
            objectName: "serverPickCancelButton"
            text: qsTr("Cancel")

            // https://bugreports.qt.io/browse/QTBUG-67168
            // TODO: replace this with DestructiveRole when it works (closes dialog)
            DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
        }
    }


    function createOrUpdateServerKey(){
        var mountedStr = ""
        if(editMode){
            serverKeyModified(serverKeyName.text, hostName.text, mountedCheck.checked)
//            var num = serverKeyLayout.children.length
//            for(var i = 0; i < num; i++){
//                if(serverKeyLayout.children[i].text === serverKeyName.text){
//                    serverKeyLayout.children[i].hostName = hostName.text
//                    serverKeyLayout.children[i].mounted = mountedCheck.checked
//                    mountedStr = mountedCheck.checked? "true":"false"
//                    storeServerKey(serverKeyName.text, hostName.text, mountedCheck.checked)
//                    break;
//                }
//            }
        }else{
            newServerKeyAdded(serverKeyName.text, hostName.text, mountedCheck.checked)
//            var text = serverKeyName.text
//            var host = hostName.text
//            var mounted = mountedCheck.checked
//            ButtonCreation.setHost(text, host, mounted)
//            ButtonCreation.createServerKeyButton()
//            mountedStr = mountedCheck.checked? "true":"false"
//            storeServerKey(serverKeyName.text, hostName.text, mountedStr)
        }
    }



}
