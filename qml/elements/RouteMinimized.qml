import QtQuick 2.0
import Sailfish.Silica 1.0
// import QtQuick.XmlListModel 2.0
import "../elements" as Elements
import "../js/Common.js" as JS
import "../js/HSL-functions.js" as HSL





// minimized view
Item {
    id: minimizedView
    height: lineRow.height



    // if we have more legs than space, the rest are hidden and user can flick them to use
    // some grafical effect here would be cool
    //
    // unfortunately this doesn't work with backgrounditem, so disabled for now
    /*SilicaFlickable {
        id: legsFlickable
        flickableDirection: Flickable.HorizontalFlick
        clip: true
        contentWidth: lineRow.width // *legsModel.count
        contentHeight: 110
        height: 110
        width: parent.width - walkIcon.width - Math.max(walkingLength.width, waitDuration.width)
*/

        Row {
            id: lineRow
            width: parent.width - walkIcon.width - Math.max(walkingLength.width, waitDuration.width)
            Repeater {
                id: legsRepeater
                model: legsModel
                clip: true

                delegate:
                    Column {
                    visible: Type !== "walk" && Type !== "wait" ? true : false;
                    height: lineShield.height
                    width: lineShield.height
                    Elements.LineShield {id: lineShield;  lineColor: routeBackground.highlighted ? Theme.highlightColor : Theme.primaryColor; state: "horizontal"}
                }

            }
        }

  //  }

    Elements.LineIcon {
        id: waitIcon
        size: 28; type: HSL.transportIcon("wait")
        anchors.left: lineRow.right
        anchors.top: parent.top
    }

    Label {
        id: waitDuration
        text: Math.ceil((Duration - MovingDuration)/60) + " min"
        font.pixelSize: Theme.fontSizeSmall
        color: routeBackground.highlighted ? Theme.highlightColor : Theme.primaryColor
        horizontalAlignment: Text.AlignRight
        anchors.left: waitIcon.right
        anchors.verticalCenter: waitIcon.verticalCenter
    }

    Elements.LineIcon {
        id: walkIcon; size: 28; type: HSL.transportIcon("walk")
        anchors {
            top: waitIcon.bottom
            topMargin: 5
            left: waitIcon.left
        }
    }

    Label {
        id: walkingLength
        text: JS.formatLength(WalkingLength)
        font.pixelSize: Theme.fontSizeSmall
        color: routeBackground.highlighted ? Theme.highlightColor : Theme.primaryColor

        horizontalAlignment: Text.AlignRight
        anchors.left: walkIcon.right
        anchors.verticalCenter: walkIcon.verticalCenter
    }

}
