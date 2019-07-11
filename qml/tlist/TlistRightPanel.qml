import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import TubeHandler 1.0
import "../js/CreateServerKeyButtonsComponent.js" as ButtonCreation
ColumnLayout{
    Layout.fillWidth: true
    Layout.rightMargin: 10
    Layout.topMargin: 2
    spacing:  0

    property var diskInfo

    //Properties for setting server keys
    property var serverKeys: ["LCL,localhost,true"]
    property string concatServerList: "" //dirty workaround by using string for settings
                                     //because settings does not work on array type

    property TubeHandler tube
    onConcatServerListChanged: {
        serverKeys = concatServerList.split("|")
    }


    Component.onDestruction: {
       concatServerList = serverKeys.join("|")
    }

    Component.onCompleted: {
        createServerKeyButtons(serverKeys)
    }




    Shortcut{
        sequence: "Ctrl+B"
        onActivated: getIndexBtn.clicked()
    }

    Button{
        text: "UNLOCK OPTICAL TLIST"
        Layout.fillWidth: true
    }

    Button{
        id: getReelBtn
        text: "GET REEL"
        Layout.fillWidth: true
        state: "off"
        enabled: diskTableView.count > 0
    }

    Button{
        id: getIndexBtn
        text: "GET INDEX"
        Layout.fillWidth: true
        enabled: diskTableView.count > 0
        states: [
            State {
                name: "on";
                PropertyChanges{ target: getIndexBtn; flat: true; highlighted: true }
            },
            State {
                name: "off";
                PropertyChanges{ target: getIndexBtn; flat: false; highlighted: false }
            }
        ]
        onClicked:{
            getReelInfo()
            toggle()
        }
        function toggle(){
            if(state == "on"){
                state = "off"
            }else{
                state = "on"
            }
        }
    }
    Button{
        text: "MOUNTED LIST"
        Layout.fillWidth: true
    }


    RowLayout{
        id: serverKeyLayout
    }


    TlistDiskTableView{
        id: diskTableView
    }

    ColumnLayout{
        Layout.fillWidth: true
        Layout.fillHeight: true
        RowLayout{
            spacing: 5
            Label{
                text: qsTr("DISK")
            }
            TextField{
                id: diskFilterBtn
                placeholderText: "ID"
                maximumLength: 5
                Layout.maximumWidth: 50
            }
            Label{
                text: qsTr("SG")
            }
            TextField{
                id: sgFilterBtn
                placeholderText: "SG"
                maximumLength: 2
                Layout.maximumWidth: 20
            }
            Label{
                text: qsTr("ALPHA")
            }
            TextField{
                id: alPhaFilterBtn
                placeholderText: "ALP"
                maximumLength: 5
                Layout.maximumWidth: 50
            }
            Label{
                text: qsTr("L")
            }
            TextField{
                id: legFilterBtn
                placeholderText: "L"
                maximumLength: 1
                Layout.maximumWidth: 15
            }
        }
    }


    Connections{
        target: serverPickKeyDiag
        onNewServerKeyAdded: {
            createServerKeyButton(key, host, mounted)
            storeServerKey(key, host, mounted)
        }
        onServerKeyModified: {
            updateServerKey(key, host, mounted)
            storeServerKey(key, host, mounted)
        }
    }



    function createServerKeyButtons(serverKeys)
    {
        var i;
        for(i = 0; i < serverKeys.length; i++){
            var keys = serverKeys[i].split(",")
            console.log("Server key: " + serverKeys[i])
            if(keys !== null && keys.length === 3){
                var key = keys[0]
                var hostName = keys[1]
                var mounted = keys[2] === "true"? true:false
                createServerKeyButton(key, hostName, mounted)
            }
        }
    }

    function createServerKeyButton(key, host, mounted){
        ButtonCreation.setHost(key, host, mounted)
        var button = ButtonCreation.createServerKeyButton();
        button.mountedAction.connect(updateMountedServer);
        button.editTriggered.connect(editServerKeyAction)
        button.deleteTriggered.connect(deleteServerKeyAction)
    }


    function deleteServerKeyAction(button, key){
        removeServerKey(key)
        button.destroy()
    }

    function editServerKeyAction(key, host, mounted){
        serverPickKeyDiag.editMode = true
        serverPickKeyDiag.serverName = key
        serverPickKeyDiag.hostName = host
        serverPickKeyDiag.mounted = mounted
        serverPickKeyDiag.open()
    }

    function updateMountedServer(hostName, mounted){
        tlistController.updateDiskModel(hostName)
    }


    function storeServerKey( key, host, mount){
        var isNewKey = true;
        for(var i = 0; i < serverKeys.length; i++){
            var keys = serverKeys[i].split(",")
            if(keys !== null && keys.length === 3 && keys[0] === key){
                isNewKey = false; //This is an old server key. Need to update
                keys[1] = host
                keys[2] = mount.toString()
                serverKeys[i] = keys.join(",")
                break;
            }
        }
        if(isNewKey){

            var keyStr = key + "," + host + "," + mount.toString()
            serverKeys.push(keyStr);
        }
    }

    function updateServerKey(key, host, mounted){
        var num = serverKeyLayout.children.length
        for(var i = 0; i < num; i++){
            if(serverKeyLayout.children[i].text === key){
                serverKeyLayout.children[i].hostName = host
                serverKeyLayout.children[i].mounted = mounted
                break;
            }
        }
    }

    function removeServerKey(key){
        var index = -1
        for(var i = 0; i < serverKeys.length; i++){
            var keys = serverKeys[i].split(",")
            if(keys !== null && keys[0] === key){
                index = i;
                break;
            }
        }

        if( index !== -1 && index < serverKeys.length){
            rightPanel.serverKeys.splice(index, 1)
        }
    }

    function getReelInfo(){
        diskInfo = diskTableView.currentDiskInfo
        tlistController.getReel(diskInfo);
    }
}

