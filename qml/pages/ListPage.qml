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
import QtGraphicalEffects 1.0

Page {
    id: page

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
        XmlRole {name: "green"; query: "rgb/blue/string()"}
        XmlRole {name: "hue"; query: "hsv/hue/string()"}
        XmlRole {name: "saturation"; query: "hsv/saturation/string()"}
        XmlRole {name: "value"; query: "hsv/value/string()"}
        XmlRole {name: "description"; query: "description/string()"}
        XmlRole {name: "url"; query: "url/string()"}
        XmlRole {name: "imageUrl"; query: "imageUrl/string()"}
        XmlRole {name: "badgeUrl"; query: "badgeUrl/string()"}
        XmlRole {name: "apiUrl"; query: "apiUrl/string()"}
    }

    property string type;
    property string category;
    property string path;
    property int heightDelegate: 120;
    property int resultOffset: 0;
    property string dataURI;

    function loadXml(){
        dataURI = "http://www.colourlovers.com/api/" + type + "/" + category + "?numResults=20" + "&resultOffset=" + resultOffset
        console.log(dataURI);
        var req = new XMLHttpRequest();
        req.open("get", dataURI);
        req.send();
        req.onreadystatechange = function () {
            if (req.readyState === XMLHttpRequest.DONE) {
                if (req.status === 200) {
                    listModel.xml = req.responseText;
                    listModel.reload();
                    if(listModel.count == 1){
                        heightDelegate = page.height
                    }
                    list.visible = true;
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



    SilicaListView
    {
        width: parent.width
        height: parent.height
        header: PageHeader {
            id: header
            title: qsTr(category + " " + type)
        }
        id : list
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
                    GradientStop { position: 0.0; color: "#cc000000" }
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
                    console.log(resultOffset)
                    list.scrollToTop()
                    list.visible = false;
                    loadingModel.visible = true;
                    loadXml()
                    listModel.reload()
                    list.visible = true;
                }
            }
            MenuItem{
                text: qsTr("To top")
                onClicked: list.scrollToTop()
            }
        }

    }


}


