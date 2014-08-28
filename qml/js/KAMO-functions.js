.import "Common.js" as JS

// // this function starts the async function rollercoaster that ends with LineID in selectedModelData
function makeNextDeparturesHttpRequest(stopId, startTime, routeCode, legModel) {
    var http = new XMLHttpRequest()



    var soapData = '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '+
            'xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:seasam">'+
            '<soapenv:Header/>'+
            '<soapenv:Body>'+
            '<urn:getNextDeparturesExt soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'+
            '<String_1 xsi:type="xsd:string">' + stopId + '</String_1>'+
            '<Date_2 xsi:type="xsd:dateTime">' + JS.isoTime(JS.addMinutesToDatestamp(legModel.StartTime, -5)) + '</Date_2>' +
            '<int_3 xsi:type="xsd:int">10</int_3>' +
            '</urn:getNextDeparturesExt>'+
            '</soapenv:Body>'+
            '</soapenv:Envelope>'


    // the actual url. Concatenating FTW
    var service = "http://hsl.trapeze.fi:80/interfaces/kamo"

    http.open("POST", service , true)

    http.onreadystatechange = function() { // Call a function when the state changes.
        if (http.readyState == 4) {
            if (http.status == 200) {
                console.log("Kamo HTTP Success")


                //
                if (routeCode !== null) {
                    // create the xmlListModel
                    var kamoLineId = Qt.createComponent("../models/KamoLineId.qml");
                    kamoLineId.createObject(legModel, {"startTime": startTime, "routeCode": routeCode,
                                                "legModel": legModel, "xml": http.responseText});


                } else {
                    // kamoXml = http.responseXML
                    // this is crazy, but return the xml to someone maybe?
                }

            } else {
                console.log("Status: " + http.status + ", Status Text: " + http.statusText);
                console.debug("request:" + soapData)
            }
        }
    }

    http.setRequestHeader("Content-type", "text/xml; charset=utf-8");
    http.send((soapData));
}


// this function starts the async function rollercoaster that ends with new realtime data inserted to model
function makePassingTimesHttpRequest(legModel) {
    var http = new XMLHttpRequest()



    var soapData = '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '+
            'xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:seasam">'+
            '<soapenv:Header/>'+
            '<soapenv:Body>'+
            '<urn:getPassingTimes soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'+
            '<String_1 xsi:type="xsd:string">' + legModel.LineId + '</String_1>'+
            '</urn:getPassingTimes>'+
            '</soapenv:Body>'+
            '</soapenv:Envelope>'

    // the actual url. Concatenating FTW
    var service = "http://hsl.trapeze.fi:80/interfaces/kamo"

    http.open("POST", service , true)


    http.onreadystatechange = function() { // Call a function when the state changes.
        if (http.readyState == 4) {
            if (http.status == 200) {

                // create the xmlListModel

                var passingTimes = Qt.createComponent("../models/KamoPassingTimes.qml");
                passingTimes.createObject(legModel, {legModel: legModel, xml: http.responseText});

            } else {
                console.log("Status: " + http.status + ", Status Text: " + http.statusText);
            }
        }
    }

    http.setRequestHeader("Content-type", "text/xml; charset=utf-8")
    http.send((soapData))
}


// update the real time data of the leg and waypoints that it contains
// parameter is the leg model object
// another parameter is the amount of seconds that need to pass before making another query
function mergeRealtimeData(legModel, secondsBetweenQueries) {
    // don't run for walking or waiting legs or if lineID is not available
    if (legModel.Type !== "walk" && legModel.Type !== "wait" && legModel.LineId !== "0") {

        // don't do anything if the update is already in progress
        if (JS.timestampDifferenceInSeconds(legModel.RealUpdateTime, null) > secondsBetweenQueries) {

            // set the new query time
            legModel.RealUpdateTime = new Date()

            // find LineId if it's not defined
            if (legModel.LineId === "") {
                makeNextDeparturesHttpRequest(legModel.StartCode, JS.kamoTime(legModel.StartTime), legModel.JORECode, legModel)
            }

            // get realtime data and merge it to the legs model
            else {
                makePassingTimesHttpRequest(legModel)
            }
        }
    }

}
