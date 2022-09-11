using Toybox.System;
using Toybox.Math;
using Toybox.Lang;
using Toybox.Timer;

module GarbageUtils {

    const GARBAGE_TIMER_INTEVAL = 100;
    
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
                self.stopProducingTrash();
                self.view = null;
            }
            WatchUi.requestUpdate();
        }

        function startProducingTrash() {
            self.timer.start(method(:timerCallback), GARBAGE_TIMER_INTEVAL, true);
        }

        function stopProducingTrash() {
            self.timer.stop();
        }

        static function getFreeMemory() as Lang.Number {
            return System.getSystemStats().freeMemory / 1000;
        }

        static function getUsedMemory() as Lang.Number {
            return System.getSystemStats().usedMemory / 1000;
        }
    }
}
