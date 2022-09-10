import Toybox.Lang;
import Toybox.WatchUi;

class MemoryProfileDelegate extends WatchUi.BehaviorDelegate {
    //! consecutive number of the view that this delegate deals with
    private var viewNo as Lang.Number;

    function initialize(n as Lang.Number) {
        self.viewNo = n;
        BehaviorDelegate.initialize();
    }

    //! Method for creating new view.
    //! Responds to swipe up or button down.
    function onNextPage() as Boolean {
        System.println("onNextPage");
        var nextNo = self.viewNo + 1;
        WatchUi.pushView(new MemoryProfileView(nextNo), new MemoryProfileDelegate(nextNo), WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    //! Method for closing current view.
    //! Responds to swipe down or button up.
    function onPreviousPage() as Lang.Boolean {
        System.println("onPreviousPage");
        if (self.viewNo > 1) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
        return true;
    }
}
