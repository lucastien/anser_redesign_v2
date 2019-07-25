import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import TubeHandler 1.0
import SortFilterProxyModel 1.0
import "../js/CreateServerKeyButtonsComponent.js" as ButtonCreation
import "../base"
import "qrc:/Icon.js" as MdiFont



ColumnLayout{
    Layout.fillWidth: true
    spacing:  0

    AnserTableView{
        id: tlistTableView
        Layout.fillWidth: true
        Layout.fillHeight: true

        headerNameList: [qsTr("Ent"), qsTr("Row"), qsTr("Col"), qsTr("Flag")]

        property string tubeFileName: ""
        model: reelModel
        delegate: Rectangle{
            id: tableTextContent
            property int currentIndex: index
            width: parent.width; height: 20
            property var content: [entry, row, col]
            property var columnWidthArr: getColumnWidth()
            signal itemClicked(int currentItemIndex)
            //color: "black"
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

            Row {
                id: rowId
                anchors.fill: parent
                spacing: 1
                Repeater{
                    model: tableTextContent.content
                    Text{
                        Layout.alignment: Qt.AlignVCenter|Qt.AlignHCenter
                        width: columnWidthArr === null || index >=  columnWidthArr.length ? 50: columnWidthArr[index]
                        //height: 20
                        text: modelData
                        color: modelData == "999"? "red": "white"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                itemClicked(currentIndex)
                            }
                        }
                    }
                }

                //Marked flag
                Text{
                    Layout.alignment: Qt.AlignVCenter|Qt.AlignHCenter
                    width: columnWidthArr === null || index >=  columnWidthArr.length ? 50: columnWidthArr[index]
                    text: MdiFont.Icon.flag
                    //height: 20
                    color: "green"
                    font.family: "Material Design Icons"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideLeft
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            itemClicked(currentIndex)
                        }
                    }
                }
            }
        }
        onCurrentIndexChanged:{
            tubeFileName = reelModel.get(currentIndex)
            console.log("Tube file name" + tubeFileName)
        }

    }
}
