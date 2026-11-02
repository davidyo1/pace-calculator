import Toybox.WatchUi;

class MainDelegate extends WatchUi.BehaviorDelegate {
    private var _view;

    function initialize(view) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onKey(evt) {
        var key = evt.getKey();
        if (key == WatchUi.KEY_ENTER) {
            openMenu();
            return true;
        }
        return false;
    }

    function onTap(evt) {
        openMenu();
        return true;
    }

    private function openMenu() {
        var items = [
            WatchUi.loadResource(Rez.Strings.SetDistance),
            WatchUi.loadResource(Rez.Strings.SetPace)
        ];
        var ids = [:distance, :pace];
        var menuView = new CustomMenuView(items, ids);
        WatchUi.pushView(menuView, new CustomMenuDelegate(menuView, _view.getCalculator()), WatchUi.SLIDE_UP);
    }
}