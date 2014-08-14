.import "Common.js" as JS

// make the correct query and send it to Reittiopas api
function makeHttpRoutingRequest() {
    var http = new XMLHttpRequest()

    // always go back 5 minutes to see if we just missed something
    var pastDatetime = JS.addMinutesToDatestamp(selectedDate + selectedTime, -5)

    // the actual url. Concatenating FTW
    var url = "http://api.reittiopas.fi/hsl/prod/?request=route&user=" + credentials.hslUsername + "&pass=" + credentials.hslPassword + "&format=xml&show=5&from=" +
            encodeURI(sourceCoords) + "&to=" + encodeURI(destinationCoords)
            + "&date=" + JS.hslDate(pastDatetime)
            + "&time=" + JS.hslTime(pastDatetime)

    // debugging url
    //var url="http://riippuliito.net/files/routing-esimerkki.xml"


    http.open("GET", url, true)



    // Now we're searching
    httpQueryStatus = 1

    http.onreadystatechange = function() { // Call a function when the state changes.
        if (http.readyState == 4) {
            if (http.status == 200) {

                hslXml = http.responseText
                httpQueryStatus = 2

            } else {
                httpQueryStatus = -1
            }
        }
    }
    http.send(null);
}


// Return just the line number from JORE Code
function makeLineCode (joreCode) {
    var lineCode
    var lineLetter

    /* Some special cases */
    // No code - take a hike
    if (joreCode == "") {
        return ""
    }

    // Local trains
    if (joreCode.substring(0,1) == "3") {
        return joreCode.substring(4,5)
    }

    // Suomenlinna ferry
    if (joreCode.substring(0,4) == "1019") {
        return ""
    }

    // Metro
    if (joreCode.substring(0,4) == "1300") {
        return "Metro"
    }

    // chars 2-5 are actual line number - just remove leading zeroes
    lineCode = joreCode.substring(1,4).replace(/^0+/, '');
    lineLetter = joreCode.substring(4,5)


    return lineCode.toString() + lineLetter
}



// return the location type as text
function locationTypeText(locTypeId) {
    /* Legend: (1-9 and 1008 = poi, 10 = stop, 900 = address) */
    if (locTypeId == 10) return qsTr("Pysäkki")
    else if (locTypeId == 900) return qsTr("Osoite")
    else return qsTr("Paikka")
}



// return the image url for leg typeof
function transportIcon(type) {
    /* Legend:
    1 = Helsinki internal bus lines
    2 = trams
    3 = Espoo internal bus lines
    4 = Vantaa internal bus lines
    5 = regional bus lines
    6 = metro
    7 = ferry
    8 = U-lines
    12 = commuter trains
    21 = Helsinki service lines
    22 = Helsinki night buses
    23 = Espoo service lines
    24 = Vantaa service lines
    25 = region night buses
    36 = Kirkkonummi internal bus lines
    39 = Kerava internal bus lines
    */

    var iconList = {
        1: "icon-bus",
        2: "icon-tram",
        3: "icon-bus",
        4: "icon-bus",
        5: "icon-bus",
        6: "icon-metro",
        7: "icon-ferry",
        8: "icon-bus",
        12: "icon-train",
        21: "icon-bus",
        22: "icon-bus",
        23: "icon-bus",
        24: "icon-bus",
        25: "icon-bus",
        36: "icon-bus",
        39: "icon-bus",
    }

    if (type == "walk") {
        return "icon-walk"
    }

    if (type == "wait") {
        return "icon-wait"
    }

    return iconList[type]
}
