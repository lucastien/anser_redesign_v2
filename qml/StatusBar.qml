import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.Window 2.12


Pane {
    id: statusBarPane
    objectName: "statusBarPane"
    contentHeight: statusBarLayout.implicitHeight
    padding: 6

    property int dpt: -1

    Rectangle {
        parent: statusBarPane.background
        width: parent.width
        height: 1
        color: "#444"
    }

    Rectangle {
        parent: statusBarPane.background
        x: parent.width - 1
        width: 1
        height: parent.height
        color: "#444"
    }

    RowLayout {
        id: statusBarLayout
        objectName: "statusBarLayout"
        width: parent.width
        visible: true
        anchors.verticalCenter: parent.verticalCenter

        Label {
            id: pointerIconLabel
            text: "\uf245"
            font.family: "FontAwesome"
            font.pixelSize: Qt.application.font.pixelSize * 1.2
            horizontalAlignment: Label.AlignHCenter

            Layout.preferredWidth: Math.max(26, implicitWidth)
        }

        Label {
            id: cursorPixelPosLabel
            objectName: "cursorPixelPosLabel"
            text: {                
                    return "-1, -1";
            }

            // Specify a fixed size to avoid causing items to the right of us jumping
            // around when we would be resized due to changes in our text.
            Layout.minimumWidth: cursorMaxTextMetrics.width
            Layout.maximumWidth: cursorMaxTextMetrics.width

            TextMetrics {
                id: cursorMaxTextMetrics
                font: cursorPixelPosLabel.font
                text: "9999, 9999"
            }
        }

        ToolSeparator {
            padding: 0
            // Use opacity rather than visible, as it's an easy way of ensuring that the RowLayout
            // always has a minimum height equal to the tallest item (assuming that that's us)
            // and hence doesn't jump around when we become hidden.
            // There's always at least one label and icon visible at all times (cursor pos),
            // so we don't have to worry about those.
//            opacity: (fpsCounter.visible || lineLengthLabel.visible || selectionSizeLabel.visible) ? 1 : 0

            Layout.fillHeight: true
            Layout.maximumHeight: 24
        }

//        Image {
//            id: selectionIcon
//            source: "qrc:/images/selection.png"
//            visible: canvas && canvas.tool === ImageCanvas.SelectionTool

//            Layout.rightMargin: 6
//        }

        Label {
            id: selectionSizeLabel
            objectName: "selectionSizeLabel"
            text: "0 x 0"
            visible: true

            Layout.minimumWidth: selectionAreaMaxTextMetrics.width
            Layout.maximumWidth: selectionAreaMaxTextMetrics.width

            TextMetrics {
                id: selectionAreaMaxTextMetrics
                font: selectionSizeLabel.font
                text: "9999 x 9999"
            }
        }

        Rectangle {
            implicitWidth: 16
            implicitHeight: 1
            visible: true

            Rectangle {
                y: -1
                width: 1
                height: 3
            }

            Rectangle {
                y: -1
                width: 1
                height: 3
                anchors.right: parent.right
            }
        }

        Label {
            id: lineLengthLabel
            objectName: "lineLengthLabel"
            text: "DP: " + dpt
            visible: true

            Layout.minimumWidth: lineLengthMaxTextMetrics.width
            Layout.maximumWidth: lineLengthMaxTextMetrics.width

            TextMetrics {
                id: lineLengthMaxTextMetrics
                font: lineLengthLabel.font
                text: Screen.desktopAvailableWidth
            }
        }




        ToolSeparator {
            padding: 0
            visible: true

            Layout.fillHeight: true
            Layout.maximumHeight: 24
        }
    }
}
