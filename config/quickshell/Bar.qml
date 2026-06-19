import QtQuick
import Quickshell

// A single top panel: tags on the left, clock dead-centre, audio + tray on the
// right. exclusionMode Auto reserves the strut so vxwm tiles windows below it
// (requires EXTERNAL_BARS support, which vxwm has).
PanelWindow {
    id: bar

    anchors {
        top: true
        left: true
        right: true
    }
    margins.top: 6

    implicitHeight: Theme.barHeight
    color: "transparent"
    exclusionMode: ExclusionMode.Auto

    // left — workspace tags
    Workspaces {
        anchors {
            left: parent.left
            leftMargin: Theme.padding
            verticalCenter: parent.verticalCenter
        }
    }

    // centre — clock, anchored to the true centre of the bar
    Clock {
        anchors.centerIn: parent
    }

    // right — volume, mic, then the system tray
    Row {
        anchors {
            right: parent.right
            rightMargin: Theme.padding
            verticalCenter: parent.verticalCenter
        }
        spacing: 14

        Tray {
            panel: bar
            anchors.verticalCenter: parent.verticalCenter
        }

        Keyboard {
            anchors.verticalCenter: parent.verticalCenter
        }

        Audio {
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
