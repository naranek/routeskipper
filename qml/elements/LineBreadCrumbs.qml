import QtQuick 2.0
import Sailfish.Silica 1.0
import "../pages/../js/HSL-functions.js" as HSL


Row {
    id: breadCrumbRow
    property int selectedId
    property int sizeBig
    property int sizeSmall

    width: parent.width

    Repeater {
        model:selectedLegsModel
        delegate: Image {
            id: lineIcon
            width: (selectedId == index ? sizeBig : sizeSmall); height: (selectedId == index ? sizeBig : sizeSmall)
            fillMode: Image.PreserveAspectFit
            smooth: true
            anchors.verticalCenter: breadCrumbRow.verticalCenter
            source: "qrc:" + HSL.transportIcon(Type)
        }
    }
}

