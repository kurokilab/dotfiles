import QtQuick
import Quickshell

// Minimal centre clock. SystemClock ticks once a minute (Minutes precision) so
// there is no busy 1 Hz timer behind it.
BarText {
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    text: Qt.formatDateTime(clock.date, "HH:mm")
}
