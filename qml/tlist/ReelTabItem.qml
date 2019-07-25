import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import TubeHandler 1.0
import SortFilterProxyModel 1.0
import "../js/CreateServerKeyButtonsComponent.js" as ButtonCreation
import "../base"
ColumnLayout{
    Layout.fillWidth: true
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


    Shortcut{
        sequence: "Ctrl+B"
        onActivated: getIndexBtn.clicked()
    }


    Button{
        id: getReelBtn
        text: "GET REEL"
        Layout.fillWidth: true
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
            toggle()
        }
        function toggle(){
            if(state == "on"){
                state = "off"
            }else{
                state = "on"
                getReelInfo()
                tabBar.currentIndex = 0;
            }
        }
    }

    AnserTableView{
        id: diskTableView
        Layout.fillWidth: true
        height: 200

        headerNameList: [qsTr("Cal"), qsTr("L"), qsTr("U"), qsTr("Sg"), "Alp", qsTr("Id")]
        property var currentDiskInfo
        model: SortFilterProxyModel{
            id: proxyModel
            source: diskModel
            legFilterString: "*" + legFilterBtn.text + "*"
            reelFilterString: "*" + reelFilterBtn.text + "*"
            diskIdFilterString: "*" + diskFilterBtn.text + "*"
            sgFilterString: "*" + sgFilterBtn.text + "*"
            unitFilterString: "*" + unitFilterBtn.text + "*"
            alphaFilterString: "*" + alPhaFilterBtn.text + "*"
        }

        delegate: TableTextContent{
            currentIndex: index
            width: parent.width; height: 20
            content: [reel, leg, unit, sg, alpha, diskId]
            //color: "black"
            columnWidthArr: getColumnWidth()
            onItemClicked: {
                diskTableView.currentIndex = currentItemIndex
            }
            function getColumnWidth(){
                var widthArr = []
                for(var i = 0; i < diskTableView.headerNameList.length; i++){
                    widthArr.push(diskTableView.columnWidth(i))
                }
                return widthArr;
            }

        }

        onCurrentIndexChanged:{
            currentDiskInfo = proxyModel.get(currentIndex)
        }
    }
    RowLayout{
        Layout.fillWidth: true
        spacing: 5
        Label{
            text: qsTr("REEL")
        }
        TextField{
            id: reelFilterBtn
            placeholderText: "ID"
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
        Label{
            text: qsTr("U")
        }
        TextField{
            id: unitFilterBtn
            placeholderText: "U"
            maximumLength: 1
            Layout.maximumWidth: 15
        }
        Item{
            Layout.fillWidth: true
        }
    }

    RowLayout{
        Layout.fillWidth: true
        spacing: 5
        Label{
            text: qsTr("SG")
        }
        TextField{
            id: sgFilterBtn
            placeholderText: "SG"
            maximumLength: 5
            Layout.maximumWidth: 20
        }
        Label{
            text: qsTr("ALP")
        }
        TextField{
            id: alPhaFilterBtn
            placeholderText: "ALP"
            maximumLength: 1
            Layout.maximumWidth: 30
        }
        Label{
            text: qsTr("ID")
        }
        TextField{
            id: diskFilterBtn
            placeholderText: "ID"
            maximumLength: 1
            Layout.maximumWidth: 30
        }
        Item{
            Layout.fillWidth: true
        }
    }

    RowLayout{
        id: serverKeyLayout
    }

    Item {
        Layout.fillHeight: true
        Layout.fillWidth: true
    }

}

