import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import TubeHandler 1.0
Item {
    id: stripContentItem
    property TubeHandler tube

    property int numStrip: 3
    property int numLiss: 3

    Component.onCompleted: {
        console.log("Strip chart initialize")
        tube.expHeight = lissRepeater.itemAt(0).expHeight
        tube.expWidth = lissRepeater.itemAt(0).expWidth        
    }

    RowLayout{
        spacing: 0
        anchors.fill: parent

        AnserLocBar{
            id: locBar
            width: 50
            Layout.fillHeight: true
            tube: stripContentItem.tube
        }

        Repeater{
            id: stripRepeater
            model: numStrip
            AnserStripChart{
                width: 150
                Layout.fillHeight: true
                expStripHeight: lissRepeater.itemAt(0).expWidth
                tube: stripContentItem.tube
                onScaleChanged: {
                    console.log("scale changed")
                    locBar.changeScale(inc)
                }
                onCursorYChanged: {
                    for(var i = 0; i < stripRepeater.count; i++){
                        if(i !== index){
                            stripRepeater.itemAt(i).cursorY = cursorY
                        }
                    }
                    var center = cursorY + cursorWidth/2;
                    updateDpt(center)
                }

            }

        }

        Repeater{
            id: lissRepeater
            model: numLiss
            AnserLissajous{
                Layout.fillWidth: true
                Layout.fillHeight: true
                channel: index + 1
                tube: stripContentItem.tube
                onExpWinChanged: {
                    for(var i = 0; i < lissRepeater.count; i++){
                        if(i !== index){
                            lissRepeater.itemAt(i).expWin = expWin
                            lissRepeater.itemAt(i).updateExpWin()
                        }
                    }
                }
            }
        }
    }
    function updateDpt(centerCursor){
        anserFooterBar.dpt = stripRepeater.itemAt(0).pixToDpt(centerCursor);
        tube.expTp = anserFooterBar.dpt - tube.expHeight/2
        for(var i = 0; i < lissRepeater.count; i++){
            lissRepeater.itemAt(i).expTp = anserFooterBar.dpt - tube.expHeight/2
        }
        tube.npt = lissRepeater.itemAt(0).expWin*2
        tube.pt0 = tube.expTp + tube.expHeight/2 - tube.npt;
    }

    function updateStripChart(){
        for(var i = 0; i < stripRepeater.count; i++){
            stripRepeater.itemAt(i).drawStrip()
        }
    }
}
