import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.3
import "js/AnserGlobal.js" as Global
import "base"
import App 1.0

Item {
    id: lissChanItem
    property Channel channel
    property alias currentChan: switchChan.currentChan
    signal rotChanged(int rot)
    signal spanChanged(int span)
    enum ModeType{
        Current,
        History,
        Base,
        CH,
        CB,
        HB,
        Combine
    }
    property int mode: LissChanItem.ModeType.Current

    GridLayout{
        id: layout
        anchors.fill: parent
        columns: 10
        rows: 2
        rowSpacing: 1
        columnSpacing: 1

        property double colWidth: width/columns
        property double rowHeight: height/rows

        function prefWidth(item){
            return ((colWidth * item.Layout.columnSpan) + (columnSpacing * (item.Layout.columnSpan-1)))
        }
        function prefHeight(item){
            return ((rowHeight * item.Layout.rowSpan) + (rowSpacing * (item.Layout.rowSpan -1)))
        }

        SelectionBox{
            id: spanBtn
            Layout.column: 0
            Layout.columnSpan: 2
            Layout.row: 0
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
            text: channel? String((channel.span * channel.vcon).toFixed(2)): ""
            onWheeled: {
                if(channel){
                    var span = channel.span;
                    if(wheel.angleDelta.y < 0){
                        span *= 2;
                    }else{
                        span /= 2;
                    }
                    span = lissajous.boundSpan(span)
                    channel.span = span
                    if(lissajous.at(1)){
                        lissajous.at(1).span = span;
                    }
                    spanChanged(span);
                }
            }

            onMouseXChanged: toolTipSpan.x = spanBtn.mouseX
            onMouseYChanged: toolTipSpan.y = spanBtn.mouseY

            ToolTip {
                id: toolTipSpan
                delay: 0
                visible: spanBtn.mouseHover && anserMain.showTooltip
                contentItem: Text {
                    textFormat: Text.RichText
                    text:
                        "<div>
                            <header style='color:blue;font-weight:bold'>Span</header>
                            <table>
                                <tr><td>&bull; Shift + MB</td><td>:</td><td>Reset X/Y to 1:1</td></tr>
                                <tr><td>&bull; Wheel</td><td>:</td><td>Change span by +/- 10</td></tr>
                                <tr><td>&bull; Shift + Wheel</td><td>:</td><td>Change span by +/- 1</td></tr>
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
        ChannelScroller{
            id: switchChan
            text: channel? channel.fullName: ""
            Layout.column: 2
            Layout.columnSpan: 6
            Layout.row: 0
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
        }
        SelectionBox{
            id: rotBtn
            Layout.column: 8
            Layout.columnSpan: 2
            Layout.row: 0
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
            text: channel? channel.rot.toString(): ""
            onWheeled: {
                if(channel && (wheel.modifiers & Qt.ControlModifier)){
                    var rot = channel.rot;
                    if(wheel.angleDelta.y < 0){
                        rot += 1;
                    }else{
                        rot -= 1;
                    }
                    if(rot < 0) rot = 359;
                    if(rot > 359) rot = 0;
                    channel.rot = rot
                    if(lissajous.at(1)){
                        lissajous.at(1).rot = rot;
                    }
                    rotChanged(rot);
                }
            }

            onMouseXChanged: toolTipRot.x = rotBtn.mouseX
            onMouseYChanged: toolTipRot.y = rotBtn.mouseY

            ToolTip {
                id: toolTipRot
                delay: 0
                visible: rotBtn.mouseHover && anserMain.showTooltip
                contentItem: Text {
                    textFormat: Text.RichText
                    text:
                        "<div>
                            <header style='color:blue;font-weight:bold'>Span</header>
                            <table>
                                <tr><td>&bull; Shift + MB</td><td>:</td><td>Set rotation on current channel to 0</td></tr>
                                <tr><td>&bull; Shift + LB/RB</td><td>:</td><td>Rotate by 1</td></tr>
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
            id: groupBtn
            text: "G1"
            Layout.column: 0
            Layout.columnSpan: 2
            Layout.row: 1
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
        }
        SelectionBox{
            id: coilBtn
            text: "C1"
            Layout.column: 2
            Layout.columnSpan: 2
            Layout.row: 1
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
        }
        SelectionBox{
            id: coilNameBtn
            text: "Diff"
            Layout.column: 4
            Layout.columnSpan: 3
            Layout.row: 1
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)
        }
        SelectionBox{
            id: modeBtn
            text: "C"
            Layout.column: 7
            Layout.columnSpan: 3
            Layout.row: 1
            Layout.preferredWidth: layout.prefWidth(this)
            Layout.preferredHeight: layout.prefHeight(this)

            state: "c"
            states: [
                State{
                    name: "c"
                    PropertyChanges {
                        target: modeBtn
                        text: "C"
                    }
                    PropertyChanges {
                        target: lissChanItem
                        mode: LissChanItem.ModeType.Current
                    }
                },
                State {
                    name: "h"
                    PropertyChanges {
                        target: modeBtn
                        text: "H"
                    }
                    PropertyChanges {
                        target: lissChanItem
                        mode: LissChanItem.ModeType.History
                    }
                },
                State {
                    name: "b"
                    PropertyChanges {
                        target: modeBtn
                        text: "B"
                    }
                    PropertyChanges {
                        target: lissChanItem
                        mode: LissChanItem.ModeType.Base
                    }
                },
                State {
                    name: "ch"
                    PropertyChanges {
                        target: modeBtn
                        text: "C,H"
                    }
                    PropertyChanges {
                        target: lissChanItem
                        mode: LissChanItem.ModeType.CH
                    }
                },
                State {
                    name: "cb"
                    PropertyChanges {
                        target: modeBtn
                        text: "C,B"
                    }
                    PropertyChanges {
                        target: lissChanItem
                        mode: LissChanItem.ModeType.CB
                    }
                },
                State {
                    name: "hb"
                    PropertyChanges {
                        target: modeBtn
                        text: "H,B"
                    }
                    PropertyChanges {
                        target: lissChanItem
                        mode: LissChanItem.ModeType.HB
                    }
                },
                State {
                    name: "chb"
                    PropertyChanges {
                        target: modeBtn
                        text: "C,H,B"
                    }
                    PropertyChanges {
                        target: lissChanItem
                        mode: LissChanItem.ModeType.Combine
                    }
                }
            ]

            onClicked: {
                switch(state){
                case "c":
                    state = "h";
                    break;
                case "h":
                    state = "b";
                    break;
                case "b":
                    state = "ch";
                    break;
                case "ch":
                    state = "cb";
                    break;
                case "cb":
                    state = "hb";
                    break;
                case "hb":
                    state = "chb";
                    break;
                case "chb":
                    state = "c";
                    break;
                default:
                    break;
                }
            }
        }
    }

}


