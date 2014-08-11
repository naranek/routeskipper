

// make the correct query and send it to Reittiopas api
function makeHttpRoutingRequest() {
    var http = new XMLHttpRequest()

    // always go back 5 minutes to see if we just missed something
    var pastDatetime = addMinutesToDatestamp(selectedDate + selectedTime, -5)



    // the actual url. Concatenating FTW
    var url = "http://api.reittiopas.fi/hsl/prod/?request=route&user=" + credentials.hslUsername + "&pass=" + credentials.hslPassword + "&format=xml&show=5&from=" +
            encodeURI(sourceCoords) + "&to=" + encodeURI(destinationCoords)
            + "&date=" + pastDatetime[0]
            + "&time=" + pastDatetime[1]

    // debugging url
     var url="http://riippuliito.net/files/routing-esimerkki.xml"

    http.open("GET", url, true)



    // Now we're searching
    httpQueryStatus = 1

    http.onreadystatechange = function() { // Call a function when the state changes.
        if (http.readyState == 4) {
            if (http.status == 200) {
//                console.log("Http request success:" + url)
                hslXml = http.responseText
                httpQueryStatus = 2

            } else {
//                console.log("Http request error: " + http.status)
//                console.log("Url:" + url)
                httpQueryStatus = -1
            }
        }
    }
    http.send(null);
}




// add a leading zero to 1 character string
// returns the value as string
function addZeroPadding(target) {
    var resultString
    resultString = ('0' + target.toString()).slice(-2)
    return resultString
}

// format a hhmm time as hh:mm
function prettyTime(hslTime) {
    return hslTime.substring(0,2) + ":" + hslTime.substring(2,4)
}

//
function prettyTimeFromSeconds(seconds) {
    var prefix = ""
    var hoursString = ""
    if (isNaN(seconds)) {
        return ""
    }  else {

        // handle negative times: add prefix to the output and do the calculation with positive number
        if (seconds < 0) {
            prefix = "-"
            seconds = -1*seconds
        }

        var hours = Math.floor(seconds / 3600)
        var minutes = Math.floor((seconds - 3600*hours)/ 60)
        var remainingSeconds = seconds - 60*minutes - 3600*hours

        // if the time is over an hour ago, add hours and zeropadding to the minute
        if (hours > 0) {
            hoursString = hours + ":"
            minutes = addZeroPadding(minutes)
        }
    }
    return prefix + hoursString + minutes + ":" + addZeroPadding(remainingSeconds)
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



// get the minute as hh:mm from HSL Time (201407250138)
function timeFromDatetime(inputDatetime) {
    var returnString

    // default value
    returnString = ""

    if (typeof inputDatetime === 'undefined') return returnString

    // Get the hour and minute numbers
    if (inputDatetime.length > 8) {
        returnString = inputDatetime.substring(8,10) + ":" + inputDatetime.substring(10,12)
    }

    return returnString
}

// adds offset number of days and returns a string in Reittiopas date format
function makeDateStamp(offset) {
    var today = new Date()
    var offsetDay = new Date()
    offsetDay.setDate(today.getDate()+ offset)

    return Qt.formatDateTime(offsetDay, "yyyyMMdd")

}

// add x number of minutes to the datestamp
// this is difficult because dates
// @return date and time in a array
function addMinutesToDatestamp(datestamp, minutes) {

    var dateObject = new Date(datestamp.substring(0,4), parseInt(datestamp.substring(4,6))-1,datestamp.substring(6,8),datestamp.substring(8,10),datestamp.substring(10,12),0,0)


    var offsetDatestamp = new Date(dateObject.getTime() + minutes*60000)

    return [Qt.formatDateTime(offsetDatestamp, "yyyyMMdd"), Qt.formatDateTime(offsetDatestamp, "hhmm")]
}

// get two HSL datestamps and return their difference in seconds
// if parameter is null, current time is used
function timestampDifferenceInSeconds(arrDatetime, depDatetime) {

    if (arrDatetime === null) {
        var arrDateObject = new Date()
    } else {
        var arrDateObject = new Date(arrDatetime.substring(0,4), parseInt(arrDatetime.substring(4,6))-1,arrDatetime.substring(6,8),arrDatetime.substring(8,10),arrDatetime.substring(10,12),0,0)
    }

    if (depDatetime === null) {
        var depDateObject = new Date()
    } else {
        var depDateObject = new Date(depDatetime.substring(0,4), parseInt(depDatetime.substring(4,6))-1,depDatetime.substring(6,8),depDatetime.substring(8,10),depDatetime.substring(10,12),0,0)
    }


    var seconds = Math.round((depDateObject-arrDateObject)/1000);
    return seconds
}

// Returns the date object from parsing HSL datestamp
function dateObjectFromDateStamp(datestamp) {
    var dateObject = new Date(datestamp.substring(0,4), parseInt(datestamp.substring(4,6))-1,datestamp.substring(6,8),datestamp.substring(8,10),datestamp.substring(10,12),0,0)
    return dateObject
}


// returns the length as a short string in either m or km
function formatLength(lengthInMeters) {

    if (lengthInMeters < 1000) {
        return lengthInMeters + "m"
    } else {
        return (Math.round(lengthInMeters/100) / 10).toString() + "km"
    }
}
