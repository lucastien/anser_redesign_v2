import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3

import SortFilterProxyModel 1.0


ListView{
    id: diskInfoTableView
    Layout.fillWidth: true
    Layout.fillHeight: true
    property var currentDiskInfo
    contentWidth: headerItem.width
    //flickableDirection: Flickable.HorizontalAndVerticalFlick
    clip: true
    focus: true
    model: SortFilterProxyModel{
        id: proxyModel
        source: diskModel
        diskIdFilterString: "*" + diskFilterBtn.text + "*"
        sgFilterString: "*" + sgFilterBtn.text + "*"
        legFilterString: "*" + legFilterBtn.text + "*"
        alphaFilterString: "*" + alPhaFilterBtn.text + "*"
    }

    header: Rectangle{
        color: "lightblue"
        width: parent.width; height: 20
        function itemAt(index) { return headerRepeater.itemAt(index) }
        Row {
            width: parent.width; height: 20
            spacing: 1
            Repeater{
                id: headerRepeater
                model: [qsTr("Reel"), qsTr("DiskID"), qsTr("SG"), qsTr("L"), qsTr("Unit"), qsTr("Alpha")]

                Label{
                    text: modelData
                    font.bold: true
                    Layout.alignment: Qt.AlignVCenter|Qt.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    height: 20
                    color: "black"
                    width: implicitWidth + 10
                    background: Rectangle {
                        anchors.fill: parent
                        color: "lightblue"
                    }
                }
            }
        }
    }
    function columnWidth(index) { return diskInfoTableView.headerItem.itemAt(index).width }

    delegate: Rectangle{
        id: itemIn
        width: parent.width
        height: 20
        property int currentIndex: index
        Row {
            id: rowId
            anchors.fill: parent
            spacing: 1
            Repeater{
                model: [reel, diskId, sg, leg, unit, alpha]
                Label{
                    Layout.alignment: Qt.AlignVCenter|Qt.AlignHCenter
                    width: columnWidth(index)
                    text: modelData
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            diskInfoTableView.currentIndex = itemIn.currentIndex
                        }
                    }
                }
            }
        }

    }
    highlight: highlightBar
    highlightFollowsCurrentItem: false

    onCurrentIndexChanged:{
        currentDiskInfo = proxyModel.get(currentIndex)
    }


    Component {
        id: highlightBar
        Rectangle {
            width: diskInfoTableView.width; height: 20
            color: "red"
            y: diskInfoTableView.currentItem.y
        }
    }
}
