import Toybox.WatchUi;
import Toybox.System;

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
            selectPrevious();
            return true;
        } else if (key == WatchUi.KEY_DOWN) {
            selectNext();
            return true;
        } else if (key == WatchUi.KEY_ENTER) {
            openSelectedItem();
            return true;
        }
        return false;
    }

    function onTap(evt) {
        var y = evt.getCoordinates()[1];
        var screenHeight = System.getDeviceSettings().screenHeight;
        var index = y < screenHeight * 0.465 ? 0 : 1;
        _menuView.setSelected(index);
        openSelectedItem();
        return true;
    }

    function onNextPage() {
        selectNext();
        return true;
    }

    function onPreviousPage() {
        selectPrevious();
        return true;
    }

    private function selectNext() {
        var idx = (_menuView.getSelected() + 1) % _menuView.size();
        _menuView.setSelected(idx);
        WatchUi.requestUpdate();
    }

    private function selectPrevious() {
        var idx = _menuView.getSelected() - 1;
        if (idx < 0) {
            idx = _menuView.size() - 1;
        }
        _menuView.setSelected(idx);
        WatchUi.requestUpdate();
    }

    private function openSelectedItem() {
        var id = _menuView.getId(_menuView.getSelected());
        if (id == :distance) {
            var numberPicker = new NumberPicker(WatchUi.loadResource(Rez.Strings.SetDistance), _calculator.getDistance(), 0.1, 100.0, 0.1);
            WatchUi.pushView(numberPicker, new NumberPickerDelegate(numberPicker, method(:onDistanceSelected)), WatchUi.SLIDE_UP);
        } else if (id == :pace) {
            var pacePicker = new PacePicker(WatchUi.loadResource(Rez.Strings.SetPace), _calculator.getPaceSeconds(), 1, 15, 5);
            WatchUi.pushView(pacePicker, new PacePickerDelegate(pacePicker, method(:onPaceSelected)), WatchUi.SLIDE_UP);
        }
    }

    function onDistanceSelected(value) {
        _calculator.setDistance(value);
        WatchUi.requestUpdate();
    }

    function onPaceSelected(value) {
        _calculator.setPaceSeconds(value);
        WatchUi.requestUpdate();
    }
}