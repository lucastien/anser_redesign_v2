import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4

Component{
    TableViewStyle{
        headerDelegate: Rectangle{
            height: textItem.implicitHeight * 1.5
            width: textItem.implicitWidth * 1.2
            color: "lightsteelblue"
            Text {
                id: textItem
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                anchors.leftMargin: 12
                text: styleData.value
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideLeft
                color: textColor
                renderType: Text.NativeRendering
                font.pixelSize: 14
            }

            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 1
                anchors.topMargin: 1
                width: 1
                color: "#ccc"
            }
        }
    }
}
