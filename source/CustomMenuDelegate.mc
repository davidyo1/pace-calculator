import Toybox.WatchUi;

class CustomMenuDelegate extends WatchUi.BehaviorDelegate {
    private var _menuView;
    private var _calculator;

    function initialize(menuView, calculator) {
        BehaviorDelegate.initialize();
        _menuView = menuView;
        _calculator = calculator;
    }

    function onKey(evt) {
        var key = evt.getKey();

        if (key == WatchUi.KEY_UP) {
            var idx = _menuView.getSelected();
            idx = (idx - 1) < 0 ? (_menuView.size() - 1) : (idx - 1);
            _menuView.setSelected(idx);
            WatchUi.requestUpdate();
            return true;
        } else if (key == WatchUi.KEY_DOWN) {
            var idx = _menuView.getSelected();
            idx = (idx + 1) >= _menuView.size() ? 0 : (idx + 1);
            _menuView.setSelected(idx);
            WatchUi.requestUpdate();
            return true;
        } else if (key == WatchUi.KEY_ENTER) {
            var idx = _menuView.getSelected();
            var id = _menuView.getId(idx);
            if (id == :distance) {
                var numberPicker = new NumberPicker(WatchUi.loadResource(Rez.Strings.SetDistance), _calculator.getDistance(), 0.1, 100.0, 0.1);
                WatchUi.pushView(numberPicker, new NumberPickerDelegate(numberPicker, method(:onDistanceSelected)), WatchUi.SLIDE_UP);
                return true;
            } else if (id == :pace) {
                var initial = _calculator.getPaceAsMinutesFloat();
                var pacePicker = new PacePicker(WatchUi.loadResource(Rez.Strings.SetPace), initial, 1, 15, 5); // stepSeconds = 5
                WatchUi.pushView(pacePicker, new PacePickerDelegate(pacePicker, method(:onPaceSelected), false), WatchUi.SLIDE_UP);
                return true;
            }
        }

        return false;
    }

    function onDistanceSelected(value) {
        _calculator.setDistance(value);
        WatchUi.requestUpdate();
    }

    function onPaceSelected(value) {
        _calculator.setPaceFromMinutesFloat(value);
        WatchUi.requestUpdate();
    }
}