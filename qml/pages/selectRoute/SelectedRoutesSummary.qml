import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import "../../js/DatabaseTools.js" as DbTools
import "../../js/Common.js" as JS
import "../../elements" as Elements

Column {

    property string sourceName
    property string sourceTime
    property string destinationName
    property string destinationTime


    width: parent.width - 2* Theme.paddingLarge
    id: selectedRoutesColumn
    x: Theme.paddingLarge

    Label {
        id: header
        text: qsTr("Routes")
        width: parent.width
        font.pixelSize: Theme.fontSizeLarge
        color: Theme.highlightColor
        horizontalAlignment: Text.AlignRight
    }


    Repeater {
        width: parent.width
        model: selectedLegsModel
        delegate:
            LegRow    {
            lineColor: Theme.highlightColor

            // replace by just passing the model
            startName: StartName
            startTime: StartTime
            realStartTime: RealStartTime
            endTime: EndTime
            realEndTime: RealEndTime

            // only show if the rows are from the previous page
            visible: (typeof CurrentPage === 'undefined' ? false :
                                                           (pageStack.depth == CurrentPage ? false : true)
                      )
        }
    }


    Column {
        id: routeEndColumn
        width: parent.width
        spacing: 0



        Row {
            width: parent.width

            Label  {
                id: routeStart

                // Show selectedTime and selectedName if no previous routes are selected. otherwise use the first of those
                text: JS.prettyTime(sourceTime) + " " + sourceName
                font.pixelSize: Theme.fontSizeMedium
                width: parent.width / 2
                color: Theme.highlightColor
                horizontalAlignment: Text.AlignLeft
                truncationMode: TruncationMode.Fade
            }

            Label  {
                id: routeSummary
                text:  destinationName
                font.pixelSize: Theme.fontSizeMedium
                width: (parent.width ) / 2
                color: Theme.highlightColor
                horizontalAlignment: Text.AlignRight
                truncationMode: TruncationMode.Fade
            }

        }
    }
}

