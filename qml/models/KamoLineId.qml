import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import "../js/KAMO-functions.js" as KAMO

XmlListModel {
    property string startTime
    property string routeCode

    property QtObject legModel

    // get the lineId for the bus that's driving the route
    // do the matching by matching scheduled arrival time and route code

    query: "//*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='getNextDeparturesResponse']/*[local-name()='result']" +
           "/*[local-name()='item'][*[local-name()='time'] = '" + startTime + "' and *[local-name()='route'] = '" + routeCode + "']"



    XmlRole { name: "Id"; query: "id/string()" }


    onStatusChanged: {
        // if connection failed
        if (status == XmlListModel.Error) {
            console.log("XmlListModel failed")
        }




        if (status == XmlListModel.Ready) {

            // no lineID found. damn
            if (count == 0) {
                console.log("failure startTime: " + startTime + " ja route " + routeCode)
                console.log("xml:" + xml)
            }

            // insert LineId data to selectedLegsModel
            else {
                // set the lineId
                legModel.LineId = get(0).Id

                // trigger fetching the actual live data
                KAMO.makePassingTimesHttpRequest(legModel)
            }
        }
    }

}
