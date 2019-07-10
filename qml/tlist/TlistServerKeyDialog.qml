import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12


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
    property var serverKeys: []

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
            var num = serverKeyLayout.children.length
            for(var i = 0; i < num; i++){
                if(serverKeyLayout.children[i].text === serverKeyName.text){
                    serverKeyLayout.children[i].hostName = hostName.text
                    serverKeyLayout.children[i].mounted = mountedCheck.checked
                    mountedStr = mountedCheck.checked? "true":"false"
                    storeServerKey(serverKeyName.text, hostName.text, mountedCheck.checked)
                    break;
                }
            }
        }else{
            var button = keyButton.createObject(serverKeyLayout)
            button.text = serverKeyName.text
            button.hostName = hostName.text
            button.mounted = mountedCheck.checked
            mountedStr = mountedCheck.checked? "true":"false"
            storeServerKey(serverKeyName.text, hostName.text, mountedStr)
        }
    }

    function storeServerKey( key, host, mount){
        var isNewKey = true;
        for(var i = 0; i < serverKeys.length; i++){
            var keys = serverKeys[i].split(",")
            if(keys !== null && keys.length === 3 && keys[0] === key){
                isNewKey = false; //This is an old server key. Need to update
                keys[1] = host
                keys[2] = mount
                serverKeys[i] = keys.join(",")
                break;
            }
        }
        if(isNewKey){
            var keyStr = key + "," + host + "," + mount
            serverKeys.push(keyStr);
        }
        rightPanel.serverKeys = serverKeys
    }

}
