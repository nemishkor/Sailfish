/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0


Page {
    id: page

    property int id;
    property string tittle;
    property string userName;
    property int numViews;
    property int numVotes;
    property int numComments;
    property int numHearts;
    property string dateCreated;
    property string hex;
    property string red;
    property string blue;
    property string green;
    property string hue;
    property string saturation;
    property string value;
    property string description;
    property string url;
    property string imageUrl;
    property string badgeUrl;
    property string apiUrl;

    property string type;
    property string category;
    property string path;
    property string dataURI;

    property var randomHistory: new Array();
    property int randomAction;
    property int currentRandomHistoryIndex: -1;

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
            // update page on load new xml
            if(status == XmlListModel.Ready){
                if(count == 1){

                    // UI
                    id = listModel.get(0).id
                    category = category
                    tittle = listModel.get(0).title
                    userName = listModel.get(0).userName
                    numViews = listModel.get(0).numViews
                    numVotes = listModel.get(0).numVotes
                    numComments = listModel.get(0).numComments
                    numHearts = listModel.get(0).numHearts
                    dateCreated = listModel.get(0).dateCreated
                    hex = listModel.get(0).hex
                    red = listModel.get(0).red
                    blue = listModel.get(0).blue
                    green = listModel.get(0).green
                    hue = listModel.get(0).hue
                    saturation = listModel.get(0).saturation
                    value = listModel.get(0).value
                    description = listModel.get(0).description
                    url = listModel.get(0).url
                    imageUrl = listModel.get(0).imageUrl
                    badgeUrl = listModel.get(0).badgeUrl
                    apiUrl = listModel.get(0).apiUrl

                    // UX
                    loadingModel.visible = false
                    column.visible = true

                    // history
                    if(randomAction == -1){ // if open prev color in history
                        if(randomHistory[currentRandomHistoryIndex - 1])
                            currentRandomHistoryIndex--
                    }
                    if(randomAction == 0){ // if search random color when you open not latest color from history
                        currentRandomHistoryIndex = randomHistory.length
                        var tmp = randomHistory;
                        tmp.push(hex)
                        randomHistory = tmp
                    }
                    if(randomAction == 1){ // if open next color in history or search random
                        currentRandomHistoryIndex++
                    }
                }
            }
        }
    }

    function loadXml(){
        var id;
        if(randomAction == 1){ // if open next color in history
            dataURI = "http://www.colourlovers.com/api/color/" + randomHistory[currentRandomHistoryIndex + 1]
        } else {
            if(randomAction == -1){ // if open prev color in history
                dataURI = "http://www.colourlovers.com/api/color/" + randomHistory[currentRandomHistoryIndex - 1]
            } else
                dataURI = "http://www.colourlovers.com/api/" + type + "/random"
        }
        var req = new XMLHttpRequest();
        req.open("get", dataURI);
        req.send();
        req.onreadystatechange = function () {
            if (req.readyState === XMLHttpRequest.DONE) {
                if (req.status === 200) {
                    listModel.xml = req.responseText;
                    listModel.reload();
                } else {
                    console.log("HTTP request failed", req.status)
                    loadLbl.text = "HTTP request failed\nRequest status " + req.status + "\nCheck your Internet connection"
                }
            }
        }
    }

    function debug(){
        console.log("---");
        console.log("randomAction=" + randomAction);
        console.log("currentRandomHistoryIndex=" + currentRandomHistoryIndex);
        console.log("randomHistory.length=" + randomHistory.length);
        for(var i = 0; i < randomHistory.length; i++)
            console.log("randomHistory[" + i + "]=" + randomHistory[i]);
    }

    Component.onCompleted: {
        if(category == "Random"){
            randomAction = 0;
            loadXml();
        }
    }

    ProgressBar {
        id: loadingModel
        visible: (category == "Random") ? true : false
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

    SilicaFlickable {
        id: listView
        anchors.fill: parent
        contentHeight: column.height

        Column{
            id: column
            width: parent.width
            visible: (category == "Random") ? false : true
            spacing: Theme.paddingMedium
            anchors.bottomMargin: Theme.paddingLarge
            PageHeader {
                id: columnTitle
                title: tittle
            }
            Item{
                visible: (category == "Random") ? true : false
                width: page.width / 9 * 7
                height: 80
                anchors.leftMargin: page.width / 9
                anchors.left: parent.left
                Button{
                    id: btnPrev
                    text: "<-"
                    enabled: (randomHistory[currentRandomHistoryIndex - 1]) ? true : false
                    onClicked: {
                        loadingModel.visible = true
                        randomAction = -1
                        loadXml()
                        column.visible = false
                    }
                    width: page.width / 9
                    anchors.right: btnReload.left
                    anchors.rightMargin: page.width / 9
                }

                Button{
                    id: btnReload
                    text: "Next random"
                    onClicked: {
                        loadingModel.visible = true
                        randomAction = 0
                        loadXml()
                        column.visible = false
                    }
                    width: page.width / 9 * 3
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button{
                    id: btnNext
                    text: "->"
                    enabled: (randomHistory[currentRandomHistoryIndex + 1] && currentRandomHistoryIndex != -1) ? true : false
                    onClicked: {
                        loadingModel.visible = true
                        randomAction = 1
                        loadXml()
                        column.visible = false
                    }
                    width: page.width / 9
                    anchors.left: btnReload.right
                    anchors.leftMargin: page.width / 9
                }
            }
            Image{
                id: mainImage
                source: imageUrl
                width: parent.width
                height: parent.width / sourceSize.width * sourceSize.height
                fillMode: Image.Tile
            }

            ComboBox {
                Image{
                    id: imageFillMode
                    width: sourceSize.width; height: parent.height - 2 * Theme.paddingSmall
                    fillMode: Image.PreserveAspectFit
                    horizontalAlignment: Image.AlignRight
                    source: "qrc:/iconPrefix/tile.png"
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    anchors.topMargin: Theme.paddingSmall
                }
                visible: (type == "colors") ? false : true
                label: qsTr("Image size: ")
                currentIndex: 0
                width: parent.width
                menu: ContextMenu {
                    MenuItem {
                        text: "tile"
                        onClicked: {
                            mainImage.fillMode = Image.Tile
                            mainImage.width = mainImage.parent.width
                            mainImage.x = 0
                            imageFillMode.source = "qrc:/iconPrefix/tile.png"
                        }
                    }
                    MenuItem {
                        text: "original"
                        onClicked: {
                            mainImage.fillMode = Image.PreserveAspectFit
                            mainImage.width = mainImage.sourceSize.width
                            mainImage.x = (mainImage.parent.width - mainImage.sourceSize.width) / 2
                            imageFillMode.source = "qrc:/iconPrefix/original.png" }
                    }
                    MenuItem {
                        text: "fill"
                        onClicked: {
                            mainImage.fillMode = Image.PreserveAspectFit
                            mainImage.width = mainImage.parent.width
                            mainImage.x = 0
                            imageFillMode.source = "qrc:/iconPrefix/fit.png" }
                    }
                }
            }

            Rectangle{
                color: "transparent"
                width: parent.width
                y: Theme.paddingSmall
                height: 139
                Rectangle{
                    color: "transparent"
                    id: heartsRect
                    width: parent.width / 4
                    anchors.left: parent.left
                    height: parent.height
                    Image{
                        anchors.verticalCenter: parent.verticalCenter
                        id: heartsImage
                        source: "qrc:/iconPrefix/icon-launcher-people.png"
                        width: parent.width
                        height: sourceSize.height
                        fillMode: Image.PreserveAspectFit
                        Rectangle{
                            width: heartsLblCount.width + 10
                            height: heartsLblCount.height
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 4
                            anchors.horizontalCenter: parent.horizontalCenter
                            radius: 8
                            color: "#80ffffff"
                            Label{
                                id: heartsLblCount
                                x: 5
                                color: "#000000"
                                horizontalAlignment: Text.AlignHCenter
                                text: numHearts
                            }
                        }
                    }
                    Label{
                        id: heartsLbl
                        anchors.top: heartsImage.bottom
                        font.pixelSize: 18
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                        text: "Hearts"
                    }
                }
                Rectangle{
                    color: "transparent"
                    id: voteRect
                    width: parent.width / 4
                    anchors.left: heartsRect.right
                    height: parent.height
                    Image{
                        anchors.verticalCenter: parent.verticalCenter
                        id: voteImage
                        source: "qrc:/iconPrefix/icon-vote.png"
                        width: parent.width
                        height: 86
                        fillMode: Image.PreserveAspectFit
                        Rectangle{
                            width: votesLblCount.width + 10
                            height: votesLblCount.height
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 4
                            anchors.horizontalCenter: parent.horizontalCenter
                            radius: 8
                            color: "#80ffffff"
                            Label{
                                id: votesLblCount
                                x: 5
                                color: "#000000"
                                horizontalAlignment: Text.AlignHCenter
                                text: numVotes
                            }
                        }
                    }
                    Label{
                        anchors.top: voteImage.bottom
                        font.pixelSize: 18
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                        text: "Votes"
                    }
                }
                Rectangle{
                    color: "transparent"
                    id: viewsRect
                    width: parent.width / 4
                    anchors.left: voteRect.right
                    height: parent.height
                    Image{
                        anchors.verticalCenter: parent.verticalCenter
                        id: viewsImage
                        source: "qrc:/iconPrefix/icon-view.png"
                        width: parent.width
                        height: 86
                        fillMode: Image.PreserveAspectFit
                        Rectangle{
                            width: viewsLblCount.width + 10
                            height: viewsLblCount.height
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 4
                            anchors.horizontalCenter: parent.horizontalCenter
                            radius: 8
                            color: "#80ffffff"
                            Label{
                                id: viewsLblCount
                                x: 5
                                color: "#000000"
                                horizontalAlignment: Text.AlignHCenter
                                text: numViews
                            }
                        }
                    }
                    Label{
                        anchors.top: viewsImage.bottom
                        font.pixelSize: 18
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        text: "Views"
                    }
                }
                Rectangle{
                    color: "transparent"
                    width: parent.width / 4
                    anchors.left: viewsRect.right
                    height: parent.height
                    Image{
                        anchors.verticalCenter: parent.verticalCenter
                        id: commentImage
                        source: "qrc:/iconPrefix/icon-launcher-messaging.png"
                        width: parent.width
                        height: 86
                        fillMode: Image.PreserveAspectFit
                        Rectangle{
                            width: comLblCount.width + 10
                            height: comLblCount.height
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 4
                            anchors.horizontalCenter: parent.horizontalCenter
                            radius: 8
                            color: "#80ffffff"
                            Label{
                                id: comLblCount
                                x: 5
                                color: "#000000"
                                horizontalAlignment: Text.AlignHCenter
                                text: numComments
                            }
                        }
                    }
                    Label{
                        anchors.top: commentImage.bottom
                        font.pixelSize: 18
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        text: "Comments"
                    }
                }
            }

//            Row{
//                x: Theme.paddingMedium
//                width: parent.width - 2 * Theme.paddingMedium
//                Button{
//                    text: qsTr("Save to gallery")
//                }
//                Button{
//                    text: qsTr("Send")
//                }
//            }

            SectionHeader {
                text: qsTr("Details")
            }
            Label{ width: parent.width - 2 * Theme.paddingMedium; x: Theme.paddingMedium; text: "User name: " + userName }
            Label{
                width: parent.width - 2 * Theme.paddingMedium
                x: Theme.paddingMedium
                text: "Description: " + description
                horizontalAlignment: Text.AlignLeft
                //truncationMode: TruncationMode.Fade
                color: Theme.secondaryHighlightColor
                wrapMode: Text.WordWrap
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        parent.wrapMode = Text.Wrap
                    }
                }
            }
            Label{
                id: hexLbl
                visible: (type == "colors") ? true : false
                width: parent.width - 2 * Theme.paddingMedium
                x: Theme.paddingMedium
                text: "hex: #" + hex
            }
            Label{
                width: parent.width - 2 * Theme.paddingMedium;
                x: Theme.paddingMedium;
                text: "Created: " + dateCreated
            }
            Label{
                width: parent.width - 2 * Theme.paddingMedium;
                x: Theme.paddingMedium;
                text: "id: " + id
            }
            Rectangle{
                visible: (type == "colors") ? true : false
                width: parent.width
                height: 380
                color: "transparent"
                SectionHeader {
                    id: rgbHeader
                    text: qsTr("RGB")
                }
                // RED INDICATOR
                Rectangle{
                    id: redInd
                    color: "transparent"
                    border.color: "#8ec4de"
                    border.width: 1
                    height: 25
                    radius: 8
                    anchors.top: rgbHeader.bottom
                    anchors.topMargin: Theme.paddingSmall
                    x: Theme.paddingLarge
                    width: parent.width - 2 * Theme.paddingLarge
                    Rectangle{
                        radius: 8
                        color: "#f44336"
                        width: parent.width * red / 255
                        anchors.left: parent.left
                        height: parent.height
                        Label{
                            font.pixelSize: 24
                            anchors.fill: parent
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: red
                            anchors.leftMargin: (red < 10) ? (red + 20) : 0
                        }
                    }
                }
                // GREEN INDICATOR
                Rectangle{
                    id: greenInd
                    color: "transparent"
                    border.color: "#8ec4de"
                    border.width: 1
                    height: 25
                    anchors.topMargin: Theme.paddingSmall
                    anchors.top: redInd.bottom
                    radius: 8
                    y: 15
                    x: Theme.paddingLarge
                    width: parent.width - 2 * Theme.paddingLarge
                    Rectangle{
                        radius: 8
                        color: "#4caf50"
                        width: parent.width * green / 255
                        anchors.left: parent.left
                        height: parent.height
                        Label{
                            font.pixelSize: 24
                            anchors.fill: parent
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: green
                            anchors.leftMargin: (green < 10) ? (green + 20) : 0
                        }
                    }
                }
                // BLUE INDICATOR
                Rectangle{
                    id: blueInd
                    color: "transparent"
                    border.color: "#8ec4de"
                    border.width: 1
                    radius: 8
                    height: 25
                    anchors.topMargin: Theme.paddingSmall
                    anchors.bottomMargin: Theme.paddingSmall
                    anchors.top: greenInd.bottom
                    x: Theme.paddingLarge
                    width: parent.width - 2 * Theme.paddingLarge
                    Rectangle{
                        radius: 8
                        color: "#2196f3"
                        width: parent.width * blue / 255
                        anchors.left: parent.left
                        height: parent.height
                        Label{
                            font.pixelSize: 24
                            anchors.fill: parent
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: blue
                            anchors.leftMargin: (blue < 10) ? (blue + 20) : 0
                        }
                    }
                }
                SectionHeader {
                    id: hsvHeader
                    text: qsTr("HSV")
                    anchors.topMargin: Theme.paddingSmall
                    anchors.bottomMargin: Theme.paddingSmall
                    anchors.top: blueInd.bottom
                }
                // HUE INDICATOR
                Rectangle{
                    id: hueInd
                    color: "transparent"
                    border.color: "#8ec4de"
                    border.width: 1
                    radius: 8
                    x: Theme.paddingLarge
                    width: parent.width - 2 * Theme.paddingLarge
                    height: 32
                    anchors.topMargin: Theme.paddingSmall
                    anchors.bottomMargin: Theme.paddingSmall
                    anchors.top: hsvHeader.bottom
                    Rectangle{
                        radius: 8
                        rotation: 90
                        gradient: Gradient{
                            GradientStop{ position: 0.0; color: "red" }
                            GradientStop{ position: 0.15; color: "magenta" }
                            GradientStop{ position: 0.30; color: "blue" }
                            GradientStop{ position: 0.45; color: "cyan" }
                            GradientStop{ position: 0.70; color: "green" }
                            GradientStop{ position: 0.85; color: "yellow" }
                            GradientStop{ position: 1.0; color: "red" }
                        }
                        height: parent.width * hue / 360
                        width: 32
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.leftMargin: parent.width * hue / 360 / 2 - 16
                        anchors.topMargin: -1 * parent.width * hue / 360 / 2 + 16
                        Label{
                            id: hueIndLbl
                            font.pixelSize: 22
                            anchors.fill: parent
                            rotation: 270
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: "hue " + hue
                            anchors.leftMargin: (hue < 50) ? (hue + 50) : 0
                            color: (hue < 50) ? "white" : "black"
                        }
                    }
                }
                // SATURATION INDICATOR
                Rectangle{
                    id: satInd
                    color: "transparent"
                    border.color: "#8ec4de"
                    border.width: 1
                    radius: 8
                    x: Theme.paddingLarge
                    width: parent.width - 2 * Theme.paddingLarge
                    height: 32
                    anchors.topMargin: Theme.paddingSmall
                    anchors.bottomMargin: Theme.paddingSmall
                    anchors.top: hueInd.bottom
                    Rectangle{
                        radius: 8
                        rotation: 270
                        gradient: Gradient{
                            GradientStop{ position: 0.0; color: "#808080" }
                            GradientStop{ position: 1.0; color: "#" + hex }
                        }
                        height: parent.width * saturation / 100
                        width: 32
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.leftMargin: parent.width * saturation / 100 / 2 - 16
                        anchors.topMargin: -1 * parent.width * saturation / 100 / 2 + 16
                        Label{
                            id: satIndLbl
                            font.pixelSize: 22
                            anchors.fill: parent
                            rotation: 90
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            anchors.leftMargin: (saturation < 25) ? (saturation + 25) : 0
                            color: (saturation < 25) ? "white" : "black"
                            text: "saturation " + saturation
                        }
                    }
                }
                // VALUE INDICATOR
                Rectangle{
                    id: valInd
                    color: "transparent"
                    border.color: "#8ec4de"
                    border.width: 1
                    radius: 8
                    x: Theme.paddingLarge
                    width: parent.width - 2 * Theme.paddingLarge
                    height: 32
                    anchors.topMargin: Theme.paddingSmall
                    anchors.bottomMargin: Theme.paddingSmall
                    anchors.top: satInd.bottom
                    Rectangle{
                        radius: 8
                        rotation: 270
                        gradient: Gradient{
                            GradientStop{ position: 0.0; color: "#000000" }
                            GradientStop{ position: 0.5; color: "#" + hex }
                            GradientStop{ position: 1.0; color: "#fff" }
                        }
                        height: parent.width * value / 255
                        width: 32
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.leftMargin: parent.width * value / 255 / 2 - 16
                        anchors.topMargin: -1 * parent.width * value / 255 / 2 + 16
                        Label{
                            id: valIndLbl
                            font.pixelSize: 22
                            anchors.fill: parent
                            rotation: 90
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            //anchors.leftMargin: (value < 50) ? (value + 50) : 0
                            color: (value < 50) ? "white" : "black"
                            text: "value " + value
                        }
                    }
                }
            }

            Button {
                text: "Open this element in browser"
                anchors.horizontalCenter: parent.horizontalCenter
                preferredWidth: Theme.buttonWidthMedium
            }


            Button {
                text: "Open image in browser"
                anchors.horizontalCenter: parent.horizontalCenter
                preferredWidth: Theme.buttonWidthMedium
            }


            Button {
                text: "Open badge in browser"
                anchors.horizontalCenter: parent.horizontalCenter
                preferredWidth: Theme.buttonWidthMedium
            }


            Button {
                text: "Open api url in browser"
                anchors.horizontalCenter: parent.horizontalCenter
                preferredWidth: Theme.buttonWidthMedium
            }
        }
        VerticalScrollDecorator {}
    }
}





