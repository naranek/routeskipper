import QtQuick 2.0


ListModel {
    id: routeModel

    Component.onCompleted: {
        for (var i = 0; i <= hslRouteXmlList.count ; ++i) {
            routeModel.append(hslRouteXmlList.get(i))
        }
    }
}
