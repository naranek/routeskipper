import QtQuick 2.0
import Sailfish.Silica 1.0

/* This element is used to show the time from timetable or real time data.
  The
*/

Label {
    property string schedTime
    property date realTime
    property string realTimeAcc

    // format the time according to properties
    function timeFormat() {
        // use scheduled time if we don't have real time
        if (realTime.getTime() === 0) { // there is a strange bug, that causes the leg's getTime to be 7200000. This is a workaround.hasOwnProperty()
            return schedTime
        } else {
            // if we have real time, show it according to the accuracy
            if (realTimeAcc === "sec") {
                return Qt.formatDateTime(realTime, "hh:mm:ss")
            } else {
                return Qt.formatDateTime(realTime, "hh:mm")
            }
        }
    }

    id: timeView
    text: timeFormat()

    onRealTimeChanged: {
        if (realTime.getTime() !== 0) {
            textZoom.start()
        }
    }

    NumberAnimation {
        id: textZoom
        target: timeView
        properties: "font.pixelSize"
        from: font.pixelSize * 1.2
        to: font.pixelSize
        duration: 500
    }


}
