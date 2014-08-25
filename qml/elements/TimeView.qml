import QtQuick 2.0
import Sailfish.Silica 1.0

/* This element is used to show the time from timetable or real time data.
  The
*/

Label {
    property string schedTime
    property string realTime

    id: timeView
    text: (realTime !== "" ? realTime : schedTime)

    onRealTimeChanged: {
        textZoom.start()
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
