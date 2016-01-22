.import QtQuick.LocalStorage 2.0

function init() {
    var db = LocalStorage.openDatabaseSync("QQmlExampleDB", "1.0", "The Example QML SQL!", 1000000);

    db.transaction(
        function(tx) {
            // Create the database if it doesn't already exist
            tx.executeSql('CREATE TABLE IF NOT EXISTS Greeting(type TEXT, id TEXT)');
        }
    )
}

function addRow(newType, newId) {
    var db = LocalStorage.openDatabaseSync("QQmlExampleDB", "1.0", "The Example QML SQL!", 1000000);
    db.transaction(
        function(tx) {
            tx.executeSql('INSERT INTO Greeting VALUES(?, ?)', [ newType, newId ]);
        }
    )
}

function text(){
    var db = LocalStorage.openDatabaseSync("QQmlExampleDB", "1.0", "The Example QML SQL!", 1000000);
    db.transaction(
        function(tx) {
            var rs = tx.executeSql('SELECT * FROM Greeting');
            var r = ""
            for(var i = 0; i < rs.rows.length; i++) {
                r += rs.rows.item(i).type + ", " + rs.rows.item(i).id + "\n"
            }
            return r
        }
    )
}
