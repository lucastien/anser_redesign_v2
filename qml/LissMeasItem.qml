import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.3
import "js/AnserGlobal.js" as Global
import "qrc:/Icon.js" as MdiFont
import "base"
import App 1.0

Item{
    id: measBox

    Menu{
        id: indCodeMenu
        signal codeSelected(string ind)
        width: {
            var result = 0;
            var padding = 0;
            for (var i = 0; i < count; ++i) {
                var item = itemAt(i);
                result = Math.max(item.contentItem.implicitWidth, result);
                padding = Math.max(item.padding, padding);
            }
            return result + padding * 2;
        }
        Repeater{
            id: indRepeater
            model: ["NDD", "DNT", "DNG", "PCT", "DFS", "NQI", "NQS", "MBM", "DSI", "DSS"]
            MenuItem{
                text: modelData
                onTriggered:{
                    indCodeMenu.codeSelected(text);
                }
            }
        }
        onCodeSelected: {
            indSelector.text = ind;
        }
    }

    GridLayout{
        id: layout
        anchors.fill: parent
        columnSpacing: 0
        rowSpacing: 0
        columns: 12
        rows: 2

        property double colWidth: width/columns
        property double rowHeight: height/rows

        function prefWidth(item){
            return ((colWidth * item.Layout.columnSpan) + (columnSpacing * (item.Layout.columnSpan-1)))
        }
        function prefHeight(item){
            return ((rowHeight * item.Layout.rowSpan) + (rowSpacing * (item.Layout.rowSpan -1)))
        }

        SelectionBox{
            id: voltBtn
            Layout.column: 0
            //Layout.columnSpan: 2
            Layout.row: 0
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
            state: "Vpp"
            states: [
                State {
                    name: "Vpp"
                    PropertyChanges {
                        target: voltBtn
                        text: "Vpp"
                    }
                },
                State {
                    name: "Vmr"
                    PropertyChanges {
                        target: voltBtn
                        text: "Vmr"
                    }
                }

            ]
            onClicked: {
                switch(state){
                case "Vpp":
                    state = "Vmr";
                    break;
                case "Vmr":
                    state = "Vpp";
                    break;
                }
            }
        }

        SelectionBox{
            id: voltVal
            Layout.column: 1
            Layout.columnSpan: 2
            Layout.row: 0
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
            text: "1.56"
        }

        SelectionBox{
            id: degBtn
            Layout.column: 3
            //Layout.columnSpan: 2
            Layout.row: 0
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
            text: "DEG"
            state: "normal"
            states: [
                State {
                    name: "normal"
                    PropertyChanges {
                        target: degBtn
                        color: Global.StripChartColor
                    }
                },
                State {
                    name: "flip180"
                    PropertyChanges {
                        target: degBtn
                        color: "red"
                    }
                }
            ]
            onClicked: {
                if(state == "normal")
                    state = "flip180"
                else
                    state = "normal"
            }
        }

        SelectionBox{
            id: degVal
            Layout.column: 4
            //Layout.columnSpan: 2
            Layout.row: 0
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
            text: "120"
        }

        SelectionBox{
            id: locOffsetBox
            Layout.column: 5
            Layout.columnSpan: 4
            Layout.row: 0
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
            text: "01H + 25.55"
        }

        SelectionBox{
            id: pctVal
            Layout.column: 9
            Layout.row: 0
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
            text: "20%"
        }

        SelectionBox{
            id: indSelector
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.column: 10
            Layout.columnSpan: 2
            Layout.row: 0
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
            onClicked: {
                if(mouseButton === Qt.RightButton){
                    indCodeMenu.popup();
                }
            }
        }

        //Row 2
        SelectionBox{
            Layout.column: 0
            Layout.row: 1
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
            text: "+/-"
        }

        IconButton{
            Layout.column: 1
            Layout.row: 1
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
            text: MdiFont.Icon.delete
        }

        IconButton{
            Layout.column: 2
            Layout.row: 1
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
            text: MdiFont.Icon.undo
        }

        IconButton{
            Layout.column: 3
            Layout.row: 1
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
            text: MdiFont.Icon.redo
        }

        IconButton{
            Layout.column: 4
            Layout.row: 1
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
            text: MdiFont.Icon.compare
        }

        IconButton{
            Layout.column: 5
            Layout.row: 1
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
            text: MdiFont.Icon.history
        }

        SelectionBox{
            Layout.column: 6
            Layout.columnSpan: 2
            Layout.row: 1
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
            MouseArea {
                id: utilArea
                anchors.fill: parent
                hoverEnabled: true

                onMouseXChanged: toolTipUtil.x = utilArea.mouseX + 15
                onMouseYChanged: toolTipUtil.y = utilArea.mouseY + 20
            }

            ToolTip {
                id: toolTipUtil
                delay: 0
                visible: utilArea.containsMouse && anserMain.showTooltip
                contentItem: Text {
                    textFormat: Text.RichText
                    text:
                        "<div>
                            <header style='color:blue;font-weight:bold'>Editor bar</header>
                            <table>
                                <tr><td>&bull; RB</td><td>:</td><td>Select editor</td></tr>
                            </table>
                        </div>"
                    font.pointSize: 14
                    color: "#fd3a94"
                }

                background: Rectangle {
                    color: "#fff68f"
                    border.color: "#21be2b"
                }
            }
        }
        SelectionBox{
            Layout.column: 8
            Layout.row: 1
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
            text: "INR"
        }
        SelectionBox{
            Layout.column: 9
            Layout.row: 1
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
            text: "NQI"
        }
        SelectionBox{
            Layout.column: 10
            Layout.row: 1
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
            text: "DFS"
        }
        SelectionBox{
            Layout.column: 11
            Layout.row: 1
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
            text: "ADI"
        }

    }
}











/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
