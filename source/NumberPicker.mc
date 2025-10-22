import Toybox.WatchUi;
import Toybox.Graphics;

class NumberPicker extends WatchUi.View {
    private var _title;
    private var _value;
    private var _min;
    private var _max;
    private var _step;

    function initialize(title, initial, min, max, step) {
        View.initialize();
        _title = title;
        _value = initial;
        _min = min;
        _max = max;
        _step = step;
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();
        dc.drawText(dc.getWidth()/2, 50, Graphics.FONT_MEDIUM, _title, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth()/2, 100, Graphics.FONT_LARGE, _value.format("%.1f"), Graphics.TEXT_JUSTIFY_CENTER);
    }

    function getValue() {
        return _value;
    }

    function increment() {
        if (_value + _step <= _max) {
            _value += _step;
            WatchUi.requestUpdate();
        }
    }

    function decrement() {
        if (_value - _step >= _min) {
            _value -= _step;
            WatchUi.requestUpdate();
        }
    }
}

class NumberPickerDelegate extends WatchUi.BehaviorDelegate {
    private var _callback;
    private var _picker;

    function initialize(callback) {
        BehaviorDelegate.initialize();
        _callback = callback;
    }

    function onKey(evt) {
        var key = evt.getKey();
        if (key == WatchUi.KEY_UP) {
            _picker.increment();
            return true;
        } else if (key == WatchUi.KEY_DOWN) {
            _picker.decrement();
            return true;
        }
        return false;
    }

    function onSelect() {
        _callback.invoke(_picker.getValue());
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}