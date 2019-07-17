import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import TubeHandler 1.0
import App 1.0
Item {
    id: stripContentItem
    property TubeHandler tube

    property int numStrip: 3
    property int numLiss: 3
    property int centerCursor: stripRepeater.itemAt(0).cursorY +  stripRepeater.itemAt(0).cursorWidth/2 //the current center of the cursor on strip chart

    signal spanChanged()


    onCenterCursorChanged: updateDpt()

    function updateDpt(){
        anserFooterBar.dpt = stripRepeater.itemAt(0).pixToDpt(centerCursor);
        for(var i = 0; i < lissRepeater.count; i++){
            lissRepeater.itemAt(i).centerCursor = centerCursor;
            lissRepeater.itemAt(i).updateExpWin();
        }
    }

    function updateStripChart(){
        for(var i = 0; i < stripRepeater.count; i++){
            stripRepeater.itemAt(i).drawStrip()
        }
    }

    function updateLissajous(){
        for(var i = 0; i < lissRepeater.count; i++){
            lissRepeater.itemAt(i).updateLissAndExp()
        }
    }

    function updateScreen(){
        updateDpt()
        updateStripChart()
        updateLissajous()
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
                    centerCursor = cursorY + cursorWidth/2;
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
                        }
                    }
                }
                onSpanChanged:{
                    for(var i = 0; i < stripRepeater.count; i++){
                         if(stripRepeater.itemAt(i).currentChan === channel){
                             stripRepeater.itemAt(i).drawStrip();
                         }
                    }
                }
                onRotChanged: {
                   for(var i = 0; i < stripRepeater.count; i++){
                        if(stripRepeater.itemAt(i).currentChan === channel){
                            stripRepeater.itemAt(i).drawStrip();
                        }
                   }
                }
            }
        }
    }



}
