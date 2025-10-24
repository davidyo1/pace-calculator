import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;

class NumberPicker extends WatchUi.View {
    private var _title;
    private var _value;
    private var _min;
    private var _max;
    private var _step;

    // drawables references
    private var _titleDrawable;
    private var _valueDrawable;

    function initialize(title, initial, min, max, step) {
        View.initialize();
        _title = title;
        _value = initial;
        _min = min;
        _max = max;
        _step = step;
    }

    function onLayout(dc) {
        // use layout file instead of drawing manually
        setLayout(Rez.Layouts.NumberPickerLayout(dc));
        _titleDrawable = View.findDrawableById("pickerTitle");
        _valueDrawable = View.findDrawableById("pickerValue");

        updateDisplay();
    }

    function onShow() {
        updateDisplay();
    }

    function onUpdate(dc) {
        // let framework draw the layout
        View.onUpdate(dc);
    }

    private function updateDisplay() {
        if (_titleDrawable != null) {
            _titleDrawable.setText(_title);
        }
        if (_valueDrawable != null) {
            _valueDrawable.setText(_value.format("%.1f"));
        }
    }

    function getValue() {
        return _value;
    }

    function increment() {
        if (_value + _step <= _max) {
            _value += _step;
            updateDisplay();
            WatchUi.requestUpdate();
        }
    }

    function decrement() {
        if (_value - _step >= _min) {
            _value -= _step;
            updateDisplay();
            WatchUi.requestUpdate();
        }
    }
}

class NumberPickerDelegate extends WatchUi.BehaviorDelegate {
    private var _callback;
    private var _picker;
    private var _lastKeyTime;
    private var _keyRepeatCount;

    function initialize(picker, callback) {
        BehaviorDelegate.initialize();
        _picker = picker;
        _callback = callback;
        _lastKeyTime = 0;
        _keyRepeatCount = 0;
    }

    function onKey(evt) {
        var key = evt.getKey();
        var currentTime = System.getTimer();
        
        if (key == WatchUi.KEY_UP) {
            handleKeyPress(currentTime, true);
            return true;
        } else if (key == WatchUi.KEY_DOWN) {
            handleKeyPress(currentTime, false);
            return true;
        }
        return false;
    }

    private function handleKeyPress(currentTime, isUp) {
        var timeDiff = currentTime - _lastKeyTime;
        
        // If this is a new key press (not a repeat)
        if (timeDiff > 1000 || _lastKeyTime == 0) {
            _keyRepeatCount = 0;
        } else {
            _keyRepeatCount++;
        }
        
        _lastKeyTime = currentTime;
        
        // Calculate how many steps to increment based on repeat count
        var steps = 1;
        if (_keyRepeatCount > 15) {
            steps = 10; // Very fast after 15 repeats
        } else if (_keyRepeatCount > 10) {
            steps = 5; // Fast after 10 repeats
        } else if (_keyRepeatCount > 5) {
            steps = 3; // Medium after 5 repeats
        } else if (_keyRepeatCount > 2) {
            steps = 2; // Slightly faster after 2 repeats
        }
        
        // Apply the steps
        for (var i = 0; i < steps; i++) {
            if (isUp) {
                _picker.increment();
            } else {
                _picker.decrement();
            }
        }
    }

    function onSelect() {
        _callback.invoke(_picker.getValue());
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}