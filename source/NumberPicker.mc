import Toybox.WatchUi;
import Toybox.Math;
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
    private var _height;

    function initialize(title, initial, min, max, step) {
        View.initialize();
        _title = title;
        _value = initial;
        _min = min;
        _max = max;
        _step = step;
        _value = Math.round(_value * 10.0) / 10.0;
        if (_value < _min) {
            _value = _min;
        } else if (_value > _max) {
            _value = _max;
        }
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.NumberPickerLayout(dc));
        _height = dc.getHeight();
        _titleDrawable = View.findDrawableById("pickerTitle");
        _valueDrawable = View.findDrawableById("pickerValue");

        updateDisplay();
    }

    function onShow() {
        updateDisplay();
    }

    function onUpdate(dc) {
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
        var next = Math.round(_value * 10.0) + Math.round(_step * 10.0);
        if (next <= Math.round(_max * 10.0)) {
            _value = next / 10.0;
            updateDisplay();
            WatchUi.requestUpdate();
        }
    }

    function decrement() {
        var next = Math.round(_value * 10.0) - Math.round(_step * 10.0);
        if (next >= Math.round(_min * 10.0)) {
            _value = next / 10.0;
            updateDisplay();
            WatchUi.requestUpdate();
        }
    }

    function getHeight() {
        return _height;
    }
}

class NumberPickerDelegate extends WatchUi.BehaviorDelegate {
    private var _callback;
    private var _picker;
    private var _lastKeyTime;
    private var _keyRepeatCount;
    private var _lastDragY;
    private var _dragRemainder;

    function initialize(picker, callback) {
        BehaviorDelegate.initialize();
        _picker = picker;
        _callback = callback;
        _lastKeyTime = 0;
        _keyRepeatCount = 0;
        _lastDragY = 0;
        _dragRemainder = 0;
    }

    function onKey(evt) {
        var key = evt.getKey();

        if (key == WatchUi.KEY_UP) {
            handleKeyPress(true);
            return true;
        } else if (key == WatchUi.KEY_DOWN) {
            handleKeyPress(false);
            return true;
        } else if (key == WatchUi.KEY_ENTER) {
            save();
            return true;
        } else if (key == WatchUi.KEY_ESC) {
            cancel();
            return true;
        }
        return false;
    }

    function onTap(evt) {
        save();
        return true;
    }

    function onDrag(evt) {
        var coordinates = evt.getCoordinates();
        var y = coordinates[1];
        var type = evt.getType();

        if (type == WatchUi.DRAG_TYPE_START) {
            _lastDragY = y;
            _dragRemainder = 0;
        } else if (type == WatchUi.DRAG_TYPE_CONTINUE) {
            var movement = _lastDragY - y;
            _lastDragY = y;
            _dragRemainder += movement;
            var threshold = _picker.getHeight() / 20;

            while (_dragRemainder >= threshold) {
                _picker.increment();
                _dragRemainder -= threshold;
            }
            while (_dragRemainder <= -threshold) {
                _picker.decrement();
                _dragRemainder += threshold;
            }
        } else if (type == WatchUi.DRAG_TYPE_STOP) {
            _dragRemainder = 0;
        }
        return true;
    }

    function onSelect() {
        save();
        return true;
    }

    function onBack() {
        cancel();
        return true;
    }

    private function save() {
        _callback.invoke(_picker.getValue());
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    private function cancel() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    private function handleKeyPress(isUp) {
        var currentTime = System.getTimer();
        var timeDiff = currentTime - _lastKeyTime;

        if (_lastKeyTime == 0 || timeDiff > 1000) {
            _keyRepeatCount = 0;
        } else {
            _keyRepeatCount++;
        }
        _lastKeyTime = currentTime;

        var steps = getAcceleratedSteps();
        for (var i = 0; i < steps; i++) {
            if (isUp) {
                _picker.increment();
            } else {
                _picker.decrement();
            }
        }
    }

    private function getAcceleratedSteps() {
        if (_keyRepeatCount > 15) {
            return 10;
        } else if (_keyRepeatCount > 10) {
            return 5;
        } else if (_keyRepeatCount > 5) {
            return 3;
        } else if (_keyRepeatCount > 2) {
            return 2;
        }
        return 1;
    }
}