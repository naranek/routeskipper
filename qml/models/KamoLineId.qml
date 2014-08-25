import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import "../js/KAMO-functions.js" as KAMO

XmlListModel {
    property string startTime
    property string routeCode

    property string selectedLegIndex

    // get the lineID for the bus that's driving the route
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
            // insert LineId data to selectedLegsModel
            selectedLegsModel.get(selectedLegIndex).LineID = get(0).Id
            console.log("Setting line ID: " + get(0).Id)
            console.log("Noh: " +  selectedLegsModel.get(selectedLegIndex).LineID)

            // trigger fetching the actual live data
            KAMO.addTimesToLegsModel(xml, selectedLegIndex)
        }
    }

}
