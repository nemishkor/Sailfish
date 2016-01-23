/****************************************************************************************
**
** Copyright (C) 2013 Jolla Ltd.
** Contact: Martin Jones <martin.jones@jollamobile.com>
** All rights reserved.
**
** This file is part of Sailfish Silica UI component package.
**
** You may use this file under the terms of BSD license as follows:
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are met:
**     * Redistributions of source code must retain the above copyright
**       notice, this list of conditions and the following disclaimer.
**     * Redistributions in binary form must reproduce the above copyright
**       notice, this list of conditions and the following disclaimer in the
**       documentation and/or other materials provided with the distribution.
**     * Neither the name of the Jolla Ltd nor the
**       names of its contributors may be used to endorse or promote products
**       derived from this software without specific prior written permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
** ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
** WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
** DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
** ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
** LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
** ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
** SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
****************************************************************************************/

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import QtQuick.XmlListModel 2.0


Page {

    // START for stats section
    property int currentStatsLoad: 0;

    function loadStats(category){
        var dataURI = "http://www.colourlovers.com/api/stats/" + category
        var req = new XMLHttpRequest()
        req.open("get", dataURI)
        req.send()
        req.onreadystatechange = function () {
            if (req.readyState === XMLHttpRequest.DONE) {
                if (req.status === 200) {
                    statsModel.xml = req.responseText
                    currentStatsLoad++
                    statsModel.reload()
                } else {
                    console.log("HTTP request failed", req.status)
                    loadLbl.text = "HTTP request failed\nRequest status " + req.status + "\nCheck your Internet connection"
                }
            }
        }
    }

    // START HISTORY AND FAVORITES

    property string currentType;
    property string dataURI;
    property string table: 'History';

    function lastViwed(){
        var db = LocalStorage.openDatabaseSync("ColorsExplorerDB", "1.0", "", 1000000)
        db.transaction(
            function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS  ' + table + '(id INTEGER PRIMARY KEY, type TEXT, identifier TEXT)')
                var rs = tx.executeSql('SELECT * FROM ' + table + ' Orders ORDER BY id DESC LIMIT 1')
                if(rs.rows.length > 0){
                    console.log('rs.rows.length > 0')
                    if(rs.rows.item(0).type === 'colors')
                        currentType = 'color'
                    if(rs.rows.item(0).type === 'lovers')
                        currentType = 'lover'
                    if(rs.rows.item(0).type === 'patterns')
                        currentType = 'pattern'
                    if(rs.rows.item(0).type === 'palettes')
                        currentType = 'palette'
                    var req = new XMLHttpRequest()
                    dataURI = "http://www.colourlovers.com/api/" + currentType + "/" + rs.rows.item(0).identifier
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
                            }
                        }
                    }
//                    if(table === 'History'){
//                        lastProgressCircle.visible = true
//                        lastImage.visible = true
//                    } else {
//                        lastFavoriteProgressCircle.visible = true
//                        lastFavoriteImage.visible = true
//                    }
                } else {
//                    if(table === 'History'){
//                        lastProgressCircle.visible = false
//                        lastImage.visible = false
//                    } else {
//                        lastFavoriteProgressCircle.visible = false
//                        lastFavoriteImage.visible = false
//                    }
                }
            }
        )
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
        XmlRole {name: "imageUrl"; query: "imageUrl/string()"}
        onStatusChanged: {
            // update page on load new xml
            if(status == XmlListModel.Ready){
                if(count == 1){
                    if(currentType === 'lovers'){
                        if(table === 'History')
                            historyLastLbl.text += "\n" + xmlModel.get(0).userName
                        else
                            favoriteLastLbl.text += "\n" + xmlModel.get(0).userName
                    } else {
                        if(table === 'History')
                            lastImage.source = xmlModel.get(0).imageUrl
                        else
                            lastFavoriteImage.source = xmlModel.get(0).imageUrl
                    }
                }
                if(table === 'History'){
                    table = 'Favorites'
                    lastViwed()
                }
            }
        }
    }

    // END HISTORY AND FAVORITES

    XmlListModel{
        id: statsModel
        query: "/stats"
        XmlRole {name: "total"; query: "total/string()"}
        onStatusChanged: {
            if(status == XmlListModel.Ready){
                switch(currentStatsLoad){
                case 1:
                    totalColorsLbl.text += get(0).total
                    loadStats("palettes")
                    break;
                case 2:
                    totalPalettesLbl.text += get(0).total
                    loadStats("patterns")
                    break;
                case 3:
                    totalPatternsLbl.text += get(0).total
                    loadStats("lovers")
                    break;
                case 4:
                    totalLoversLbl.text += get(0).total
                    break;
                }
            }
        }
    }
    // END for stats section

    Component.onCompleted: {
        loadStats("colors")
        lastViwed()
    }

    id: coverPage
    orientation: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu{
            MenuItem{
                text: qsTr("About")
                onClicked: pageStack.push("AboutPage.qml")
            }
            MenuItem{
                text: qsTr("History")
                onClicked: pageStack.push("HistoryPage.qml")
            }
            MenuItem{
                text: qsTr("Favorites")
                onClicked: pageStack.push("FavoritesPage.qml")
            }
        }

        Column {
            id: column
            width: parent.width

            PageHeader {
                title: "Colors explorer"
            }

            Image{
                fillMode: Image.TileHorizontally
                source: "qrc:/main/colors-bg.png"
                width: parent.width
                height: 1
            }

            // CATEGORIES -----------------------------------------------

            SectionHeader{
                text: qsTr("Categories")
            }

            ComboBox {
                id: colorsMenuItem
                Image{
                    width: parent.width; height: parent.height - 2 * Theme.paddingSmall
                    fillMode: Image.PreserveAspectFit
                    horizontalAlignment: Image.AlignRight
                    source: "qrc:/main/preview-category-color.png"
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    anchors.topMargin: Theme.paddingSmall
                }
                label: "Colors"
                currentIndex: -1
                width: parent.width
                onCurrentIndexChanged: { _clearCurrent() }
                menu: ContextMenu {
                    MenuItem {
                        text: "New"
                        onClicked: {
                            pageStack.push("ListPage.qml", {
                                               type: "colors",
                                               path: "/colors/color",
                                               category: text,
                                               title: "New colors", })
                        }
                    }
                    MenuItem {
                        text: "Top"
                        onClicked: {
                            pageStack.push("ListPage.qml", {
                                               type: "colors",
                                               path: "/colors/color",
                                               category: text,
                                               title: "Top colors", })
                        }
                    }
                    MenuItem {
                        text: "Random"
                        onClicked: {
                            pageStack.push("ItemPage.qml", {
                                               type: "colors",
                                               path: "/colors/color",
                                               category: text,
                                               title: "Random color", })
                        }
                    }
                }
            }

            ComboBox {
                id: palettesMenuItem
                Image{
                    width: parent.width; height: parent.height - 2 * Theme.paddingSmall
                    fillMode: Image.PreserveAspectFit
                    horizontalAlignment: Image.AlignRight
                    source: "qrc:/main/preview-category.png"
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    anchors.topMargin: Theme.paddingSmall
                }
                label: "Palettes"
                currentIndex: -1
                width: parent.width
                onCurrentIndexChanged: { _clearCurrent() }
                menu: ContextMenu {
                    MenuItem {
                        text: "New"
                        onClicked: {
                            pageStack.push("ListPage.qml", {
                                               type: "palettes",
                                               path: "/palettes/palette",
                                               heightDelegate: 220,
                                               category: text,
                                               title: "New palettes", })
                        }
                    }
                    MenuItem {
                        text: "Top"
                        onClicked: {
                            pageStack.push("ListPage.qml", {
                                               type: "palettes",
                                               path: "/palettes/palette",
                                               heightDelegate: 220,
                                               category: text,
                                               title: "Top palettes", })
                        }
                    }
                    MenuItem {
                        text: "Random"
                        onClicked: {
                            pageStack.push("ItemPage.qml", {
                                               type: "palettes",
                                               path: "/palettes/palette",
                                               category: text,
                                               title: "Random palette", })
                        }
                    }
                }
            }

            ComboBox {
                id: patternsMenuItem
                Image{
                    width: parent.width; height: parent.height - 2 * Theme.paddingSmall
                    fillMode: Image.PreserveAspectFit
                    horizontalAlignment: Image.AlignRight
                    source: "qrc:/main/preview-category-patterns.png"
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    anchors.topMargin: Theme.paddingSmall
                }
                label: "Patterns"
                currentIndex: -1
                width: parent.width
                onCurrentIndexChanged: { _clearCurrent() }
                menu: ContextMenu {
                    MenuItem {
                        text: "New"
                        onClicked: {
                            pageStack.push("ListPage.qml", {
                                               type: "patterns",
                                               path: "/patterns/pattern",
                                               heightDelegate: 220,
                                               category: text,
                                               title: "New patterns", })
                        }
                    }
                    MenuItem {
                        text: "Top"
                        onClicked: {
                            pageStack.push("ListPage.qml", {
                                               type: "patterns",
                                               path: "/patterns/pattern",
                                               heightDelegate: 220,
                                               category: text,
                                               title: "Top patterns", })
                        }
                    }
                    MenuItem {
                        text: "Random"
                        onClicked: {
                            pageStack.push("ItemPage.qml", {
                                               type: "patterns",
                                               path: "/patterns/pattern",
                                               category: text,
                                               title: "Random pattern", })
                        }
                    }
                }
            }

            ComboBox {
                id: loversMenuItem
                label: "Lovers"
                currentIndex: -1
                width: parent.width
                onCurrentIndexChanged: { _clearCurrent() }
                menu: ContextMenu {
                    MenuItem {
                        text: "New"
                        onClicked: {
                            pageStack.push("ListPage.qml", {
                                               type: "lovers",
                                               path: "/lovers/lover",
                                               category: text,
                                               title: "New lovers", })
                        }
                    }
                    MenuItem {
                        text: "Top"
                        onClicked: {
                            pageStack.push("ListPage.qml", {
                                               type: "lovers",
                                               path: "/lovers/lover",
                                               category: text,
                                               title: "Top lovers", })
                        }
                    }
                }
            }

            // TOOLS -----------------------------------------------

            SectionHeader{
                text: qsTr("Tools")
            }
            BackgroundItem {
                width: parent.width
                Label {
                    id: firstName
                    text: qsTr("Color selector")
                    anchors.verticalCenter: parent.verticalCenter
                    x: Theme.horizontalPageMargin
                }
                onClicked: pageStack.push("ColorsSelectorPage.qml")
            }

            // HISTORY AND FAVORITES -------------------------------

            Rectangle{
                color: 'transparent'
                width: parent.width
                height: width / 2
                Image{
                    id: lastImage
                    width: parent.width / 2
                    height: parent.height
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    fillMode: Image.Tile
                    onProgressChanged: lastProgressCircle.value = progress
                    onStatusChanged: {
                        if(status == Image.Ready){
                            lastProgressCircle.visible = false
                        }
                    }
                    ProgressCircle {
                        id: lastProgressCircle
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Rectangle{
                        color: "#6d3a3a"
                        gradient: Gradient {
                            GradientStop {
                                position: 0.00;
                                color: "#00ffffff";
                            }
                            GradientStop {
                                position: 0.10;
                                color: "#66000000";
                            }
                            GradientStop {
                                position: 0.13;
                                color: "#99000000";
                            }
                            GradientStop {
                                position: 0.88;
                                color: "#99000000";
                            }
                            GradientStop {
                                position: 0.9;
                                color: "#66000000";
                            }
                            GradientStop {
                                position: 1;
                                color: "#00ffffff";
                            }
                        }
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.topMargin: (parent.height - historyLastLbl.height) / 2 - Theme.paddingMedium
                        height: historyLastLbl.height + 2 * Theme.paddingMedium
                        width: parent.width
                    }

                    Label {
                        id: historyLastLbl
                        text: "Last\nviewed"
                        font.pixelSize: parent.width / 7
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.paddingSmall
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    IconButton{
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        icon.source: "image://theme/icon-s-time"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: pageStack.push("HistoryPage.qml")
                    }
                }
                Image{
                    id: lastFavoriteImage
                    width: parent.width / 2
                    height: parent.height
                    anchors.left: lastImage.right
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    fillMode: Image.Tile
                    onProgressChanged: lastFavoriteProgressCircle.value = progress
                    onStatusChanged: {
                        if(status == Image.Ready){
                            lastFavoriteProgressCircle.visible = false
                        }
                    }
                    ProgressCircle {
                        id: lastFavoriteProgressCircle
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Rectangle{
                        color: "#6d3a3a"
                        gradient: Gradient {
                            GradientStop {
                                position: 0.00;
                                color: "#00ffffff";
                            }
                            GradientStop {
                                position: 0.10;
                                color: "#66000000";
                            }
                            GradientStop {
                                position: 0.13;
                                color: "#99000000";
                            }
                            GradientStop {
                                position: 0.88;
                                color: "#99000000";
                            }
                            GradientStop {
                                position: 0.9;
                                color: "#66000000";
                            }
                            GradientStop {
                                position: 1;
                                color: "#00ffffff";
                            }
                        }
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.topMargin: (parent.height - favoriteLastLbl.height) / 2 - Theme.paddingMedium
                        height: favoriteLastLbl.height + 2 * Theme.paddingMedium
                        width: parent.width
                    }

                    Label {
                        id: favoriteLastLbl
                        text: "Last\nfavorite"
                        font.pixelSize: parent.width / 7
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.paddingSmall
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    IconButton{
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        icon.source: "image://theme/icon-m-favorite"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: pageStack.push("FavoritesPage.qml")
                    }
                }
            }

            // STATS -----------------------------------------------

            SectionHeader{
                text: qsTr("Stats")
            }

            Label{
                id: totalColorsLbl
                text: "Total colors: "
                color: Theme.secondaryColor
                x: Theme.horizontalPageMargin
            }

            Label{
                id: totalPalettesLbl
                text: "Total palettes: "
                color: Theme.secondaryColor
                x: Theme.horizontalPageMargin
            }

            Label{
                id: totalPatternsLbl
                text: "Total patterns: "
                color: Theme.secondaryColor
                x: Theme.horizontalPageMargin
            }

            Label{
                id: totalLoversLbl
                text: "Total lovers: "
                color: Theme.secondaryColor
                x: Theme.horizontalPageMargin
            }

        }
    }
}

