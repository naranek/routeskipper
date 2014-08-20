# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-routeskipper

CONFIG += sailfishapp

SOURCES += src/harbour-routeskipper.cpp

OTHER_FILES += qml/harbour-routeskipper.qml \
    qml/pages/FirstPage.qml \
    rpm/harbour-routeskipper.changes.in \
    rpm/harbour-routeskipper.spec \
    rpm/harbour-routeskipper.yaml \
    translations/*.ts \
    harbour-routeskipper.desktop \
    qml/pages/SelectRoute.qml \
    qml/pages/Dev.qml \ 
    qml/pages/PlacePicker.qml \
    qml/pages/Geocode.qml \    
    qml/pages/LayoutTest.qml \
    qml/elements/LineShield.qml \
    qml/elements/SelectedRoutesSummary.qml \
    qml/js/HSL-functions.js \
    qml/js/DatabaseTools.js \  
    qml/elements/LegRow.qml \
    qml/pages/CoverPage.qml \
    qml/models/HslLegsXmlList.qml \
    qml/models/HslWaypointsXmlList.qml \
    qml/models/HslRoutesXmlList.qml \
    qml/models/SelectedLegs.qml \
    qml/models/SelectedWaypoints.qml \
    qml/pages/MapTest.qml \
    qml/elements/LineBreadCrumbs.qml \
    qml/pages/About.qml \
    README.md \
    qml/models/Credentials.qml \
    qml/elements/Clock.qml \
    qml/js/Common.js \
    qml/elements/LineIcon.qml \
    translations/harbour-routeskipper-fi.ts \
    qml/elements/RouteMinimized.qml \
    qml/models/KamoNextDepartures.qml \
    qml/models/KamoLineId.qml \
    qml/js/KAMO-functions.js \
    qml/models/KamoPassingTimes.qml \
    qml/elements/TimeView.qml \
    qml/pages/selectRoute/RoutesSummary.qml \
    qml/pages/selectRoute/LegRow.qml \
    qml/pages/selectRoute/RouteMinimized.qml \
    qml/pages/selectRoute/SelectedRoutesSummary.qml \
    qml/pages/selectRoute/CurrentRouteDetails.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-routeskipper-fi.ts

RESOURCES += \
    icons.qrc

