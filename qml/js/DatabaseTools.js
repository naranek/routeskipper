.import QtQuick.LocalStorage 2.0 as Ls

var dbName = "SailSkipRouter"
var dbDescription = dbName
var dbVersion = "1.0"

// Estimated size of DB in bytes. Just a hint for the engine and is ignored as of Qt 5.0 I think
var estimatedSize = 10000

function cleanDb() {
    var db = Ls.LocalStorage.openDatabaseSync(dbName, dbVersion, dbDescription, estimatedSize);
    db.transaction(
                function(tx) {
                    tx.executeSql("DROP TABLE IF EXISTS Stops");
                }
                );
}

function getPreparedDatabase() {
    var db = Ls.LocalStorage.openDatabaseSync(dbName, dbVersion, dbDescription, estimatedSize);
    db.transaction(
                function(tx) {
                    //                console.log ("Trying to create new table")
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(Name TEXT, Coords TEXT, Favourite INTEGER, UseCounter INTEGER, PRIMARY KEY(Name, Coords))');
                }
                );
    return db;
}



/**
     * @param name string Name of the point
     * @param coords string Coordinates of the point (1234,4312)
     * @return true on success, false otherwise
     */
function addStop(name, coords) {
    var res = false;
    var db = getPreparedDatabase();
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('INSERT OR REPLACE INTO Stops VALUES (?,?,?,?);', [name, coords,0,0]);
                    //                console.log(rs.rowsAffected)
                    if (rs.rowsAffected > 0) {
                        res = true;
                    } else {
                        //@TODO handle error on saving
                        console.error("ERROR: DbStops: Failed to save name,value: " +name + ", " +coords);
                    }
                }
                );
    return res;
}

/**
     * @param name string Name of the point
     * @param coords string Coordinates of the point (1234,4312)
     * @return true on success, false otherwise
     */
function deleteStop(name, coords) {
    return generalStopQuery(name, coords, "DELETE FROM Stops");
}

/**
     * @param name string Name of the point
     * @param coords string Coordinates of the point (1234,4312)
     * @param operation string Beginning of the SQL query (Select, Update, Delete)
     * @return true on success, false otherwise
     */
function generalStopQuery(name, coords, operation) {
    var res = false;
    var db = getPreparedDatabase();
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql(operation + ' WHERE Name = ? and Coords = ?;', [name, coords]);
                    //                console.log(rs.rowsAffected)
                    if (rs.rowsAffected > 0) {
                        res = true;
                    } else {
                        //@TODO handle error on saving
                        console.error("ERROR: DbStops: Failed to do operation: " + operation+ ", name: " + name + ", coords:" + coords);
                    }
                }
                );
    return res;
}

/* Increment the usecounter */

function incrementUseCounter(name, coords) {
    return generalStopQuery(name, coords, "UPDATE Stops SET UseCounter = (select max(UseCounter)+1 from Stops)");
}

/**
     * @param model stopsModel The model that is used to handle the data
     * @param string filter Only select rows that begin with the filter text
     * @return Value saved at a given name or defaultValue if not found or undefined if not found and
     *               defaultValue is not specified
     */
function getStops(stopsModel, filter) {

    var db = getPreparedDatabase();


    // clear model in case we've filled it up earlier
    stopsModel.clear()

    db.transaction(
                function(tx) {
                    if (!filter)
                    {
                        var rs = tx.executeSql('SELECT Name, Coords, Favourite, UseCounter FROM stops ORDER BY UseCounter DESC');
                    }
                    else
                    {
                        var rs = tx.executeSql('SELECT Name, Coords, Favourite, UseCounter FROM stops WHERE Name LIKE ? ORDER BY UseCounter DESC', [filter + "%"]);
                    }

                    for(var i = 0; i < rs.rows.length; i++) {
                        stopsModel.append({"Name":  rs.rows.item(i).Name, "Coords": rs.rows.item(i).Coords, "Favourite": rs.rows.item(i).Favourite, "UseCounter": rs.rows.item(i).UseCounter})
                    }

                }
                );
    return stopsModel;
}

/**
 * @param model stopsModel The model that is used to handle the data
 * @param string filter Only select rows that begin with the filter text
 * @return Value saved at a given name or defaultValue if not found or undefined if not found and
 *               defaultValue is not specified
 */
function getFirstLetters(keyboardModel, filter) {

    var db = getPreparedDatabase();


    // clear model in case we've filled it up earlier
    keyboardModel.clear()

    db.transaction(
                function(tx) {

                    var rs = tx.executeSql('SELECT DISTINCT UPPER(SUBSTR(Name, ?, 1)) as Letter  FROM stops WHERE Name LIKE ? ORDER BY Name ASC', [filter.length+1, filter + "%"]);


                    for(var i = 0; i < rs.rows.length; i++) {

                        keyboardModel.append({"Letter":  rs.rows.item(i).Letter})
                    }

                }
                );
    return stopsModel;
}

