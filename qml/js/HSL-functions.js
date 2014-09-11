.import "Common.js" as JS

// make the correct query and send it to Reittiopas api
function makeHttpRoutingRequest(dateOffsetInMinutes) {
    var http = new XMLHttpRequest()

    // add or substract X minutes from target time
    if (timeType === "arrival") dateOffsetInMinutes = dateOffsetInMinutes * -1

    var pastDatetime = JS.addMinutesToDatestamp(selectedDate + selectedTime, dateOffsetInMinutes)

    // the actual url. Concatenating FTW
    var url = "http://api.reittiopas.fi/hsl/prod/?request=route&user=" + credentials.hslUsername + "&pass=" + credentials.hslPassword + "&format=xml&show=5&from=" +
            encodeURI(sourceCoords) + "&to=" + encodeURI(destinationCoords)
            + "&timetype=" + timeType

            + "&date=" + JS.hslDate(pastDatetime)
            + "&time=" + JS.hslTime(pastDatetime)

    console.log(url)

    // debugging url
    //var url="http://riippuliito.net/files/routing-esimerkki.xml"
    //var url = "http://api.reittiopas.fi/hsl/prod/?request=route&user=aikaopas&pass=agjghsra&format=xml&show=5&from=2552335,6673660&to=2546489,6675524&date=" +

    //var url ="http://api.reittiopas.fi/hsl/prod/?request=route&user=aikaopas&pass=agjghsra&format=xml&show=5&from=2550765,6672886&to=2553250,6674203&date=" +
    //       JS.hslDate(pastDatetime) + "&time=" + JS.hslTime(pastDatetime) + "&timetype=arrival"

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


function streamlineRoute(singleRouteModel) {


    // loop thru routes
    var thisLeg
    var prevLeg
    var nextLeg

    var timeToUse
    var timeDifference

    // loop thru all other than the first leg
    for (var i = 1; i < singleRouteModel.Legs.count; i++) {
        thisLeg = singleRouteModel.Legs.get(i)
        prevLeg = singleRouteModel.Legs.get(i-1)

        // move walking legs if previous leg has Real endtime
        if (thisLeg.Type === 'walk') {
            if (prevLeg.RealEndTime.getTime() !== 0) {
                console.log("Resetting Walking starttime of leg: " + i)

                timeDifference = JS.dateObjectFromDateStamp(thisLeg.StartTime) - prevLeg.RealEndTime
                thisLeg.RealStartTime = prevLeg.RealEndTime
                thisLeg.RealEndTime = JS.dateObjectFromDateStamp(thisLeg.EndTime) + timeDifference
            }
        } else if (thisLeg.Type === 'wait') {
            nextLeg = singleRouteModel.Legs.get(i+1)

            console.log("Resetting waiting time of leg: " + i)
            // calculate the duration again from previous and next legs
            thisLeg.Duration = JS.timestampDifferenceInSeconds(
                        prevLeg.RealEndTime.getTime() !== 0 ? prevLeg.RealEndTime : prevLeg.EndTime,
                                                              nextLeg.RealStartTime.getTime() !== 0 ? nextLeg.RealStartTime : nextLeg.StartTime
                        ).toString()
        }
        /* disabled until we have a way to show alerts
        else {
            // only run if previous leg has real endtime
            if (prevLeg.RealEndTime !== "") {
                // use real time if it's available, otherwise scheduled time
                timeToUse = thisLeg.RealStartTime !== "" ? thisLeg.RealStartTime : thisLeg.StartTime

                // if previous leg ends after this one begins,
                if (prevLeg.RealEndTime > timeToUse) {
                    // todo: alert

                }
            }
            }
            }*/

        // set the first leg if it's walking and we have real startTime
        if (i === 1 && prevLeg.Type==='walk' && thisLeg.RealStartTime.getTime() !== 0) {
            timeDifference = thisLeg.RealStartTime - JS.dateObjectFromDateStamp(prevLeg.EndTime)
            prevLeg.RealEndTime = thisLeg.RealStartTime
            prevLeg.RealStartTime = prevLeg.StartTime- timeDifference
        }
    }
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
            1: "bussi",
            2: "ratikka",
            3: "bussi",
            4: "bussi",
            5: "bussi",
            6: "metro",
            7: "lautta",
            8: "bussi",
            12: "juna",
            21: "bussi",
            22: "bussi",
            23: "bussi",
            24: "bussi",
            25: "bussi",
            36: "bussi",
            37: "bussi",
            38: "bussi",
            39: "bussi",
        }

        if (type == "walk") {
            return "kavely"
        }

        if (type == "wait") {
            return "odotus"
        }

        return iconList[type]
    }
