import Toybox.Lang;
import Toybox.WatchUi;

class MemoryProfileDelegate extends WatchUi.BehaviorDelegate {
  private var viewNo as Numeric;

  function initialize(n as Numeric) {
    self.viewNo = n;
    BehaviorDelegate.initialize();
  }

  //   function onKey(keyEvent) {
  //     System.println(keyEvent.getKey()); // e.g. KEY_MENU = 7
  //     WatchUi.requestUpdate();
  //     return false;
  //   }

  //   function onDrag(e) {
  //     System.println("onCoś: " + e);
  //     return false;
  //   }
  //   function onFlick(e) {
  //     System.println("onCoś: " + e);
  //     return false;
  //   }
  // //   function onKey(e) {
  // //     System.println("onCoś: " + e);
  // //     return false;
  // //   }
  //   function onKeyPressed(e) {
  //     System.println("onCoś: " + e);
  //     return false;
  //   }
  //   function onKeyReleased(e) {
  //     System.println("onCoś: " + e);
  //     return false;
  //   }
  //   function onTap(e) {
  //     System.println("onCoś: " + e);
  //     return false;
  //   }
  //   function onHold(e) {
  //     System.println("onCoś: " + e);
  //     return false;
  //   }
  //   function onRelease(e) {
  //     System.println("onCoś: " + e);
  //     return false;
  //   }
  //   function onSwipe(e) {
  //     System.println("onCoś: " + e);
  //     return false;
  //   }

  function onSelect() as Boolean {
    System.println("on select");
    var nextNo = self.viewNo + 1;
    WatchUi.pushView(
      new MemoryProfileView(nextNo),
      new MemoryProfileDelegate(nextNo),
      WatchUi.SLIDE_IMMEDIATE
    );
    return true;
  }
}
