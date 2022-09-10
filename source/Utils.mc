using Toybox.System;
using Toybox.Math;
using Toybox.Lang;
using Toybox.Timer;

module CoordinateUtils {
    const GARBAGE_TIMER_INTEVAL = 100;

    class Position {
        var x = 0;
        var y = 0;
        function toString() {
            return x + "," + y;
        }

        function initialize(x as Number, y as Number) {
            self.x = x;
            self.y = y;
        }
    }

    class Coordinator {
        // SCREEN_SHAPE_ROUND, SCREEN_SHAPE_SEMI_ROUND, SCREEN_SHAPE_RECTANGLE, SCREEN_SHAPE_SEMI_OCTAGON
        var screenShape as System.ScreenShape;
        var screenWidth as Lang.Number;
        var screenHeight as Lang.Number;
        //! screen center x, y
        var cx as Number, cy as Number;
        //! radius, only for round watches
        /*private */ var radius as Lang.Number;

        function initialize(screenShape, screenWidth as Number, screenHeight as Number) {
            self.screenShape = screenShape;
            self.screenWidth = screenWidth;
            self.screenHeight = screenHeight;

            switch (screenShape) {
                case System.SCREEN_SHAPE_ROUND:
                    System.println("round!");
                    self.radius = screenHeight / 2;
                    self.cx = screenWidth / 2;
                    self.cy = screenHeight / 2;
                    break;

                    System.println("rect!");
                    self.cx = screenWidth / 2;
                case System.SCREEN_SHAPE_RECTANGLE:
                    self.cy = screenHeight / 2;
                    break;
                default:
                    break;
            }
        }

        static function fromDeviceSettings() {
            var s = System.getDeviceSettings();
            return new Coordinator(s.screenShape, s.screenWidth, s.screenHeight);
        }

        function toString() {
            switch (screenShape) {
                case System.SCREEN_SHAPE_ROUND:
                    return "Round c=(" + cx + ", " + cy + ") r=" + radius;
                case System.SCREEN_SHAPE_RECTANGLE:
                    return "Rect c=(" + cx + ", " + cy + ")";
                default:
                    return "";
                    break;
            }
        }

        function projectPosition(angle as Number, r as Number) as Position {
            return new Position(cx + r * Math.cos(Math.toRadians(angle)), cy + r * Math.sin(Math.toRadians(angle)));
        }

        function test_project(dc) {
            var angles = [30, 150, 180, 330];
            var c = CoordinateUtils.Coordinator.fromDeviceSettings();
            System.println(c);

            for (var i = 0; i < angles.size(); i++) {
                var p = c.projectPosition(angles[i], c.radius);
                System.println(p);
                dc.drawCircle(p.x, p.y, 4);
            }
        }
    }

    class ButtonsLocator {
        function initialize() {}
    }

    class GarbageMaker {
        private static var noOfChunks as Number = 0;
        private var currentChunk as Number = 0;
        private var timer = new Timer.Timer();

        private var view;

        function initialize(viewObject) {
            self.view = viewObject;

            // estimate number of chanks for each view (so we don't take all the free memory at once and the user will be able to create a few views)
            if (GarbageMaker.noOfChunks == 0) {
                var maxChunks = getFreeMemory() / 5; // 5kB is a size of chunk ceated by createPortionOfTrash()
                GarbageMaker.noOfChunks = maxChunks / 5 + 1; // we'd like to have something like 5 views
                System.println("maxChunks = " + maxChunks + "; noOfChunks = " + noOfChunks);
            }
        }

        //! creates ~5kB worth of data
        function createPortionOfTrash(cnt as Lang.Number) {
            if (cnt <= 0) {
                cnt = 1000;
            }
            var tmp = new [cnt];
            for (var i = 0; i < cnt; i++) {
                tmp[i] = Math.rand();
            }
            return tmp;
        }

        function timerCallback() {
            if (self.currentChunk < GarbageMaker.noOfChunks) {
                System.println("tick: " + currentChunk);
                self.currentChunk += 1;
                self.view.addTrash(createPortionOfTrash(1000));
            } else {
                System.println("timer stopped");
                self.timer.stop();
                self.view = null;
            }
        }
        function startProducingTrash() {
            self.timer.start(method(:timerCallback), GARBAGE_TIMER_INTEVAL, true);
        }

        static function getFreeMemory() as Lang.Number {
            return System.getSystemStats().freeMemory / 1000;
        }

        static function getUsedMemory() as Lang.Number {
            return System.getSystemStats().usedMemory / 1000;
        }
    }
}
