import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import QtQuick.XmlListModel 2.0

Page{

    property string dataURI;
    property string currentType;
    property int currentIndex: -1;
    property string currentId;
    property int limit: 10;
    property int offset: 0;

    function init() {
        var db = LocalStorage.openDatabaseSync("ColorsExplorerDB", "1.0", "", 1000000)
        db.transaction(
            function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS History(id INTEGER PRIMARY KEY, type TEXT, identifier TEXT)')
            }
        )

    }

    function getText(){
        pullDownMenu.visible = false
        pushUpMenu.visible = false
        var db = LocalStorage.openDatabaseSync("ColorsExplorerDB", "1.0", "", 1000000)
        db.transaction(
            function(tx) {
                var rs = tx.executeSql('SELECT * FROM History Orders ORDER BY id DESC LIMIT ' + limit + ' OFFSET ' + offset)
                listModel.clear()
                for(var i = 0; i < rs.rows.length; i++) {
                    var item = {
                        type: "",
                        identifier: "",
                        title: "",
                        userName: "",
                        numViews: "",
                        numVotes: "",
                        numComments: "",
                        numHearts: "",
                        rank: "",
                        dateCreated: "",
                        hex: "",
                        red: "",
                        blue: "",
                        green: "",
                        hue: "",
                        saturation: "",
                        value: "",
                        description: "",
                        url: "",
                        imageUrl: "",
                        badgeUrl: "",
                        apiUrl: "",
                        dateRegistered: "",
                        dateLastActive: "",
                        rating: "",
                        numColors: "",
                        numPalettes: "",
                        numPatterns: "",
                        numCommentsMade: "",
                        numLovers: "",
                        numCommentsOnProfile: ""
                    };
                    item.type = rs.rows.item(i).type
                    if(item.type === 'colors'){
                        item.hex = rs.rows.item(i).identifier
                        console.log('i=' + i + ' type=' + item.type + ' hex=' + item.hex)
                    } else {
                        if(item.type === 'lovers'){
                            item.userName = rs.rows.item(i).identifier
                            console.log('i=' + i + ' type=' + item.type + ' userName=' + item.userName)
                        } else {
                            item.identifier = rs.rows.item(i).identifier
                            console.log('i=' + i + ' type=' + item.type + ' identifier=' + item.identifier)
                        }
                    }
                    listModel.append(item)
                }
                if(rs.rows.length > 0){
                    next()
                    tip.visible = false
                    hintLbl.visible = false
                    listView.visible = true
                }
                else{
                    tip.visible = true
                    hintLbl.visible = true
                    listView.visible = false
                    hint.interactionMode = TouchInteraction.Swipe
                    hint.direction = TouchInteraction.Left
                }
            }
        )
    }

    function clearDb(){
        var db = LocalStorage.openDatabaseSync("ColorsExplorerDB", "1.0", "", 1000000)
        db.transaction(
            function(tx) {
                var rs = tx.executeSql('DELETE FROM History')
            }
        )
        getText()
    }

    function next(){
        console.log("next()")
        console.log('currentIndex=' + currentIndex)
        console.log('limit=' + limit)
        if(currentIndex === limit){
            loadMore()
        } else {
            currentIndex++
            console.log('list.type=' + listModel.get(currentIndex).type)
            console.log('list.hex=' + listModel.get(currentIndex).hex)
            if(listModel.get(currentIndex).type === 'colors'){
                currentType = 'color'
                currentId = listModel.get(currentIndex).hex
            }
            if(listModel.get(currentIndex).type === 'lovers'){
                currentType = 'lover';
                currentId = listModel.get(currentIndex).userName
            }
            if(listModel.get(currentIndex).type === 'patterns'){
                currentType = 'pattern';
                currentId = listModel.get(currentIndex).identifier
            }
            if(listModel.get(currentIndex).type === 'palettes'){
                currentType = 'palette';
                currentId = listModel.get(currentIndex).identifier
            }
            console.log('currentIndex=' + currentIndex + ' currentType=' + currentType + ' currentId=' + currentId)
            loadXml()
        }
    }

    function loadMore(){
        listView.scrollToTop()
        currentIndex = 0
        offset += limit
        getText()
    }

    function loadXml(){
        var req = new XMLHttpRequest();
        dataURI = "http://www.colourlovers.com/api/" + currentType + "/" + currentId
        console.log('load ' + dataURI)
        req.open("get", dataURI);
        req.send();
        req.onreadystatechange = function () {
            if (req.readyState === XMLHttpRequest.DONE) {
                if (req.status === 200) {
                    console.log("req.status === 200")
                    xmlModel.xml = req.responseText;
                    xmlModel.reload();
                } else {
                    console.log("HTTP request failed", req.status)
                    tipLbl.text = "HTTP request failed\nRequest status " + req.status + "\nCheck your Internet connection"
                }
            }
        }
    }

    Component.onCompleted: {
        init()
        getText()
    }

    ListModel{
        id: listModel
    }

    XmlListModel{
        id: xmlModel
        query: '/' + currentType + 's/' + currentType
        XmlRole {name: "id"; query: "id/string()"}
        XmlRole {name: "title"; query: "title/string()"}
        XmlRole {name: "userName"; query: "userName/string()"}
        XmlRole {name: "numViews"; query: "numViews/string()"}
        XmlRole {name: "numVotes"; query: "numVotes/string()"}
        XmlRole {name: "numComments"; query: "numComments/string()"}
        XmlRole {name: "numHearts"; query: "numHearts/string()"}
        XmlRole {name: "rank"; query: "rank/string()"}
        XmlRole {name: "dateCreated"; query: "dateCreated/string()"}
        XmlRole {name: "hex"; query: "hex/string()"}
        XmlRole {name: "red"; query: "rgb/red/string()"}
        XmlRole {name: "blue"; query: "rgb/blue/string()"}
        XmlRole {name: "green"; query: "rgb/green/string()"}
        XmlRole {name: "hue"; query: "hsv/hue/string()"}
        XmlRole {name: "saturation"; query: "hsv/saturation/string()"}
        XmlRole {name: "value"; query: "hsv/value/string()"}
        XmlRole {name: "description"; query: "description/string()"}
        XmlRole {name: "url"; query: "url/string()"}
        XmlRole {name: "imageUrl"; query: "imageUrl/string()"}
        XmlRole {name: "badgeUrl"; query: "badgeUrl/string()"}
        XmlRole {name: "apiUrl"; query: "apiUrl/string()"}
        XmlRole {name: "dateRegistered"; query: "dateRegistered/string()"}
        XmlRole {name: "dateLastActive"; query: "dateLastActive/string()"}
        XmlRole {name: "rating"; query: "rating/string()"}
        XmlRole {name: "numColors"; query: "numColors/string()"}
        XmlRole {name: "numPalettes"; query: "numPalettes/string()"}
        XmlRole {name: "numPatterns"; query: "numPatterns/string()"}
        XmlRole {name: "numCommentsMade"; query: "numCommentsMade/string()"}
        XmlRole {name: "numLovers"; query: "numLovers/string()"}
        XmlRole {name: "numCommentsOnProfile"; query: "numCommentsOnProfile/string()"}
        onStatusChanged: {
            // update page on load new xml
            if(status == XmlListModel.Ready){
                if(count == 1){
                    listModel.set(currentIndex, {
                                      addToHistory: false,
                                      identifier: xmlModel.get(0).id,
                                      title: xmlModel.get(0).title,
                                      userName: xmlModel.get(0).userName,
                                      numViews: xmlModel.get(0).numViews,
                                      numVotes: xmlModel.get(0).numVotes,
                                      numComments: xmlModel.get(0).numComments,
                                      numHearts: xmlModel.get(0).numHearts,
                                      rank: xmlModel.get(0).rank,
                                      dateCreated: xmlModel.get(0).dateCreated,
                                      hex: xmlModel.get(0).hex,
                                      red: xmlModel.get(0).red,
                                      green: xmlModel.get(0).green,
                                      blue: xmlModel.get(0).blue,
                                      hue: xmlModel.get(0).hue,
                                      saturation: xmlModel.get(0).saturation,
                                      value: xmlModel.get(0).value,
                                      description: xmlModel.get(0).description,
                                      url: xmlModel.get(0).url,
                                      imageUrl: xmlModel.get(0).imageUrl,
                                      badgeUrl: xmlModel.get(0).badgeUrl,
                                      apiUrl: xmlModel.get(0).apiUrl,
                                      dateRegistered: xmlModel.get(0).dateRegistered,
                                      dateLastActive: xmlModel.get(0).dateLastActive,
                                      rating: xmlModel.get(0).rating,
                                      location: xmlModel.get(0).location,
                                      numColors: xmlModel.get(0).numColors,
                                      numPalettes: xmlModel.get(0).numPalettes,
                                      numPatterns: xmlModel.get(0).numPatterns,
                                      numCommentsMade: xmlModel.get(0).numCommentsMade,
                                      numLovers: xmlModel.get(0).numLovers,
                                      numCommentsOnProfile: xmlModel.get(0).numCommentsOnProfile
                                  })
                    if(currentIndex + 1 != listModel.count){ // when not all items loaded
                        next()
                    } else { // when all items loaded
                        pullDownMenu.visible = true
                        pushUpMenu.visible = true
                    }
                }
            }
        }
    }

    SilicaListView{
        id: listView
        width: parent.width
        height: parent.height
        header: PageHeader {
            id: header
            title: qsTr("History")
        }
        model : listModel
        delegate: BackgroundItem {
            width: parent.width
            height: typeLbl.height * 3
            Image{
                visible: (type === 'lovers') ? false : true
                id: image
                onProgressChanged: progressCircle.value = progress
                onStatusChanged: {
                    if(status == Image.Ready){
                        progressCircle.visible = false
                    }
                }
                fillMode: Image.Tile
                source: model.imageUrl
                anchors.fill: parent
                ProgressCircle {
                    id: progressCircle
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            Rectangle{
                width: parent.width
                height: parent.height
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#aa000000" }
                    GradientStop { position: 0.7; color: "#00000000" }
                }
                Column{
                    Label {
                        id: typeLbl
                        y: 10
                        x: Theme.horizontalPageMargin
                        color: "#ffffff"
                        font.pixelSize: Theme.fontSizeExtraSmall
                        text: (type === 'lovers') ? 'UserName: ' + model.userName : 'Name: ' + model.title
                    }
                    Label{
                        visible: (type === 'lovers') ? false : true
                        x: Theme.horizontalPageMargin
                        font.pixelSize: Theme.fontSizeExtraSmall
                        color: "#eeeeee"
                        text: (numViews == 1) ? "VIEW " + numViews : "VIEWS " + numViews
                    }
                    Label{
                        visible: (type === 'lovers') ? false : true
                        x: Theme.horizontalPageMargin
                        font.pixelSize: Theme.fontSizeExtraSmall
                        color: "#eeeeee"
                        text: (numHearts == 1) ? "LOVE " + numHearts : "LOVES " + numHearts
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        pageStack.push("ItemPage.qml", {
                                           addToHistory: false,
                                           id: identifier,
                                           tittle: title,
                                           userName: userName,
                                           numViews: numViews,
                                           numVotes: numVotes,
                                           numComments: numComments,
                                           numHearts: numHearts,
                                           dateCreated: dateCreated,
                                           hex: hex,
                                           red: red,
                                           blue: blue,
                                           green: green,
                                           hue: hue,
                                           saturation: saturation,
                                           value: value,
                                           description: description,
                                           url: url,
                                           imageUrl: imageUrl,
                                           badgeUrl: badgeUrl,
                                           apiUrl: apiUrl,
                                           type: type,
                                           dateRegistered: dateRegistered,
                                           dateLastActive: dateLastActive,
                                           rating: rating,
                                           numColors: numColors,
                                           numPalettes: numPalettes,
                                           numPatterns: numPatterns,
                                           numCommentsMade: numCommentsMade,
                                           numLovers: numLovers,
                                           numCommentsOnProfile: numCommentsOnProfile,
                                           url: url,
                                           apiUrl: apiUrl,
                                           type: type })
                    }
                }
            }
        }
        VerticalScrollDecorator {}
        PullDownMenu{
            id: pullDownMenu
            MenuItem{
                text: qsTr("Clear")
                onClicked: remorse.execute("Clearing history", clearDb )
                RemorsePopup { id: remorse }
            }
        }
        PushUpMenu{
            id: pushUpMenu
            MenuItem {
                text: qsTr("Load more")
                onClicked: loadMore()
            }
            MenuItem{
                text: qsTr("To top")
                onClicked: listView.scrollToTop()
            }
        }
    }

    Rectangle{
        anchors.fill: parent
        color: 'transparent'
        visible: false
        id: tip
        Label {
            id: tipLbl
            font.pixelSize: 32
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.highlightColor
            text: qsTr("There wil be your\nlocal history.\nNow here is empty")
        }

        TouchInteractionHint {
            id: hint
            loops: Animation.Infinite
        }
    }

    InteractionHintLabel {
        id: hintLbl
        visible: false
        anchors.bottom: parent.bottom
        text: qsTr("Flick right to return to explore")
    }

}

