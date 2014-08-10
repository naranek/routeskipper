import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: routePage

    ListModel {
        id: iconLicenses
        ListElement {icon: "logo"; by: "Freepik.com"; lic: "CC BY 3.0"}
        ListElement {icon: "icon-bus"; by: "Freepik.com"; lic: "CC BY 3.0"}
        ListElement {icon: "icon-walk"; by: "Freepik.com"; lic: "CC BY 3.0"}
        ListElement {icon: "icon-metro"; by: "Freepik.com"; lic: "CC BY 3.0"}
        ListElement {icon: "icon-ferry"; by: "Freepik.com"; lic: "CC BY 3.0"}
        ListElement {icon: "icon-tram"; by: "Icons8"; lic: "CC BY 3.0"}
        ListElement {icon: "icon-wait"; by: "Freepik.com"; lic: "CC BY 3.0"}
        ListElement {icon: "icon-train"; by: "Scott de Jonge"; lic: "CC BY 3.0"}
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        contentHeight: column.height
        width: parent.width

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            spacing: Theme.paddingMedium
            width: parent.width - 2* Theme.paddingLarge
            x: Theme.paddingLarge

            PageHeader {
                title: "About RouteSkipper"
            }

            Label {
                font.pixelSize: Theme.fontSizeExtraSmall
                wrapMode: Text.WordWrap
                text: "RouteSkipper is made by Jarmo Lahtiranta (@naranek) and licensed under GNU GPL v3.0"
                width: parent.width
            }

            PageHeader {
                title: "Icons"
            }

            Label {
                font.pixelSize: Theme.fontSizeExtraSmall
                text: "All icons are from Flaticon.com"
            }

            Repeater {
                model: iconLicenses
                width: parent.width

                delegate: Row{
                    width: parent.width
                    spacing: 10

                    Image {
                        id: image
                        width: Theme.iconSizeSmall; height: Theme.iconSizeSmall
                        fillMode: Image.PreserveAspectFit
                        smooth: true

                        source: "qrc:" + icon
                    }
                    Label {
                        font.pixelSize: Theme.fontSizeExtraSmall
                        wrapMode: Text.WordWrap
                        width: parent.width - image.width
                        text: "Icon by " + by + " licensed under " + lic
                    }
                }
            }

        }
    }
}
