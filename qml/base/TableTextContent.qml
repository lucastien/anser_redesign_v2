import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3

Rectangle{
    id: tableTextContent
    property int currentIndex
    property var content: []
    property var columnWidthArr: []
    signal itemClicked(int currentItemIndex)
    Row {
        id: rowId
        anchors.fill: parent
        spacing: 1
        Repeater{
            model: tableTextContent.content
            Label{
                Layout.alignment: Qt.AlignVCenter|Qt.AlignHCenter
                width: columnWidthArr === null || index >=  columnWidthArr.length ? 50: columnWidthArr[index]
                text: modelData
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
    }
}


