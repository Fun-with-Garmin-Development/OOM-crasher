import Toybox.Lang;
import Toybox.WatchUi;

class MemoryProfileDelegate extends WatchUi.BehaviorDelegate {
    //! consecutive number of the view that this delegate deals with
    private var viewNo as Lang.Number;

    //! initialize with a view number
    function initialize(n as Lang.Number) {
        self.viewNo = n;
        BehaviorDelegate.initialize();
    }

    //! Method for creating new view.
    //! Responds to swipe up or button down.
    function onNextPage() as Boolean {
        System.println("onNextPage");
        
        // create and show new view
        var nextNo = self.viewNo + 1;
        var view = new MemoryProfileView(nextNo);
        WatchUi.pushView(view, new MemoryProfileDelegate(nextNo), WatchUi.SLIDE_IMMEDIATE);

        // produce some data to make the view "heavier"
        var trashMaker = new GarbageUtils.GarbageMaker(view);
        trashMaker.startProducingTrash();
        
        // create some "problematic" object references to see how it affects the memory
        var app = getApp();
        if (app.CREATE_BAD_REFERENCES) {
            app.references.add(view);
        }
        
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

    function onSelect() {
        System.println("onSelect");
        WatchUi.requestUpdate();
        return true;
    }
}
