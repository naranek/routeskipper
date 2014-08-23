.import "Common.js" as JS

// make the correct query and send it to Reittiopas api
function makeHttpRoutingRequest(dateOffsetInMinutes) {
    var http = new XMLHttpRequest()

    //
    var pastDatetime = JS.addMinutesToDatestamp(selectedDate + selectedTime, dateOffsetInMinutes)

    // the actual url. Concatenating FTW
    var url = "http://api.reittiopas.fi/hsl/prod/?request=route&user=" + credentials.hslUsername + "&pass=" + credentials.hslPassword + "&format=xml&show=5&from=" +
            encodeURI(sourceCoords) + "&to=" + encodeURI(destinationCoords)
            + "&date=" + JS.hslDate(pastDatetime)
            + "&time=" + JS.hslTime(pastDatetime)

              console.log(url)

    // debugging url
    //var url="http://riippuliito.net/files/routing-esimerkki.xml"
    var url = "http://api.reittiopas.fi/hsl/prod/?request=route&user=aikaopas&pass=agjghsra&format=xml&show=5&from=2552335,6673660&to=2546489,6675524&"

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
    if (locTypeId == 10) return qsTr("Stop")
    else if (locTypeId == 900) return qsTr("Address")
    else return qsTr("Place of interest")
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
    38 = Sipoo internal bus lines maybe?
    39 = Kerava internal bus lines
    */

    var iconList = {
        1: "bus3",
        2: "tram4",
        3: "bus3",
        4: "bus3",
        5: "bus3",
        6: "train20",
        7: "sail1",
        8: "bus3",
        12: "train5",
        21: "bus3",
        22: "bus3",
        23: "bus3",
        24: "bus3",
        25: "bus3",
        36: "bus3",
        37: "bus3",
        38: "bus3",
        39: "bus3",
    }

    if (type == "walk") {
        return "businessman4"
    }

    if (type == "wait") {
        return "zzz"
    }

    return iconList[type]
}
