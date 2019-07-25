import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3

import "../base"

AnserTableView{
    id: tlistTableView

    Layout.preferredWidth: 450
    Layout.fillHeight: true

    headerNameList: [qsTr("Ent"), qsTr("Row"), qsTr("Col"), qsTr("Time"), qsTr("Length"), qsTr("QA"), qsTr("RPT")]

    property string tubeFileName: ""

    model: reelModel

    delegate: TableTextContent{
        currentIndex: index
        width: parent.width; height: 20
        content: [entry, row, col, time, length, qa, rpt]
        columnWidthArr: getColumnWidth()
        onItemClicked: {
            tlistTableView.currentIndex = currentItemIndex
        }
        function getColumnWidth(){
            var widthArr = []
            for(var i = 0; i < tlistTableView.headerNameList.length; i++){
                widthArr.push(tlistTableView.columnWidth(i))
            }
            return widthArr;
        }

    }

    onCurrentIndexChanged:{
        tubeFileName = reelModel.get(currentIndex)
        console.log("Tube file name" + tubeFileName)
    }

}

