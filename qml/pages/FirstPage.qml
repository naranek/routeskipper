import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/Common.js" as JS

Page {
    id: firstPage

    // for some reason pagestack.pop(null) doesn't work in geocode, so we need to search for this
    property bool isFirstPage: true

    property alias selectedHour: startTime.selectedHour
    property alias selectedMinute: startTime.selectedMinute

    property int selectedDayOffset
    selectedDayOffset: 0

    property alias selectedSourceName: sourceValue.text
    property string selectedSourceCoords

    property alias selectedDestinationName: destinationValue.text
    property string selectedDestinationCoords

    property string timeType: "departure"


    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            /*
            MenuItem {
                text: qsTr("To Map")
                onClicked: pageStack.push(Qt.resolvedUrl("MapTest.qml"), {searchstring: "Otaniemi"})
            } */
            MenuItem {
                text: qsTr("To Dev")
                onClicked: pageStack.push(Qt.resolvedUrl("Dev.qml"))
            }
            MenuItem {
                text: qsTr("To Model Validator")
                onClicked: pageStack.push(Qt.resolvedUrl("RouteModelValidator.qml", { model: routeModel}))
            }

            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
        }

        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: firstPage.width
            spacing: Theme.paddingMedium
            PageHeader {
                title: qsTr("Route Planner")
            }



            BackgroundItem {
                id: sourceBox
                width: column.width
                onClicked: pageStack.push(Qt.resolvedUrl("PlacePicker.qml"), {searchType: "source", parentPage: firstPage})

                Label {
                    id: sourceLabel
                    text: qsTr("From")
                    color: sourceBox.highlighted ? Theme.highlightColor : Theme.primaryColor
                    anchors.verticalCenter: parent.verticalCenter
                    x: Theme.paddingLarge
                }

                Label {
                    id: sourceValue
                    text: qsTr("Select")
                    color: Theme.highlightColor
                    anchors.verticalCenter: sourceLabel.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    font.pixelSize: Theme.fontSizeSmall

                    width: parent.width - sourceLabel.width - 100
                    truncationMode: TruncationMode.Fade
                    horizontalAlignment: Text.AlignRight

                    onTextChanged: {
                        // enable searchbutton
                        if (selectedDestinationCoords != "") doSearch.enabled = true;
                    }
                }

            }

            BackgroundItem {
                id: destinationBox
                width: column.width
                onClicked: pageStack.push(Qt.resolvedUrl("PlacePicker.qml"), {searchType: "destination", parentPage: firstPage})

                Label {
                    id: destinationLabel
                    text: qsTr("To")
                    color: destinationBox.highlighted ? Theme.highlightColor : Theme.primaryColor
                    anchors.verticalCenter: parent.verticalCenter
                    x: Theme.paddingLarge
                }


                Label {
                    id: destinationValue
                    text: qsTr("Select")
                    color: Theme.highlightColor
                    anchors.verticalCenter: destinationLabel.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    font.pixelSize: Theme.fontSizeSmall

                    width: parent.width- destinationLabel.width - 100
                    truncationMode: TruncationMode.Fade
                    horizontalAlignment: Text.AlignRight


                    onTextChanged: {
                        // enable searchbutton
                        if (selectedSourceCoords != "") doSearch.enabled = true;
                    }
                }



            }



            Row {
                width: column.width

                // switch between arrival and departure
                BackgroundItem {
                    id: timeTypeSelector
                    width: parent.width / 3

                    anchors.verticalCenter: startTime.verticalCenter

                    onClicked: {
                        timeType = timeType === "arrival" ? "departure" : "arrival"
                    }

                    Label {
                        text: timeType === "arrival" ? qsTr("Arrival") : qsTr("Departure")
                        color: timeTypeSelector.highlighted ? Theme.highlightColor : Theme.primaryColor
                        anchors.verticalCenter: parent.verticalCenter
                        x: Theme.paddingLarge
                    }


                }

                ValueButton {
                    id: startTime
                    property int selectedHour
                    property int selectedMinute



                    function openTimeDialog() {
                        var dialog = pageStack.push("Sailfish.Silica.TimePickerDialog", {
                                                        hourMode: (DateTime.TwentyFourHours),
                                                        hour: selectedHour,
                                                        minute: selectedMinute,
                                                        allowedOrientations: Orientation.Landscape | Orientation.Portrait | Orientation.LandscapeInverted
                                                    })

                        dialog.accepted.connect(function() {
                            value = dialog.timeText
                            selectedHour = dialog.hour
                            selectedMinute = dialog.minute
                        })
                    }

                    // default is Now
                    selectedHour: Qt.formatDateTime(new Date(), "hh")
                    selectedMinute: Qt.formatDateTime(new Date(), "mm")



                    value: Qt.formatDateTime(new Date(), "hh:mm")
                    width: parent.width / 3
                    onClicked: openTimeDialog()

                }

                // only switch between today and tomorrow, because user is on the move
                // and the only use is for trips home from the bar
                BackgroundItem {
                    id: daySelector
                    width: parent.width / 3

                    anchors.verticalCenter: startTime.verticalCenter

                    onClicked: {
                        selectedDayOffset = selectedDayOffset==1 ? 0 : 1
                    }

                    Label {
                        text: selectedDayOffset == 1 ? qsTr("Tomorrow") : qsTr("Today")
                        color: daySelector.highlighted ? Theme.highlightColor :  Theme.primaryColor
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: Theme.paddingLarge
                    }


                }
            }

            Button {
                id: doSearch
                text: qsTr("Show routes")
      enabled: false
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: pageStack.push(Qt.resolvedUrl("SelectRoute.qml"),
                                          {sourceName: sourceValue.text, destinationName: destinationValue.text,
                                              sourceCoords: selectedSourceCoords, destinationCoords: selectedDestinationCoords,
                                              selectedTime: JS.addZeroPadding(selectedHour) + JS.addZeroPadding(selectedMinute),
                                              selectedDate: JS.hslDate(new Date(), selectedDayOffset),
                                              timeType: timeType,
                                              mainWindow: mainWindow
                                          } )

            }

        }
    }
}


