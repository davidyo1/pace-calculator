import Toybox.WatchUi;
import Toybox.System;

class MenuDelegate extends WatchUi.MenuInputDelegate {
    private var _calculator;

    function initialize(calculator) {
        MenuInputDelegate.initialize();
        _calculator = calculator;
    }

    function onMenuItem(item) {
        if (item == :menu_distance) {
            pushNumberPicker("Distance", _calculator.getDistance(), 0.1, 100.0, 0.1, method(:onDistanceSelected));
        } else if (item == :menu_pace) {
            // use minutes as float for the picker, convert to sexagesimal seconds on selection
            pushNumberPicker("Pace (min/km)", _calculator.getPaceAsMinutesFloat(), 1.0, 15.0, 0.1, method(:onPaceSelected));
        }
    }

    function onDistanceSelected(value) {
        _calculator.setDistance(value);
        WatchUi.requestUpdate();
    }

    function onPaceSelected(value) {
        // convert float minutes (e.g. 4.5) into seconds-per-km inside PaceCalculator
        _calculator.setPaceFromMinutesFloat(value);
        WatchUi.requestUpdate();
    }

    private function pushNumberPicker(title, initial, min, max, step, callback) {
        var numberPicker = new NumberPicker(title, initial, min, max, step);
        WatchUi.pushView(numberPicker, new NumberPickerDelegate(callback), WatchUi.SLIDE_UP);
    }
}