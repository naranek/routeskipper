// make the correct query and send it to Reittiopas api
function makeNextDeparturesHttpRequest(stopId) {
    var http = new XMLHttpRequest()

    //var stopID = "1291128"

    var soapData = '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '+
            'xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:seasam">'+
            '<soapenv:Header/>'+
            '<soapenv:Body>'+
            '<urn:getNextDepartures soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'+
            '<String_1 xsi:type="xsd:string">' + stopID + '</String_1>'+
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

                kamoXml = http.responseText
                httpQueryStatus = 2

            } else {
                httpQueryStatus = -1
                console.log("Status: " + http.status + ", Status Text: " + http.statusText);
            }
        }
    }

    //http.overrideMimeType('text/xml; charset=iso-8859-1');
    http.setRequestHeader("Content-type", "text/xml; charset=utf-8");
    http.send((soapData));
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
                httpQueryStatus = 2

            } else {
                httpQueryStatus = -1
                console.log("Status: " + http.status + ", Status Text: " + http.statusText);
            }
        }
    }

    //http.overrideMimeType('text/xml; charset=iso-8859-1');
    http.setRequestHeader("Content-type", "text/xml; charset=utf-8");
    http.send((soapData));
}

//
function mergeRealtimeData() {

}
