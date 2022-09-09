using Toybox.System;
using Toybox.Math;

module CoordinateUtils {
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
        var screenHeight as Lang.Number;
        /*
        SCREEN_SHAPE_ROUND	1
        SCREEN_SHAPE_SEMI_ROUND	2	
        SCREEN_SHAPE_RECTANGLE	3	
        SCREEN_SHAPE_SEMI_OCTAGON	4	
        */
        var screenShape as System.ScreenShape;
        var screenWidth as Lang.Number;

        //! screen center x, y
        var cx as Number, cy as Number;
        //! radius, only for round watches
        /*private */ var radius as Lang.Number;

        function initialize(screenShape, screenWidth as Numeric, screenHeight as Numeric) {
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

                case System.SCREEN_SHAPE_RECTANGLE:
                    System.println("rect!");
                    self.cx = screenWidth / 2;
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
                    break;
            }
        }

        function projectPosition(angle as Number, r as Number) as Position {
            return new Position(cx + r * Math.cos(Math.toRadians(angle)), cy + r * Math.sin(Math.toRadians(angle)));
        }

        function test_project() {
            var angles = [30, 150, 180, 330];
            var c = CoordinateUtils.Coordinator.fromDeviceSettings();
            System.println(c);

            for (var i = 0; i < angles.size(); i++) {
                var p = c.projectPosition(angles[i], c.radius);
                System.println(p);

                color = self.colors[i % angles.size()];
                dc.setColor(color, Graphics.COLOR_BLACK);
                dc.drawCircle(p.x, p.y, 4);
            }
        }
    }
}
