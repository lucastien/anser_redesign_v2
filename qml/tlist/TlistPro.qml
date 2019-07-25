import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import TubeHandler 1.0
import "../js/AnserGlobal.js" as Global
import "../base"
Item {
    id: tlistPro
    property TubeHandler tube
    property int scale: 1
    TlistTablePro{
        id: tlistTablePro
        anchors.fill: parent
    }

}
