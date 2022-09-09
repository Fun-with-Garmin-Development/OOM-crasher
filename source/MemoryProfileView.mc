import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.System;

class MemoryProfileView extends WatchUi.View {
    private static var colors = /*[0x000000,*/ [0x0000ff, 0x00ff00, 0x00ffff, 0xff0000, 0xff00ff, 0xffff00, 0xffffff];
    private var viewNo as Numeric;
    private var chunk;
    private var trash;

    function initialize(n as Numeric) {
        self.viewNo = n;
        self.chunk = createPieceOfTrash2();
        View.initialize();
    }

    function getFreeMemory() as Numeric {
        var myStats = System.getSystemStats();
        return myStats.freeMemory;
    }

    function getUsedMemory() as Numeric {
        var myStats = System.getSystemStats();
        return myStats.usedMemory;
    }

    function createPieceOfTrash() {
        return WatchUi.loadResource($.Rez.Drawables.MonkeyPic);
    }

    function createPieceOfTrash2() {
        var tmp = [];
        var cnt = 1000;
        for (var i = 0; i < cnt; i++) {
            tmp.add(Math.rand());
        }
        return tmp;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        // fenix 7 - 786432B memory limit for an app
        // fenix 5 - 131072B
        // forerunner 230 - 65536B

        var cnt = 10;
        // var cnt = Math.rand() % 20 + 10;
        System.println(cnt);
        var freeBefore = self.getFreeMemory();
        var usedBefore = self.getUsedMemory();

        self.trash = [];
        for (var i = 0; i < cnt; i++) {
            var before = self.getFreeMemory();
            self.trash.add(self.chunk);
            var after = self.getFreeMemory();
            // System.println(i + ". " + before + " -> " + after + " (" + (before - after) + ")");
        }
        var freeAfter = self.getFreeMemory();
        var usedAfter = self.getUsedMemory();
        var used = usedBefore - usedAfter;

        System.println("free lost: " + (freeBefore - freeAfter) + "  used gained = " + used);
    }

    function onShow() as Void {}

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var free = getFreeMemory() / 1000;
        var used = getUsedMemory() / 1000;

        var color = self.colors[(self.viewNo - 1) % self.colors.size()];
        dc.setColor(color, Graphics.COLOR_BLACK);
        dc.clear();

        var dy = dc.getFontHeight(Graphics.FONT_SMALL);
        var x = dc.getWidth() / 2;
        var y = dc.getHeight() / 2;
        y -= (3 * dy) / 2; // <-- the first number if for number of lines

        dc.drawText(x, y, Graphics.FONT_SMALL, "View " + self.viewNo, Graphics.TEXT_JUSTIFY_CENTER);
        y += dy;
        dc.drawText(x, y, Graphics.FONT_SMALL, free + "kB free", Graphics.TEXT_JUSTIFY_CENTER);
        y += dy;
        dc.drawText(x, y, Graphics.FONT_SMALL, used, Graphics.TEXT_JUSTIFY_CENTER);

        // TODO: draw button hints
    }

    function onHide() as Void {}
}
