import QtQuick
import Quickshell
import Quickshell.Io

// Active keyboard layout (us / ru, toggled with Caps Lock via grp:caps_toggle).
// X11 has no plain CLI to read the current XKB group, so we poll the tiny
// `xkblayout-state` helper. Clicking the indicator sends Caps_Lock, replaying
// the same group-toggle the keyboard uses.
BarText {
    id: root

    property string layout: "us"

    text: layout.toUpperCase()

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(["xdotool", "key", "Caps_Lock"])
    }

    Process {
        id: proc
        command: ["xkblayout-state", "print", "%s"]
        stdout: StdioCollector {
            onStreamFinished: root.layout = text.trim() || root.layout
        }
    }

    Timer {
        interval: 700
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: proc.running = true
    }
}
