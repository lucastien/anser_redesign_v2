import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "js/AnserGlobal.js" as Global
import "base"

SelectionBox{
    property int currentChan: 3
    text: "CH " + currentChan
    onClicked: {
        if(mouseButton === Qt.RightButton){
            currentChan--;
        }else if(mouseButton === Qt.LeftButton){
            currentChan++;
        }
        if(currentChan >= 10)
            currentChan = 0;
        else if(currentChan < 0)
            currentChan = 9;
    }
}
