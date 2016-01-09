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


Page {
    id: page

    property string type;

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

    SilicaFlickable {
        id: listView
        anchors.fill: parent
        contentHeight: column.height

        Column{
            id: column
            width: parent.width
            PageHeader {
                title: tittle
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
                            x: 0
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
                wrapMode: Text.NoWrap
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
                text: "hex: " + hex
            }


            Rectangle{
                visible: (type == "colors") ? true : false
                width: parent.width
                height: 91
                color: "transparent"
                // RED INDICATOR
                Rectangle{
                    id: redInd
                    color: "transparent"
                    border.color: "#8ec4de"
                    border.width: 1
                    height: 25
                    radius: 8
                    anchors.top: parent.top
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
                            font.pixelSize: 22
                            anchors.fill: parent
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: red
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
                            font.pixelSize: 22
                            anchors.fill: parent
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: green
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
                            font.pixelSize: 22
                            anchors.fill: parent
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: blue
                        }
                    }
                }
            }
//            // HUE INDICATOR
//            Rectangle{
//                color: "transparent"
//                border.color: "#8ec4de"
//                border.width: 1
//                radius: 8
//                anchors.topMargin: Theme.paddingMedium
//                anchors.bottomMargin: Theme.paddingMedium
//                height: parent.width - 2 * Theme.paddingMedium
//                x: Theme.paddingMedium
//                rotation: 90
//                width: 25
//                Rectangle{
//                    radius: 8
//                    gradient: Gradient{
//                        GradientStop{ position: 0.0; color: "red" }
//                        GradientStop{ position: 0.15; color: "magenta" }
//                        GradientStop{ position: 0.30; color: "blue" }
//                        GradientStop{ position: 0.45; color: "cyan" }
//                        GradientStop{ position: 0.70; color: "green" }
//                        GradientStop{ position: 0.85; color: "yellow" }
//                        GradientStop{ position: 1.0; color: "red" }
//                    }
//                    width: parent.width * hue / 360
//                    anchors.left: parent.left
//                    height: parent.height
//                    Label{
//                        font.pixelSize: 22
//                        anchors.fill: parent
//                        anchors.verticalCenter: parent.verticalCenter
//                        anchors.horizontalCenter: parent.horizontalCenter
//                        verticalAlignment: Text.AlignVCenter
//                        horizontalAlignment: Text.AlignHCenter
//                        text: "hue " + hue
//                    }
//                }
//            }
//            // SATURATION INDICATOR
//            Rectangle{
//                color: "transparent"
//                border.color: "#8ec4de"
//                border.width: 1
//                height: 25
//                radius: 8
//                anchors.topMargin: Theme.paddingMedium
//                anchors.bottomMargin: Theme.paddingMedium
//                x: Theme.paddingMedium
//                width: parent.width - 2 * Theme.paddingMedium
//                Rectangle{
//                    radius: 8
//                    gradient: Gradient{
//                        GradientStop{ position: 0.0; color: "#808080" }
//                        GradientStop{ position: 1.0; color: "#" + hex }
//                    }
//                    width: parent.width * saturation / 255
//                    anchors.left: parent.left
//                    height: parent.height
//                    Label{
//                        font.pixelSize: 22
//                        anchors.fill: parent
//                        anchors.verticalCenter: parent.verticalCenter
//                        anchors.horizontalCenter: parent.horizontalCenter
//                        verticalAlignment: Text.AlignVCenter
//                        horizontalAlignment: Text.AlignHCenter
//                        text: "saturation" + saturation
//                    }
//                }
//            }
//            // VALUE INDICATOR
//            Rectangle{
//                color: "transparent"
//                border.color: "#8ec4de"
//                border.width: 1
//                height: 25
//                radius: 8
//                anchors.topMargin: Theme.paddingMedium
//                anchors.bottomMargin: Theme.paddingMedium
//                x: Theme.paddingMedium
//                width: parent.width - 2 * Theme.paddingMedium
//                Rectangle{
//                    radius: 8
//                    gradient: Gradient{
//                        GradientStop{ position: 0.0; color: "#000000" }
//                        GradientStop{ position: 0.5; color: "#" + hex }
//                        GradientStop{ position: 1.0; color: "#fff" }
//                    }
//                    width: parent.width * value / 255
//                    anchors.left: parent.left
//                    height: parent.height
//                    Label{
//                        font.pixelSize: 22
//                        anchors.fill: parent
//                        anchors.verticalCenter: parent.verticalCenter
//                        anchors.horizontalCenter: parent.horizontalCenter
//                        verticalAlignment: Text.AlignVCenter
//                        horizontalAlignment: Text.AlignHCenter
//                        text: "value " + value
//                    }
//                }
//            }


            Label{ visible: (type == "colors") ? true : false; width: parent.width - 2 * Theme.paddingMedium; x: Theme.paddingMedium; text: "Hue: " + hue }
            Label{ visible: (type == "colors") ? true : false; width: parent.width - 2 * Theme.paddingMedium; x: Theme.paddingMedium; text: "Saturation: " + saturation }
            Label{ visible: (type == "colors") ? true : false; width: parent.width - 2 * Theme.paddingMedium; x: Theme.paddingMedium; text: "Value: " + value }
            Label{ width: parent.width - 2 * Theme.paddingMedium; x: Theme.paddingMedium; text: "Created: " + dateCreated }
            Label{ width: parent.width - 2 * Theme.paddingMedium; x: Theme.paddingMedium; text: "id: " + id }
//            Text{ width: parent.width - 2 * Theme.paddingMedium; x: Theme.paddingMedium; text: "url " + url }
//            Text{ width: parent.width - 2 * Theme.paddingMedium; x: Theme.paddingMedium; text: "imageUrl " + imageUrl }
//            Text{ width: parent.width - 2 * Theme.paddingMedium; x: Theme.paddingMedium; text: "badgeUrl " + badgeUrl }
//            Text{ width: parent.width - 2 * Theme.paddingMedium; x: Theme.paddingMedium; text: "apiUrl " + apiUrl }
        }
        VerticalScrollDecorator {}
    }
}





