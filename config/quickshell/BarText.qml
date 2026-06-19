import QtQuick
import QtQuick.Effects

// Shared text style for every bar widget. The bar background is transparent, so
// readability over light wallpapers comes from a soft shadow. The crucial bit:
// the foreground glyphs are rendered natively (no layer) so they stay razor
// sharp; only a duplicate copy behind them is blurred into a dark halo.
// Set `shadow: false` where the text already has a solid backing (active tag).
Item {
    id: root

    property alias text: fg.text
    property alias color: fg.color
    property bool shadow: true

    implicitWidth: fg.implicitWidth
    implicitHeight: fg.implicitHeight

    // blurred dark copy, drawn first so it sits behind the sharp text
    Text {
        id: sh
        anchors.centerIn: fg
        anchors.verticalCenterOffset: 1
        visible: root.shadow

        text: fg.text
        font: fg.font
        color: Theme.shadow

        layer.enabled: root.shadow
        layer.effect: MultiEffect {
            blurEnabled: true
            blur: 1.0
            blurMax: 8
            autoPaddingEnabled: true
        }
    }

    // crisp foreground glyphs (native rendering, no layer)
    Text {
        id: fg
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        color: Theme.fg
    }
}
