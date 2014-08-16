import QtQuick 2.0
import Sailfish.Silica 1.0
import "../pages/../js/HSL-functions.js" as HSL
import "../elements" as Elements

Row {
    id: breadCrumbRow
    property int selectedId
    property int sizeBig
    property int sizeSmall

    width: parent.width

    Repeater {
        model:selectedLegsModel
        delegate: Elements.LineIcon {
            id: lineIcon
            size: (selectedId == index ? sizeBig : sizeSmall); height: (selectedId == index ? sizeBig : sizeSmall)
            anchors.verticalCenter: breadCrumbRow.verticalCenter
            type: HSL.transportIcon(Type)
        }
    }
}

