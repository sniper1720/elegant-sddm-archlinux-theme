import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

import "Components"

Rectangle {
    id: root
    width: 640
    height: 480

    property color primaryColor: "#1793d1"
    property color panelColor: "#800C0C0C"
    property color textColor: "white"
    property color errorColor: "red"
    property color successColor: "steelblue"

    property real baseFontSize: loginPanel.height / 22.5

    Repeater {
        model: screenModel
        Item {
            property variant geometry: screenModel.geometry(index)
            x: geometry.x; y: geometry.y; width: geometry.width; height:geometry.height
            
            Image {
                id: bg
                anchors.fill: parent
                source: Qt.resolvedUrl(config.background)
                fillMode: Image.PreserveAspectCrop
                onStatusChanged: {
                    if (status == Image.Error && source != Qt.resolvedUrl(config.defaultBackground)) {
                        source = Qt.resolvedUrl(config.defaultBackground)
                    }
                }
            }
            
            MultiEffect {
                anchors.fill: bg
                source: bg
                blurEnabled: true
                blurMax: 64
                blur: 1.0
            }
        }
    }

    Item {
        id: mainContainer
        property variant geometry: screenModel.geometry(screenModel.primary)
        x: geometry.x; y: geometry.y; width: geometry.width; height: geometry.height
        
        Image {
            id: archlogo
            width: height * 3
            height: parent.height / 6
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -4 * height / 2
            anchors.horizontalCenterOffset: +4.5 * height / 2
            fillMode: Image.PreserveAspectFit
            source: "Assets/archlinux.svg"
        }

        LoginPanel {
            id: loginPanel
            anchors.centerIn: parent
            height: parent.height / 10 * 3
            width: height * 1.8
            anchors.verticalCenterOffset: height * 0/ 3
            anchors.horizontalCenterOffset: +2.5 * height / 2
            
            primaryColor: root.primaryColor
            textColor: root.textColor
            errorColor: root.errorColor
            successColor: root.successColor
        }
    }
}
