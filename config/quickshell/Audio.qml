import QtQuick
import Quickshell.Services.Pipewire

// Speaker volume and microphone mute state, read straight from PipeWire (no
// polling pactl). PwObjectTracker is required to "bind" the default nodes so
// their .audio.volume / .audio.muted stay live.
Row {
    id: root
    spacing: 14

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }

    // --- speaker: click toggles mute, scroll nudges volume by 5% ----------
    MouseArea {
        id: speaker
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: speakerRow.implicitWidth
        implicitHeight: speakerRow.implicitHeight
        cursorShape: Qt.PointingHandCursor

        readonly property bool muted: root.sink?.audio?.muted ?? false
        readonly property real volume: root.sink?.audio?.volume ?? 0

        onClicked: if (root.sink?.audio)
            root.sink.audio.muted = !root.sink.audio.muted
        onWheel: wheel => {
            const a = root.sink?.audio;
            if (!a)
                return;
            const step = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
            a.volume = Math.max(0, Math.min(1, a.volume + step));
        }

        Row {
            id: speakerRow
            spacing: 5

            BarText {
                anchors.verticalCenter: parent.verticalCenter
                color: speaker.muted ? Theme.red : Theme.fg
                text: {
                    if (speaker.muted)
                        return "󰖁"; // 󰖁 muted
                    if (speaker.volume <= 0.0)
                        return "󰕿"; // 󰕿 low
                    if (speaker.volume < 0.5)
                        return "󰖀"; // 󰖀 medium
                    return "󰕾";     // 󰕾 high
                }
            }

            BarText {
                anchors.verticalCenter: parent.verticalCenter
                color: speaker.muted ? Theme.red : Theme.fg
                text: Math.round(speaker.volume * 100) + "%"
            }
        }
    }

    // --- microphone: click toggles mute -----------------------------------
    MouseArea {
        id: mic
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: micIcon.implicitWidth
        implicitHeight: micIcon.implicitHeight
        cursorShape: Qt.PointingHandCursor

        readonly property bool muted: root.source?.audio?.muted ?? false

        onClicked: if (root.source?.audio)
            root.source.audio.muted = !root.source.audio.muted

        BarText {
            id: micIcon
            text: mic.muted ? "󰍭" : "󰍬" // 󰍭 mic off : 󰍬 mic on
            color: mic.muted ? Theme.red : Theme.fg
        }
    }
}
