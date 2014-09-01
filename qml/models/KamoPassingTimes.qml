import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import "../js/Common.js" as JS


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

            console.log("updating passingTimes for leg: " + legModel)

            // add times to routes
            // .RouteRealStartTime
            // .RouteRealEndTime
            // These are most of the time walking, so we need to calculate them from next or previous legs


            // OK, so we have limited amounts of realtime data
            // TODO maybe: Let's assume that if the bus is late, it will be as late for the rest of the trip
            // If it's early it will probably wait at some point to match the schedule


            // add times to legs and waypoints

            var latestDelay = 0

            // loop thru stops
            for (var i = 0; i < count ; i++) {
                // if the stop code matches and Rtime is not empty, insert it to the leg model
                if (get(i).Stop == legModel.StartCode) {
                    if (get(i).Rtime !== "") {
                        legModel.RealStartTime = get(i).Rtime
                    }
                }

                // if the stop code matches and Rtime is not empty, insert it to the leg model
                if (get(i).Stop == legModel.EndCode) {
                    if (get(i).Rtime !== "") {
                        legModel.RealEndTime = get(i).Rtime
                    }
                }


                // loop thru legs
                for (var j = 0; j < legModel.Waypoints.count; j++) {
                    // see if it's the right stop
                    if (get(i).Stop == legModel.Waypoints.get(j).Code) {
                        // realtime data - yay
                        if (get(i).Rtime !== "") {

                            // set the realtime data
                            legModel.Waypoints.get(j).RealArrTime = get(i).Rtime

                            // calculate how late we are
                            latestDelay = JS.timestampDifferenceInSeconds(legModel.Waypoints.get(j).ArrTime, JS.dateObjectFromKamoRtime(get(i).Rtime))
                        } else {
                            if (latestDelay > 60) {
                                // set the estimated realtime data
                                legModel.Waypoints.get(j).RealArrTime = JS.prettyTime(JS.addSecondsToDatestamp(legModel.Waypoints.get(j).ArrTime, latestDelay))
                            }
                        }
                    }

                }
            }


            // add times to waypoints
            // loop thru stops and waypoints



        }

    }
}
