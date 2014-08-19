import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/HSL-functions.js" as HSL
import "../js/DatabaseTools.js" as DbTools
import "../models" as Models
import "../elements" as Elements
import "../js/KAMO-functions.js" as KAMO


Page {

    property int httpQueryStatus
    property string kamoXml
    property string kamoError

    Component.onCompleted: KAMO.makeNextDeparturesHttpRequest()

    onHttpQueryStatusChanged: {
        departuresModel.xml = kamoXml
    }

    Models.KamoNextDepartures {
        id: departuresModel
    }

    Column {
        width: parent.width

        Repeater {
            model: departuresModel
            delegate: Row{
                Label {
                    text: Time + " " + Line + " " + Dest
                }
            }
        }

    }


}
