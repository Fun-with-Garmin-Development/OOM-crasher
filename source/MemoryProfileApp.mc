import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.StringUtil;
using CoordinateUtils;

class MemoryProfileApp extends Application.AppBase {
    var viewCount = 1;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        System.println("output");
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {}

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return (
            [new MemoryProfileView(viewCount), new MemoryProfileDelegate(viewCount)] as Array<Views or InputDelegates>
        );
    }
}

function getApp() as MemoryProfileApp {
    return Application.getApp() as MemoryProfileApp;
}
