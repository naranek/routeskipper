import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/HSL-functions.js" as HSL
import "../js/DatabaseTools.js" as DbTools
import "../models" as Models
import "../elements" as Elements

// Rectangle { anchors.fill: parent; color: "red"; opacity: 0.3; z:-1; visible: true }

Page {
    id: page



    /*
    BackgroundItem {
        id: singleRouteInfo
        height: contentItem.childrenRect.height
        anchors.bottomMargin: 30

        Label {
            id: routeHeader
            x: Theme.paddingLarge
            text: "Latauksia haetaan."
            color: singleRouteInfo.highlighted ? Theme.highlightColor : Theme.primaryColor
        }
    }

    Button {
        id: doSearch
        text: qsTr("Tyhjennä tietokanta")
        //enabled: false
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: DbTools.cleanDb()

    }
    */
}
