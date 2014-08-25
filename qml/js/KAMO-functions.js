.import "Common.js" as JS

// // this function starts the async function rollercoaster that ends with LineID in selectedModelData
function makeNextDeparturesHttpRequest(stopId, startTime, routeCode, selectedLegIndex) {
    var http = new XMLHttpRequest()



    var soapData = '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '+
            'xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:seasam">'+
            '<soapenv:Header/>'+
            '<soapenv:Body>'+
            '<urn:getNextDepartures soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'+
            '<String_1 xsi:type="xsd:string">' + stopId + '</String_1>'+
            '</urn:getNextDepartures>'+
            '</soapenv:Body>'+
            '</soapenv:Envelope>'


    // the actual url. Concatenating FTW
    var service = "http://hsl.trapeze.fi:80/interfaces/kamo"

    http.open("POST", service , true)


    // Now we're searching
    // httpQueryStatus = 1

    http.onreadystatechange = function() { // Call a function when the state changes.
        if (http.readyState == 4) {
            if (http.status == 200) {
                console.log("Kamo HTTP Success")

                //
                if (routeCode !== null) {
                    // create the xmlListModel
                    var kamoLineId = Qt.createComponent("../models/KamoLineId.qml");
                    kamoLineId.createObject(selectedLegsModel, {startTime: startTime, routeCode: routeCode,
                                                selectedLegIndex: selectedLegIndex, xml: http.responseText});

                } else {
                    // kamoXml = http.responseXML
                    // this is crazy, but return the xml to someone maybe?
                }

            } else {
                console.log("Status: " + http.status + ", Status Text: " + http.statusText);
            }
        }
    }

    http.setRequestHeader("Content-type", "text/xml; charset=utf-8");
    http.send((soapData));
}


// this function starts the async function rollercoaster that ends with new realtime data inserted to model
function makePassingTimesHttpRequest(lineID, selectedLineIndex) {
    var http = new XMLHttpRequest()



    var soapData = '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '+
            'xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:seasam">'+
            '<soapenv:Header/>'+
            '<soapenv:Body>'+
            '<urn:getPassingTimes soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'+
            '<String_1 xsi:type="xsd:string">' + lineId + '</String_1>'+
            '</urn:getPassingTimes>'+
            '</soapenv:Body>'+
            '</soapenv:Envelope>'

    // the actual url. Concatenating FTW
    var service = "http://hsl.trapeze.fi:80/interfaces/kamo"

    http.open("POST", service , true)


    // Now we're searching
    httpQueryStatus = 1

    http.onreadystatechange = function() { // Call a function when the state changes.
        if (http.readyState == 4) {
            if (http.status == 200) {

                kamoXml = http.responseText
                //  httpQueryStatus = 2

            } else {
                //    httpQueryStatus = -1
                console.log("Status: " + http.status + ", Status Text: " + http.statusText);
            }
        }
    }

    http.setRequestHeader("Content-type", "text/xml; charset=utf-8");
    http.send((soapData));
}

function addTimesToLegsModel(xml, selectedLegIndex) {
    // create KamoPassingTimes model

    // extract passing times

    // add to model
}

// update the real time data of all the selected legs
function mergeRealtimeData(selectedLegIndex) {

    if (selectedLegsModel.get(selectedLegIndex).Type !== "walk" && selectedLegsModel.get(selectedLegIndex).Type !== "wait") {
        console.log("merging leg: " + selectedLegIndex)
        // console.log("leg:" + selectedLegsModel.get(selectedLegIndex))

        var leg = selectedLegsModel.get(selectedLegIndex)

        // find LineID if it's not defined
        if (typeof selectedLegsModel.get(selectedLegIndex).LineID === "undefined") {
            console.log("leg " + selectedLegIndex + " no LineID")
            makeNextDeparturesHttpRequest(leg.StartCode, JS.kamoTime(leg.StartTime), leg.JORECode, selectedLegIndex)
        }

        // get realtime data and merge it to the legs model
        else {
            console.log("leg " + selectedLegIndex + " LineID found: " + selectedLegsModel.get(selectedLegIndex).LineID)
            makePassingTimesHttpRequest(selectedLegsModel.get(selectedLegIndex).LineID)
        }
    }

}


