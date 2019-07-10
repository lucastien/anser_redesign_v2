import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3


ListView{
    id: listView
    contentWidth: headerItem.width
    clip: true
    focus: true

    property int itemHeight: 20
    property var headerNameList: null
    headerPositioning: ListView.OverlayHeader
    header: Rectangle{
        color: "lightblue"
        width: parent.width; height: itemHeight
        z: 2
        function itemAt(index) { return headerRepeater.itemAt(index) }
        Row {
            width: parent.width; height: itemHeight
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
    function columnWidth(index) {
        return listView.headerItem.itemAt(index).width
    }

    highlight: highlightBar
    highlightFollowsCurrentItem: false

    Component {
        id: highlightBar
        Rectangle {
            width: listView.width; height: 20
            color: "red"
            y: listView.currentItem.y
        }
    }
}
