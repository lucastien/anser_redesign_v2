import QtQuick 2.12
import QtQuick.Controls 1.4 as C1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

import SortFilterProxyModel 1.0
import "../base" as Base



C1.TableView{
    id: diskInfoTableView
    Layout.fillWidth: true
    Layout.fillHeight: true
    property var currentDiskInfo
    model: SortFilterProxyModel{
        id: proxyModel
        source: diskModel
        diskIdFilterString: "*" + diskFilterBtn.text + "*"
        sgFilterString: "*" + sgFilterBtn.text + "*"
        legFilterString: "*" + legFilterBtn.text + "*"
        alphaFilterString: "*" + alPhaFilterBtn.text + "*"
    }
    //clip: true
    //ScrollBar.vertical: ScrollBar{}
    C1.TableViewColumn{
        role: "reel"
        title: qsTr("Reel")
        width: 50

    }
    C1.TableViewColumn{
        role: "diskId"
        title: qsTr("DiskID")
        width: 50
    }
    C1.TableViewColumn{
        role: "sg"
        title: qsTr("SG")
        width: 50
    }
    C1.TableViewColumn{
        role: "leg"
        title: qsTr("L")
        width: 30
    }
    C1.TableViewColumn{
        role: "unit"
        title: qsTr("Unit")
        width: 50
    }
    C1.TableViewColumn{
        role: "alpha"
        title: qsTr("Alpha")
        width: 70
    }
    itemDelegate: Item {
        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: "black"
            elide: styleData.elideMode
            text: styleData.value
            font.pixelSize: 15
        }
    }
    style: Base.AnserTableStyle{}
    onCurrentRowChanged:{
        currentDiskInfo = getCurrentDiskInfo()
    }

    function getCurrentDiskInfo(){
        return proxyModel.get(currentRow);
    }
}
