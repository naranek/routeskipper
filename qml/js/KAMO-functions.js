.import "Common.js" as JS

// make the correct query and return XML or insert LineID to leg model
function makeNextDeparturesHttpRequest(stopId, time, routeCode, selectedLegIndex) {
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
    httpQueryStatus = 1

    http.onreadystatechange = function() { // Call a function when the state changes.
        if (http.readyState == 4) {
            if (http.status == 200) {
                console.log("Kamo HTTP Success")
                //
                if (routeCode !== null) {
                    addLineId()
                } else {
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

// add line id to legs model
function addLineId(xml, selectedLegIndex) {
    // create the KamoLineId model

    // get the line ID

    // insert to model

    // call makePassingTimesHttpRequest
}

// make the correct query and send it to Reittiopas api
function makePassingTimesHttpRequest(lineID) {
    var http = new XMLHttpRequest()

    // var lineId = "1997652780"

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

function addTimesToLegsModel(xml) {
    // create KamoPassingTimes model

    // extract passing times

    // add to model
}

// update the real time data of all the selected legs
function mergeRealtimeData() {

    for (var i = 0; i < selectedLegsModel.count ; i++) {

        // find LineID if it's not defined
        if (typeof selectedLegsModel.get(i).LineID === undefined) {
            makeNextDeparturesHttpRequest(StartCode, JS.kamoTime(StartTime), JORECode)
        }

        // get realtime data and merge it to the legs model
        else {
            makePassingTimesHttpRequest(selectedLegsModel.get(i).LineID)
        }

    }
}


