import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3


ListView{
    id: listView
    Layout.fillWidth: true
    Layout.fillHeight: true
    contentWidth: headerItem.width
    clip: true
    focus: true

    property int itemHeight: 20
    property var headerNameList: null

    header: Rectangle{
        color: "lightblue"
        width: parent.width; height: 20
        function itemAt(index) { return headerRepeater.itemAt(index) }
        Row {
            width: parent.width; height: 20
            spacing: 1
            Repeater{
                id: headerRepeater
                model: listView.headerNameList
                Label{
                    text: modelData
                    font.bold: true
                    Layout.alignment: Qt.AlignVCenter|Qt.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    height: itemHeight
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
    function columnWidth(index) { return listView.headerItem.itemAt(index).width }

    property var roles: null

    delegate: Rectangle{
        id: itemIn
        width: parent.width
        height: itemHeight
        property int currentIndex: index
        Row {
            id: rowId
            anchors.fill: parent
            spacing: 1
            Repeater{
                model: listView.roles
                Loader{
                    property int modelIndex: itemIn.currentIndex
                    property int headerIndex: index
                    property string data: modelData
                    sourceComponent: itemComponent
                }
            }
        }
    }

    highlight: highlightBar
    highlightFollowsCurrentItem: false

    Component{
        id: itemComponent
        Label{
            Layout.alignment: Qt.AlignVCenter|Qt.AlignHCenter
            width: columnWidth(headerIndex)
            text: data
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    listView.currentIndex = modelIndex
                }
            }
        }
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
