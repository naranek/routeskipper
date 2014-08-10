import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/HSL-functions.js" as HSL
import "../elements" as Elements

Row {
    id: lineRow
    property string startName
    property string startTime
    property string endTime

    property color lineColor



    width: (parent !== null ? parent.width : 0)
    spacing: 3

    // Starting place and time
    Label {
        id: fromPart
        width: parent.width - lineShield.width - toPart.width
        font.pixelSize: Theme.fontSizeSmall
        text: startName + " " + HSL.timeFromDatetime(startTime)
        color: lineColor
        truncationMode: TruncationMode.Fade
        horizontalAlignment: Text.AlignRight
    }

    // Line icon and number

    Elements.LineShield {id: lineShield; lineColor: lineRow.lineColor;}

    // Endpoint and time
    Label {
        id: toPart
        width: 80
        font.pixelSize: Theme.fontSizeSmall
        text: HSL.timeFromDatetime(endTime)
        color: lineColor
        truncationMode: TruncationMode.Fade
    }
}
