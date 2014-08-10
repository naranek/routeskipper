import QtQuick 2.0

// hardcoded data for testing
ListModel {
    id: initialRoutes
    // Route
    ListElement {
        type: "route"
        legs: [
            ListElement{
                type: "leg"
                transport: "550"
                startTime: "12:20"
                startPlace: "Otaniemi"
                endTime: "13:10"
                endPlace: "Pasila"
            },
            ListElement{
                type: "leg"
                transport: "14"
                startTime: "13:12"
                startPlace: "Pasila"
                endTime: "14:15"
                endPlace: "Vantaa"
            },
            ListElement{
                type: "leg"
                transport: "A"
                startTime: "14:30"
                startPlace: "Vantaa"
                endTime: "15:10"
                endPlace: "Espoo"
            }
        ]
    }
    // Route
    ListElement {
        type: "route"
        legs: [
            ListElement{
                type: "leg"
                transport: "110"
                startTime: "12:20"
                startPlace: "Otaniemi"
                endTime: "15:20"
                endPlace: "Espoo"
            }
        ]
    }

    // Route
    ListElement {
        type: "route"
        legs: [
            ListElement{
                type: "leg"
                transport: "Kävely"
                startTime: "12:20"
                startPlace: "Otaniemi"
                endTime: "13:10"
                endPlace: "Haaga"
            },
            ListElement{
                type: "leg"
                transport: "550"
                startTime: "13:20"
                startPlace: "Haaga"
                endTime: "16:10"
                endPlace: "Espoo"
            }
        ]
    }
}
