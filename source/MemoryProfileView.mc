import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.Lang;
using Toybox.System;
using GarbageUtils;

class MemoryProfileView extends WatchUi.View {
    static var colors as Lang.Array<Lang.Number> = [
        0x0000ff, 0x00ff00, 0x00ffff, 0xff0000, 0xff00ff, 0xffff00, 0xffffff
    ];
    //! consecutive number of the view
    private var viewNo as Lang.Number;
    //! a variabele that stores some data to stress the free memory
    private var trash = [];

    //! initialize with a view number
    function initialize(n as Lang.Number) {
        self.viewNo = n;
        View.initialize();
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var free = GarbageUtils.GarbageMaker.getFreeMemory();
        var used = GarbageUtils.GarbageMaker.getUsedMemory();

        var color = MemoryProfileView.colors[(self.viewNo - 1) % MemoryProfileView.colors.size()];
        dc.setColor(color, Graphics.COLOR_BLACK);
        dc.clear();

        // print some information on the screen
        var dy = dc.getFontHeight(Graphics.FONT_SMALL);
        var x = dc.getWidth() / 2;
        var y = dc.getHeight() / 2;
        y -= (3 * dy) / 2;
        dc.drawText(x, y, Graphics.FONT_SMALL, "View " + self.viewNo, Graphics.TEXT_JUSTIFY_CENTER);
        y += dy;
        dc.drawText(x, y, Graphics.FONT_SMALL, free + "kB free", Graphics.TEXT_JUSTIFY_CENTER);
        y += dy;
        dc.drawText(x, y, Graphics.FONT_SMALL, used + "kB used", Graphics.TEXT_JUSTIFY_CENTER);
    }

    function addTrash(chunk) {
        self.trash.add(chunk);
    }
}
