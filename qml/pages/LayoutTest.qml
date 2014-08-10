import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        // Why is this necessary?
        contentWidth: parent.width


        // Rectangle { anchors.fill: parent; color: "red"; opacity: 0.3; z:-1; visible: true }

        VerticalScrollDecorator {}

        ListModel {
            id: myModel
            ListElement { texti: "1. Eka"}
            ListElement { texti: "2. Toka" }
            ListElement { texti: "3. Kolmas" }
            ListElement { texti: "4. Neljäskin" }
        }

        Column {
            id: column
            spacing: 0
            width: parent.width
            PageHeader {
                title: "Oskelantie 3"
            }
            SectionHeader {
                text: "Valitut reitit"
            }

            Column {
                id: routesColumn
                Repeater {
                    id: routeRepeater
                    model: myModel

                    BackgroundItem {
                        id: sourceBox
                        width: column.width
                        height: 80


                        // define the settings for minimized BackgroundItem
                        states: [
                            State {
                                name: "minimized"
                                PropertyChanges {
                                    target: sourceBox
                                    height: sourceLabel.height
                                }
                            }
                        ]

                        // add a sliding transition because we can
                        transitions: Transition {
                                 PropertyAnimation { properties: "height"; duration: 100 }
                             }


                        onClicked: {
                            // minimize all other items except the one clicked
                            for (var i = 0; i < myModel.count; ++i) {
                                if (i != index) {
                                    routeRepeater.itemAt(i).state = "minimized"
                                }   else {
                                    routeRepeater.itemAt(i).state = ""
                                }
                            }
                        }


                        Rectangle { anchors.fill: parent; color: "red"; opacity: 0.3; z:-1; visible: true }


                        Label {
                            id: sourceLabel
                            text: texti
                            color: sourceBox.highlighted ? Theme.highlightColor : Theme.primaryColor
                            anchors.verticalCenter: parent.verticalCenter
                            x: Theme.paddingLarge


                            Rectangle { anchors.fill: parent; color: "blue"; opacity: 0.3; z:-1; visible: true }
                        }

                    }
                 }
            }

            // show details on the selected route
            Column {
               id: routeDetails

               SectionHeader {
                   text: "Valittu reitti"
               }

               Label {
                   text: "Siis täällä"
               }
            }
        }
    }
}
