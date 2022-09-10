import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.StringUtil;
using CoordinateUtils;

class MemoryProfileApp extends Application.AppBase {
    //! if set to true, the app will create references to views that prevent the "garbage collector" from freeing memory of the view objects
    const CREATE_BAD_REFERENCES = false;
    
    // helper objects
    var coordinator = CoordinateUtils.Coordinator.fromDeviceSettings();

    //! current number of views
    var viewCount = 1;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        System.println("output");

        var s = System.getDeviceSettings();
        System.println(s.inputButtons);
        if (s.inputButtons & System.BUTTON_INPUT_UP) {
            System.println("HAS UP BUTTON");
        }
        if (s.inputButtons & System.BUTTON_INPUT_DOWN) {
            System.println("HAS DOWN BUTTON");
        }
    }

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
