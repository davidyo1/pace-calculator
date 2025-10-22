import Toybox.WatchUi;

class MainDelegate extends WatchUi.BehaviorDelegate {
    private var _view;

    function initialize(view) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onMenu() {
        var menu = new WatchUi.Menu();
        menu.addItem("Set Distance", :distance);    // Changed "distance" to :distance
        menu.addItem("Set Pace", :pace);           // Changed "pace" to :pace
        WatchUi.pushView(menu, new MenuDelegate(_view.getCalculator()), WatchUi.SLIDE_UP);
        return true;
    }
}