import QtQuick 2.0
import QtQuick.XmlListModel 2.0


XmlListModel {
    property ListModel legModel

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
                console.log("failure - nothing found")
            }

            // add times to routes
            // .RouteRealStartTime
            // .RouteRealEndTime
            // These are most of the time walking, so we need to calculate them from next or previous legs


            // add times to legs
            for (var i = 0; i < count - 1; i++) {
                for (j = 0; i < legModel.count; j++) {
                    if (get(i).Stop == legModel.get(j).StartCode) {
                        console.log("match a")
                        legModel.get(j).RealStartTime = get(i).Rtime
                    }
                }
            }

            // add times to waypoints

        }
    }

}
