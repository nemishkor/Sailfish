import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import QtGraphicalEffects 1.0

Page {
    id: page

    property bool innactive: false;

    onStatusChanged: {
        if (status == 0){
            innactive = true
        }
        if(innactive && status === 2){
            console.log("PageStack.back2")
            innactive = false
        }
    }

    XmlListModel{
        id: listModel
        query: path
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
        onStatusChanged: {
            if(status == XmlListModel.Ready){
                if(count == 1){
                    if(category == "Random"){
                        pageStack.push("ItemPage.qml", {
                                           id: listModel.get(0).id,
                                           category: category,
                                           tittle: listModel.get(0).title,
                                           userName: listModel.get(0).userName,
                                           numViews: listModel.get(0).numViews,
                                           numVotes: listModel.get(0).numVotes,
                                           numComments: listModel.get(0).numComments,
                                           numHearts: listModel.get(0).numHearts,
                                           dateCreated: listModel.get(0).dateCreated,
                                           hex: listModel.get(0).hex,
                                           red: listModel.get(0).red,
                                           blue: listModel.get(0).blue,
                                           green: listModel.get(0).green,
                                           hue: listModel.get(0).hue,
                                           saturation: listModel.get(0).saturation,
                                           value: listModel.get(0).value,
                                           description: listModel.get(0).description,
                                           url: listModel.get(0).url,
                                           imageUrl: listModel.get(0).imageUrl,
                                           badgeUrl: listModel.get(0).badgeUrl,
                                           apiUrl: listModel.get(0).apiUrl,
                                           type: listModel.get(0).type })
                    }
                }
                if(count === 0){
                    noResultLbl.visible = true
                } else {
                    noResultLbl.visible = false
                }
            }
        }
    }

    XmlListModel{
        id: loversModel
        query: path
        XmlRole {name: "userName"; query: "userName/string()"}
        XmlRole {name: "dateRegistered"; query: "dateRegistered/string()"}
        XmlRole {name: "dateLastActive"; query: "dateLastActive/string()"}
        XmlRole {name: "rating"; query: "rating/string()"}
        XmlRole {name: "numColors"; query: "numColors/string()"}
        XmlRole {name: "numPalettes"; query: "numPalettes/string()"}
        XmlRole {name: "numPatterns"; query: "numPatterns/string()"}
        XmlRole {name: "numCommentsMade"; query: "numCommentsMade/string()"}
        XmlRole {name: "numLovers"; query: "numLovers/string()"}
        XmlRole {name: "numCommentsOnProfile"; query: "numCommentsOnProfile/string()"}
        XmlRole {name: "url"; query: "url/string()"}
        XmlRole {name: "apiUrl"; query: "apiUrl/string()"}
        onStatusChanged: {
            if(status == XmlListModel.Ready)
                loadingModel.visible = false
        }
    }

    property string titlePage;

    property string type;
    property string category;
    property string path;
    property int heightDelegate: 150;
    property int resultOffset: 0;
    property string dataURI;

    // filters
    property int hueMin: 0
    property int hueMax: 359
    property int briMin: 0
    property int briMax: 99
    property string lover
    property string keywords
    property string orderCol
    property string sortBy

    function loadXml(){
        listModel.xml = ""
        listModel.reload()
        dataURI = "http://www.colourlovers.com/api/" + type + "/" + category + "?numResults=20" + "&resultOffset=" + resultOffset + "&orderCol=" + orderCol + "&sortBy=" + sortBy + "&lover=" + lover + "&keywords=" + keywords
        if(type === "colors")
            dataURI += "&hueRange=" + hueMin + "," + hueMax + "&briRange=" + briMin + "," + briMax
        console.log(dataURI)
        var req = new XMLHttpRequest()
        req.open("get", dataURI)
        req.send()
        req.onreadystatechange = function () {
            if (req.readyState === XMLHttpRequest.DONE) {
                if (req.status === 200) {
                    if(type == "lovers"){
                        loversModel.xml = req.responseText
                        loversModel.reload()
                    } else {
                        listModel.xml = req.responseText
                        listModel.reload()
                    }
                    if(listModel.count == 1){
                        heightDelegate = page.height
                    }
                    if(type == "lovers")
                        loversListView.visible = true
                    else
                        listView.visible = true
                } else {
                    console.log("HTTP request failed", req.status)
                    loadLbl.text = "HTTP request failed\nRequest status " + req.status + "\nCheck your Internet connection"
                }
            }
        }
    }

    Component.onCompleted: {
        loadXml()
    }

    ProgressBar {
        id: loadingModel
        width: parent.width
        height: 50
        indeterminate: true
        label: qsTr("Loading")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        Label{
            id: loadLbl
            anchors.top: parent.bottom
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: TextEdit.WordWrap
        }
    }

    Label{
        id: noResultLbl
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        visible: false
        horizontalAlignment: Text.AlignHCenter
        text: qsTr("Nothing found.\nTry reset or change filters")
        wrapMode: TextEdit.WordWrap
    }

    SilicaListView
    {
        id: listView
        visible: (type == "lovers") ? false : true
        width: parent.width
        height: parent.height
        header: PageHeader {
            id: header
            title: titlePage

            IconButton {
                icon.source: 'image://theme/icon-m-search'
                onClicked: {
                    var dialog = pageStack.push("../dialogs/RangeDialog.qml", {
                                                    type: type,
                                                    hueMin: hueMin,
                                                    hueMax: hueMax,
                                                    briMin: briMin,
                                                    briMax: briMax,
                                                    lover: lover,
                                                    keywords: keywords,
                                                    orderCol: orderCol,
                                                    sortBy: sortBy,
                                                })
                    dialog.accepted.connect(function() {
                        var reload = false
                        if(orderCol !== dialog.orderCol || sortBy !== dialog.sortBy || keywords !== dialog.keywords || lover !== dialog.lover || hueMin !== dialog.hueMin || hueMax !== dialog.hueMax || briMin !== dialog.briMin || briMax !== dialog.briMax){
                            reload = true
                        }
                        orderCol = dialog.orderCol
                        sortBy = dialog.sortBy
                        keywords = dialog.keywords
                        lover = dialog.lover
                        hueMin = dialog.hueMin
                        hueMax = dialog.hueMax
                        briMin = dialog.briMin
                        briMax = dialog.briMax
                        if(reload)
                            loadXml()
                    })
                }
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 2 - 40
            }
        }

        model : listModel
        delegate: BackgroundItem {
            width: parent.width
            height: heightDelegate
            Image{
                id: image
                onProgressChanged: progressCircle.value = progress
                onStatusChanged: {
                    if(status == Image.Ready){
                        progressCircle.visible = false
                        loadingModel.visible = false
                    }
                }
                fillMode: Image.Tile
                source: imageUrl
                anchors.fill: parent
                ProgressCircle {
                    id: progressCircle
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                MouseArea{

                    anchors.fill: parent
                    onClicked: {
                        pageStack.push("ItemPage.qml", {
                                           id: id,
                                           category: category,
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
                                           type: type })
                    }
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
                    Label{
                        x: 20
                        y: 10
                        color: "#ffffff"
                        text: title
                    }
                    Label{
                        x: 20
                        font.pixelSize: Theme.fontSizeExtraSmall
                        color: "#eeeeee"
                        text: (numViews == 1) ? "VIEW " + numViews : "VIEWS " + numViews
                    }
                    Label{
                        x: 20
                        font.pixelSize: Theme.fontSizeExtraSmall
                        color: "#eeeeee"
                        text: (numHearts == 1) ? "LOVE " + numHearts : "LOVES " + numHearts
                    }
                }
            }
        }


        VerticalScrollDecorator {}
        PushUpMenu{
            MenuItem {
                text: qsTr("Load more")
                onClicked: {
                    resultOffset += 20
                    listView.scrollToTop()
                    listView.visible = false;
                    loadingModel.visible = true;
                    loadXml()
                    listView.visible = true;
                }
            }
            MenuItem{
                text: qsTr("To top")
                onClicked: listView.scrollToTop()
            }
        }

    }


    SilicaListView
    {
        id: loversListView
        visible: (type == "lovers") ? true : false
        width: parent.width
        height: parent.height
        header: PageHeader {
            id: loversHeader
            title: qsTr(titlePage)
        }
        model : loversModel
        delegate: BackgroundItem {
            width: parent.width
            height: 100
            Label{
                text: userName
                x: Theme.horizontalPageMargin
                anchors.verticalCenter: parent.verticalCenter
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("ItemPage.qml"), {
                                       userName: userName,
                                       category: category,
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


        VerticalScrollDecorator {}
        PushUpMenu{
            MenuItem {
                text: qsTr("Load more")
                onClicked: {
                    resultOffset += 20
                    loversListView.scrollToTop()
                    loversListView.visible = false;
                    loadingModel.visible = true;
                    loadXml()
                    loversListView.visible = true;
                }
            }
            MenuItem{
                text: qsTr("To top")
                onClicked: loversListView.scrollToTop()
            }
        }

    }


}


