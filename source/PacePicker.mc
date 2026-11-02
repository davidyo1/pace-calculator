import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Math;
import Toybox.System;

class PacePicker extends WatchUi.View {
    private var _title;
    private var _minutes;
    private var _seconds;
    private var _minMinutes;
    private var _maxMinutes;
    private var _stepSeconds;
    private var _titleDrawable;
    private var _minutesDrawable;
    private var _sepDrawable;
    private var _secondsDrawable;
    private var _selectedComponent;
    private var _width;
    private var _height;

    function initialize(title, initialSeconds, minMinutes, maxMinutes, stepSeconds) {
        View.initialize();
        _title = title;

        _minMinutes = Math.floor(minMinutes);
        _maxMinutes = Math.floor(maxMinutes);
        _stepSeconds = Math.floor(stepSeconds);

        var totalSecs = Math.floor(initialSeconds);
        var minSecs = _minMinutes * 60;
        var maxSecs = (_maxMinutes * 60) + 59;
        if (totalSecs < minSecs) { totalSecs = minSecs; }
        if (totalSecs > maxSecs) { totalSecs = maxSecs; }
        setTotalSeconds(totalSecs);
        _selectedComponent = 0;
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.PacePickerLayout(dc));
        _width = dc.getWidth();
        _height = dc.getHeight();
        _titleDrawable = View.findDrawableById("pickerTitle");
        _minutesDrawable = View.findDrawableById("pickerMinutes");
        _sepDrawable = View.findDrawableById("pickerSep");
        _secondsDrawable = View.findDrawableById("pickerSeconds");
        updateDisplay();
    }

    function onShow() {
        updateDisplay();
    }

    function onUpdate(dc) {
        View.onUpdate(dc);
    }

    private function updateDisplay() {
        if (_titleDrawable != null) { _titleDrawable.setText(_title); }
        updateComponentPositions();

        if (_minutesDrawable != null) {
            _minutesDrawable.setText(_minutes.toString());
            _minutesDrawable.setColor(_selectedComponent == 0 ? Graphics.COLOR_WHITE : Graphics.COLOR_LT_GRAY);
        }
        if (_sepDrawable != null) {
            _sepDrawable.setText(":");
            _sepDrawable.setColor(_selectedComponent == 0 ? Graphics.COLOR_WHITE : Graphics.COLOR_LT_GRAY);
        }
        if (_secondsDrawable != null) {
            _secondsDrawable.setText(Utils._pad2Str(_seconds));
            _secondsDrawable.setColor(_selectedComponent == 1 ? Graphics.COLOR_WHITE : Graphics.COLOR_LT_GRAY);
        }
    }

    private function updateComponentPositions() {
        if (_minutesDrawable == null || _sepDrawable == null || _secondsDrawable == null) {
            return;
        }

        var minutesX = _width * 0.45;
        var separatorX = _width * 0.50;
        var secondsX = _width * 0.60;
        if (_minutes >= 10) {
            minutesX = _width * 0.42;
            separatorX = _width * 0.52;
            secondsX = _width * 0.62;
        }

        _minutesDrawable.setLocation(minutesX, _minutesDrawable.locY);
        _sepDrawable.setLocation(separatorX, _sepDrawable.locY);
        _secondsDrawable.setLocation(secondsX, _secondsDrawable.locY);
    }

    function increment() {
        var step = _selectedComponent == 0 ? 60 : _stepSeconds;
        var next = getTotalSeconds() + step;
        if (next <= (_maxMinutes * 60 + 59)) {
            setTotalSeconds(next);
        }
        updateDisplay();
        WatchUi.requestUpdate();
    }

    function decrement() {
        var step = _selectedComponent == 0 ? 60 : _stepSeconds;
        var next = getTotalSeconds() - step;
        if (next >= (_minMinutes * 60)) {
            setTotalSeconds(next);
        }
        updateDisplay();
        WatchUi.requestUpdate();
    }

    function toggleComponent() {
        _selectedComponent = (_selectedComponent == 0) ? 1 : 0;
        updateDisplay();
        WatchUi.requestUpdate();
    }

    function getTotalSeconds() {
        return _minutes * 60 + _seconds;
    }

    function setSelectedComponent(component) {
        if (component == 0 || component == 1) {
            _selectedComponent = component;
            updateDisplay();
            WatchUi.requestUpdate();
        }
    }

    function getWidth() {
        return _width;
    }

    function getHeight() {
        return _height;
    }

    private function setTotalSeconds(totalSeconds) {
        _minutes = Math.floor(totalSeconds / 60);
        _seconds = totalSeconds - (_minutes * 60);
    }
}

class PacePickerDelegate extends WatchUi.BehaviorDelegate {
    private var _picker;
    private var _callback;
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
        var coordinates = evt.getCoordinates();
        var x = coordinates[0];
        var y = coordinates[1];
        var width = _picker.getWidth();
        var height = _picker.getHeight();
        var component = x < width * 0.525 ? 0 : 1;

        if (y >= height * 0.40 && y <= height * 0.60) {
            _picker.setSelectedComponent(component);
        } else {
            save();
        }
        return true;
    }

    function onDrag(evt) {
        var coordinates = evt.getCoordinates();
        var x = coordinates[0];
        var y = coordinates[1];
        var type = evt.getType();

        if (type == WatchUi.DRAG_TYPE_START) {
            _picker.setSelectedComponent(x < _picker.getWidth() * 0.525 ? 0 : 1);
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

    function onNextPage() {
        _picker.toggleComponent();
        return true;
    }

    function onPreviousPage() {
        _picker.toggleComponent();
        return true;
    }

    function onBack() {
        cancel();
        return true;
    }

    private function save() {
        _callback.invoke(_picker.getTotalSeconds());
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