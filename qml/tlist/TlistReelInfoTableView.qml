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

//C1.TableView{
//    id: tlistTableView
//    Layout.preferredWidth: 450
//    Layout.fillHeight: true
//    property var currentRowInfo
//    property string tubeFileName: ""
//    model: reelModel
//    C1.TableViewColumn{
//        role: "indexed"
//        title: qsTr("I")
//        width: 25
//        delegate: C1.CheckBox{
//            checked: styleData.value
//            anchors.baseline: parent.verticalCenter
//            anchors.centerIn: parent
//            scale: 0.8
//            visible: true
//            anchors.left: parent.left
//            onCheckedChanged: {
//                reelModel.markIndexed(styleData.row, styleData.column, checked)
//                tlistTableView.selection.select(styleData.row)
//                tlistTableView.selection.deselect(styleData.row)
//            }
//            style: CheckBoxStyle{
//                indicator: Rectangle {
//                    implicitWidth: 16
//                    implicitHeight: 16
//                    radius: 3
//                    border.color: control.activeFocus ? "darkblue" : "gray"
//                    border.width: 1
//                    Rectangle {
//                        visible: control.checked
//                        color: "#555"
//                        border.color: "#333"
//                        radius: 1
//                        anchors.margins: 4
//                        anchors.fill: parent
//                    }
//                }
//            }
//        }
//    }
//    C1.TableViewColumn{
//        role: "entry"
//        title: qsTr("Ent")
//        width: 50
//    }
//    C1.TableViewColumn{
//        role: "sg"
//        title: qsTr("SG")
//        width: 50
//    }
//    C1.TableViewColumn{
//        role: "row"
//        title: qsTr("Row")
//        width: 50
//        delegate: Item {
//            Text {
//                anchors.verticalCenter: parent.verticalCenter
//                color: styleData.value === "999" ? "darkred": "black"
//                elide: styleData.elideMode
//                text: styleData.value
//                font.pixelSize: 14
//            }
//        }
//    }
//    C1.TableViewColumn{
//        role: "col"
//        title: qsTr("Col")
//        width: 50
//        delegate: Item {
//            Text {
//                anchors.verticalCenter: parent.verticalCenter
//                color: styleData.value === "999" ? "darkred": "black"
//                elide: styleData.elideMode
//                text: styleData.value
//                font.pixelSize: 14
//            }
//        }
//    }
//    C1.TableViewColumn{
//        role: "time"
//        title: qsTr("Time")
//        width: 50
//    }
//    C1.TableViewColumn{
//        role: "length"
//        title: qsTr("Length")
//        width: 50
//    }
//    C1.TableViewColumn{
//        role: "qa"
//        title: qsTr("QA")
//        width: 50
//    }
//    C1.TableViewColumn{
//        role: "rpt"
//        title: qsTr("RPT")
//        width: 50
//    }
//    style: Base.AnserTableStyle{}
//    itemDelegate: Item {
//        Text {
//            anchors.verticalCenter: parent.verticalCenter
//            color: "black"
//            elide: styleData.elideMode
//            text: styleData.value
//            font.pixelSize: 14
//        }
//    }
//    rowDelegate: Rectangle {
//        id: rowRect
//        height: 25
//        z: 2
//        SystemPalette {
//            id: systemPalette
//            colorGroup: SystemPalette.Active
//        }
//        color: {
//            if(styleData.row && reelModel){
//                var object = reelModel.get(styleData.row)

//                var baseColor = styleData.alternate ? systemPalette.alternateBase : systemPalette.base
//                if(object["indexed"]){
//                    baseColor = "#ABD713"
//                }
//                return styleData.selected ? "red" : baseColor
//            }
//            return systemPalette.base
//        }


//        ToolTip{
//            id: control
//            text: qsTr("A descriptive tool tip of what the button does")
//            delay: 1000
//            timeout: 5000
//            contentItem: Item{
//                ColumnLayout{
//                    Text {
//                        text: control.text
//                        font.pixelSize: 15
//                        color: "white"
//                    }
//                    RowLayout{
//                        Text {
//                            text: "Row: XXX"  + "   Col:YYY "
//                            font.pixelSize: 18
//                            color: "darkgreen"
//                        }
//                    }
//                }

//            }
//            background: Rectangle {
//                border.color: "#21be2b"
//                color: "#D76913"
//            }
//            visible: styleData.selected
//        }
//    }

//    onCurrentRowChanged: {
//        tubeFileName = reelModel.get(currentRow)
//        console.log("Tube file name" + tubeFileName)
//    }
//}
