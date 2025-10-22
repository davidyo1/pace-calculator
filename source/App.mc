import Toybox.Application;
import Toybox.WatchUi;

class App extends Application.AppBase {
    private var _view;

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        _view = new MainView();
        return [_view, new MainDelegate(_view)];
    }
}