import QtQuick 2.0
import QtQuick.XmlListModel 2.0


XmlListModel {
    property QtObject legModel

    query: "//*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='getPassingTimesResponse']/*[local-name()='result']/*[local-name()='item']"

    XmlRole { name: "Id"; query: "id/string()" }
    XmlRole { name: "Stop"; query: "stop/string()" }
    XmlRole { name: "Line"; query: "line/string()" }
    XmlRole { name: "Time"; query: "time/string()" }
    XmlRole { name: "Rtime"; query: "rtime/string()" }


    onStatusChanged: {
        // if connection failed
        if (status == XmlListModel.Error) {
            console.log("XmlListModel failed")
        }


        if (status == XmlListModel.Ready) {
            // insert LineId data to selectedLegsModel
            if (count == 0) {
                console.log("failure getting PassingTimes - nothing found")
                console.log("XML: " + xml)
                console.log("Query: " + query)
            }

            // add times to routes
            // .RouteRealStartTime
            // .RouteRealEndTime
            // These are most of the time walking, so we need to calculate them from next or previous legs


            // add times to legs
            // loop thru stops
            for (var i = 0; i < count - 1; i++) {
                if (get(i).Stop == legModel.StartCode) {
                    if (get(i).Rtime !== "") {
                        // if the stop code matches and Rtime is not empty, insert it to the leg model
                        legModel.RealStartTime = get(i).Rtime
                    }
                }

                if (get(i).Stop == legModel.EndCode) {
                    if (get(i).Rtime !== "") {
                        // if the stop code matches and Rtime is not empty, insert it to the leg model
                        legModel.RealEndTime = get(i).Rtime
                    }
                }

            }


            // add times to waypoints
            // loop thru stops and waypoints
            for (i = 0; i < count - 1; i++) {
                for (var j = 0; j < legModel.Waypoints.count; j++) {
                    if (get(i).Stop == legModel.Waypoints.get(j).Code) {
                        if (get(i).Rtime !== "") {
                            // if the stop code matches and Rtime is not empty, insert it to the leg model
                            legModel.Waypoints.get(j).RealArrTime = get(i).Rtime
                        }
                    }

                }
            }
        }

    }
}
