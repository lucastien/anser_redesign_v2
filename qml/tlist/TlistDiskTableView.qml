import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3

import SortFilterProxyModel 1.0
import "../base"

AnserTableView{
    id: diskTableView
    Layout.fillWidth: true
    Layout.fillHeight: true

    headerNameList: [qsTr("Reel"), qsTr("DiskID"), qsTr("SG"), qsTr("L"), qsTr("Unit"), qsTr("Alpha")]
    property var currentDiskInfo
    model: SortFilterProxyModel{
        id: proxyModel
        source: diskModel
        diskIdFilterString: "*" + diskFilterBtn.text + "*"
        sgFilterString: "*" + sgFilterBtn.text + "*"
        legFilterString: "*" + legFilterBtn.text + "*"
        alphaFilterString: "*" + alPhaFilterBtn.text + "*"
    }

    delegate: TableTextContent{
        currentIndex: index
        width: parent.width; height: 20
        content: [reel, diskId, sg, leg, unit, alpha]
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

