.pragma library


// detect if date is datestamp or object
// @return date object or "" if parameter is undefined

function dateToObj(someDate) {
    if (typeof someDate === 'string')
        return dateObjectFromDateStamp(someDate)
    else
        return someDate
}

// Returns the date object from parsing HSL datestamp
function dateObjectFromDateStamp(datestamp) {
    var dateObject = new Date(datestamp.substring(0,4), parseInt(datestamp.substring(4,6))-1,datestamp.substring(6,8),datestamp.substring(8,10),datestamp.substring(10,12),0,0)
    return dateObject
}

// add a leading zero to 1 character string
// @return string zeropadded value
function addZeroPadding(target) {
    var resultString
    resultString = ('0' + target.toString()).slice(-2)
    return resultString
}

// @param dateStamp or dateObj
// @return string dateStamp formatted as hh:mm
function prettyTime(dateParam) {
    var returnString

    // default value
    returnString = ""



    // handle bad values
    if (typeof dateParam === 'undefined') return returnString

    // Get the hour and minute numbers from string
    if (typeof dateParam === 'string') {
        if (dateParam.length > 8) {
            returnString = dateParam.substring(8,10) + ":" + dateParam.substring(10,12)
        }
    }

    // parse dateObj
    else {
        returnString = Qt.formatDateTime(dateParam, "hhmm")
    }
    return returnString
}

// @param date object
// @return datestamp
function hslDateStamp(dateStamp) {
    return Qt.formatDateTime(dateStamp, "yyyyMMddhhmm")
}

// @param date object or datestamp
// @return datestamp
function hslDate(dateParam) {
    var dateObj = dateToObj(dateParam)
    return Qt.formatDateTime(dateObj, "yyyyMMdd")
}

// @param date object or datestamp
// @return datestamp
function hslTime(dateParam) {
    var dateObj = dateToObj(dateParam)
    return Qt.formatDateTime(dateObj, "hhmm")
}

// @param date object or datestamp
// @return datestamp
function kamoTime(dateParam) {
    var dateObj = dateToObj(dateParam)
    return Qt.formatDateTime(dateObj, "hh:mm:ss")
}

// @param int amount of seconds
// @return h:mm:ss or just mm:ss from se
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

// @param Date dateObj: date to use as base
// @param int addDays: how many days to add to dateObj date
// @return Date

// adds offset number of days and returns a string in Reittiopas date format
function makeDateStamp(dateObj, addDays) {

    var offsetDay = new Date()
    offsetDay.setDate(dateObj.getDate()+ addDays)

    return offsetDay
}

// add x number of minutes to dateStamp or dateObj
// this is difficult because - dates are
// @return date object
function addMinutesToDatestamp(dateParam, minutes) {
    var dateObj = dateToObj(dateParam)

    var offsetDateStamp = new Date(dateObj.getTime() + minutes*60000)

    return offsetDateStamp
}

// get two dates and return their difference in seconds
// if parameter is null, current time is used
function timestampDifferenceInSeconds(arrDate, depDate) {

    if (arrDate === null) {
        var arrDateObject = new Date()
    } else {
        var arrDateObject = dateToObj(arrDate)
    }

    if (depDate === null) {
        var depDateObject = new Date()
    } else {
        var depDateObject = dateToObj(depDate)
    }

    var seconds = Math.round((depDateObject-arrDateObject)/1000);
    return seconds
}



// returns the length as a short string in either m or km
function formatLength(lengthInMeters) {

    if (lengthInMeters < 1000) {
        return lengthInMeters + "m"
    } else {
        return (Math.round(lengthInMeters/100) / 10).toString() + "km"
    }
}
