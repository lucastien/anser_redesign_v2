import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.3
import "js/AnserGlobal.js" as Global
import "base"
import App 1.0

Item {
    id: stripChanItem
    property Channel channel
    property alias currentChan: chanSelect.chan
    enum ModeType{
        Current,
        History,
        Base,
        CH,
        CB,
        HB,
        Combine
    }
    property int mode: StripChanItem.ModeType.Current

    GridLayout{
        anchors.fill: parent
        columns: 4
        rows: 2
        rowSpacing: 1
        columnSpacing: 1
        SelectionBox{
            id: chanSelect
            property int chan: 3
            Layout.column: 0
            Layout.row: 0
            Layout.fillHeight: true
            Layout.fillWidth: true
            text: stripChanItem.channel? stripChanItem.channel.name: ""
            onClicked: {
                if(mouseButton === Qt.RightButton){
                    chan--;
                }else if(mouseButton === Qt.LeftButton){
                    chan++;
                }
                if(chan >= 10)
                    chan = 0;
                else if(chan < 0)
                    chan = 9;
            }

            onMouseXChanged: toolTip.x = mouseX + 15
            onMouseYChanged: toolTip.y = mouseY + 20

            ToolTip {
                id: toolTip
                delay: 0
                visible: chanSelect.mouseHover && anserMain.showTooltip
                contentItem: Text {
                    textFormat: Text.RichText
                    text:
                        "<div>
                            <header style='color:blue;font-weight:bold'>Channel</header>
                            <table>
                                <tr><td>&bull; LB/RB</td><td>:</td><td>Next/Prev channel</td></tr>
                                <tr><td>&bull; Shift + LB/RB</td><td>:</td><td>Next/Prev channel at same freq</td></tr>
                                <tr><td>&bull; Ctrl + LB/RB</td><td>:</td><td>Next/Prev channel at same coil</td></tr>
                                <tr><td>&bull; Wheel</td><td>:</td><td>Same as LB/RB</td></tr>
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
            Layout.column: 1
            Layout.row: 0
            Layout.fillHeight: true
            Layout.fillWidth: true
            text: channel? channel.freq.toString() + "K": ""
        }
        SelectionBox{
            Layout.column: 2
            Layout.row: 0
            Layout.fillHeight: true
            Layout.fillWidth: true
            text: "V"
            onClicked: {
                if(text === "V"){
                    text = "H";
                }else{
                    text = "V"
                }
            }
        }
        SelectionBox{
            id: stripMode
            Layout.column: 3
            Layout.row: 0
            Layout.rowSpan: 2
            Layout.fillHeight: true
            Layout.fillWidth: true
            text: "C"
            state: "c"
            states: [
                State{
                    name: "c"
                    PropertyChanges {
                        target: stripMode
                        text: "C"
                    }
                    PropertyChanges {
                        target: stripChanItem
                        mode: StripChanItem.ModeType.Current
                    }
                },
                State {
                    name: "h"
                    PropertyChanges {
                        target: stripMode
                        text: "H"
                    }
                    PropertyChanges {
                        target: stripChanItem
                        mode: StripChanItem.ModeType.History
                    }
                },
                State {
                    name: "b"
                    PropertyChanges {
                        target: stripMode
                        text: "B"
                    }
                    PropertyChanges {
                        target: stripChanItem
                        mode: StripChanItem.ModeType.Base
                    }
                },
                State {
                    name: "ch"
                    PropertyChanges {
                        target: stripMode
                        text: "C\nH"
                    }
                    PropertyChanges {
                        target: stripChanItem
                        mode: StripChanItem.ModeType.CH
                    }
                },
                State {
                    name: "cb"
                    PropertyChanges {
                        target: stripMode
                        text: "C\nB"
                    }
                    PropertyChanges {
                        target: stripChanItem
                        mode: StripChanItem.ModeType.CB
                    }
                },
                State {
                    name: "hb"
                    PropertyChanges {
                        target: stripMode
                        text: "H\nB"
                    }
                    PropertyChanges {
                        target: stripChanItem
                        mode: StripChanItem.ModeType.HB
                    }
                },
                State {
                    name: "chb"
                    PropertyChanges {
                        target: stripMode
                        text: "C\nH\nB"
                    }
                    PropertyChanges {
                        target: stripChanItem
                        mode: StripChanItem.ModeType.Combine
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
        SelectionBox{
            Layout.column: 0
            Layout.row: 1
            Layout.fillHeight: true
            Layout.fillWidth: true
            text: "G1"
        }
        SelectionBox{
            Layout.column: 1
            Layout.row: 1
            Layout.fillHeight: true
            Layout.fillWidth: true
            text: "C1"
        }
        SelectionBox{
            Layout.column: 2
            Layout.row: 1
            Layout.fillHeight: true
            Layout.fillWidth: true
            text: "Abs"
        }

    }

}


