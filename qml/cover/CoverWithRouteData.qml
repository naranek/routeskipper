import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import "../js/HSL-functions.js" as HSL
import "../elements" as Elements

Column {
    property ListElement legModel: ListElement {}

    Elements.LineShield {
        id: lineShield
        lineColor: Theme.hilightColor
        length: HSL.formatLength(legModel.Length)
        joreCode: legModel.JORECode
        transportType: legModel.Type
        // Component.onCompleted: console.log("color: " + Theme.hilightColor + " joreCode: " + legsModel.get(selectedLeg).JORECode + " type: " + legsModel.get(selectedLeg).Type)
    }

    Label {
        text: HSL.timeFromDatetime(legModel.StartTime)
        font.pixelSize: Theme.fontSizeSmall
        width: parent.width
    }

    Label {
        text: (legModel.StartName != "" ? legModel.StartName : qsTr("Lähtö"))
        font.pixelSize: Theme.fontSizeSmall
        width: parent.width
    }
}
