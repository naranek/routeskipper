import QtQuick 2.0
import "../js/Common.js" as JS
import "../js/KAMO-functions.js" as KAMO

Item {
    property int routeIndex

    Repeater {
        model: routeModel.get(routeIndex).Legs
        delegate: Item {
            id: leg

            Component.onCompleted:  {
                console.log("Malli: " + routeModel.get(routeIndex).Legs)
                console.log("Haetaan: " + StartCode)
                if (StartCode != "") {
                    KAMO.makeNextDeparturesHttpRequest(StartCode, stopXml)
                }
            }

            property string stopXml
            property string passingTimesXml


            //
            onStopXmlChanged: {
                console.log("XML muuttui")
                // get LineID if it's not present
                if (typeof routeModel.get(routeIndex).Legs.LineId === "undefined") {
                    kamoLineIdModel.xml = stopXml
                    console.log("Line ID: " + kamoLineIdModel.LineId)
                }
            }

            // insert the real time data to routeModel
            onPassingTimesXmlChanged: {

            }

            KamoLineId {
                id: kamoLineIdModel
                routeCode: JORECode
                arrTime: JS.kamoTime(StartTime)
            }
        }
    }
}
