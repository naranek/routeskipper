import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/DatabaseTools.js" as DbTools

Page {
    id: placePickerPage

    // Type can be "source" or "destination"
    property string searchType

    // Reference to the parent page so we get the data back there
    property Item parentPage

    onStatusChanged:  {
        DbTools.getStops(stopsModel)
        DbTools.getFirstLetters(keybModel, searchfield.text)
    }

    signal returnSelection(string Name, string Coords)

    onReturnSelection: {
        // select the correct field to enter data
        if (searchType == "source")
        {
            parentPage.selectedSourceName = Name
            parentPage.selectedSourceCoords = Coords
        }
        else
        {
            parentPage.selectedDestinationName = Name
            parentPage.selectedDestinationCoords = Coords
        }
    }

    ListModel  {
        id: stopsModel
    }

    RemorseItem {
        id: dbCleanRemorse
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: mainColumn.height

        contentWidth: parent.width

        VerticalScrollDecorator {}

        PullDownMenu {
            MenuItem {
                text: qsTr("Delete all stops")
                onClicked: {
                    dbCleanRemorse.execute(mainColumn, qsTr("Deleting all the stops"), function() {
                        DbTools.cleanDb()
                        DbTools.getStops(stopsModel)
                        DbTools.getFirstLetters(keybModel, searchfield.text)
                    })
                }
            }
        }

        PageHeader { id: header ; title: searchType == "source" ? qsTr("Departure") : qsTr("Destination") }

        Column {


            anchors.top: header.bottom
            id: mainColumn
            width: placePickerPage.width
            spacing: Theme.paddingSmall




            TextField {
                id: searchfield
                width: parent.width
                label: qsTr("Address / Place")
                placeholderText: qsTr("Address / Place")
                focus: false
                horizontalAlignment: TextInput.AlignLeft

                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-accept"
                EnterKey.onClicked: {
                    pageStack.push(Qt.resolvedUrl("Geocode.qml"),
                                   {searchstring: searchfield.text, parentPage: placePickerPage} )
                }

                onTextChanged: {
                    DbTools.getStops(stopsModel, searchfield.text)
                    DbTools.getFirstLetters(keybModel, searchfield.text)
                }
            }

            Button {
                id: doSearch
                text: qsTr("Search")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: pageStack.push(Qt.resolvedUrl("Geocode.qml"),
                                          {searchstring: searchfield.text, parentPage: placePickerPage} )
            }

            RemorsePopup {
                id: clearRemorse
            }


            Repeater {

                id: listView
                model: stopsModel

                delegate: ListItem {
                    id: listItem
                    menu: contextMenuComponent
                    function remove(ROWID) {
                        remorseAction("Deleting", function() {
                            // Delete stop and refresh the model
                            DbTools.deleteStop(Name, Coords)
                            DbTools.getStops(stopsModel)
                            DbTools.getFirstLetters(keybModel, searchfield.text)
                        })
                    }

                    ListView.onRemove: animateRemoval()

                    onClicked: {
                        returnSelection(Name, Coords)

                        // Increment use counter and go back to previous page
                        DbTools.incrementUseCounter(Name, Coords)
                        pageStack.pop()
                    }


                    // Place name
                    Label {
                        x: Theme.paddingLarge
                        text: Name
                        anchors.verticalCenter: parent.verticalCenter
                        font.capitalization: Font.Capitalize
                        width: parent.width - vertKeyb.width
                        color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                        truncationMode: TruncationMode.Fade
                    }

                    Component {
                        id: contextMenuComponent
                        ContextMenu {
                            MenuItem {
                                text: "Delete"
                                onClicked: remove()
                            }
                        }
                    }
                }
            }
        }

        ListModel {
            id: keybModel


        }

        Column {
            id: vertKeyb
            width: 70

            spacing: -1

            anchors {
                right: mainColumn.right
                top: mainColumn.top
            }

            Repeater {
                model: keybModel
                delegate:
                    BackgroundItem {
                    id: letterBackground
                    width: 70
                    height: 70


                    Rectangle {
                        anchors.fill: parent

                        color: "transparent"
                        border.color: Theme.primaryColor
                        border.width: 1

                        Label {
                            text: Letter
                            color: letterBackground.highlighted ? Theme.highlightColor :  Theme.primaryColor
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                verticalCenter: parent.verticalCenter
                            }
                        }
                    }

                    onClicked: {
                        searchfield.text = searchfield.text + Letter
                    }
                }
            }
        }
    }
}
