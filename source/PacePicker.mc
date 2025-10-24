import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Math;

class PacePicker extends WatchUi.View {
    private var _title;
    private var _minutes;
    private var _seconds;
    private var _minMinutes;
    private var _maxMinutes;
    private var _stepSeconds;
    private var _titleDrawable;
    public var _minutesDrawable;
    private var _sepDrawable;
    public var _secondsDrawable;
    public var _selectedComponent; // 0 = minutes, 1 = seconds

    function initialize(title, initialMinutesFloat, minMinutes, maxMinutes, stepSeconds) {
        View.initialize();
        _title = title;

        // coerce numeric inputs to integer bounds to avoid UnexpectedTypeException
        _minMinutes = Math.floor(minMinutes);
        _maxMinutes = Math.floor(maxMinutes);
        _stepSeconds = Math.floor(stepSeconds);

        // convert initial minutes (float) to total seconds and clamp
        var totalSecs = Math.round(initialMinutesFloat * 60.0);
        if (totalSecs < (_minMinutes * 60)) { totalSecs = _minMinutes * 60; }
        var maxSecs = (_maxMinutes * 60) + 59;
        if (totalSecs > maxSecs) { totalSecs = maxSecs; }

        // Ensure proper integer conversion to avoid UnexpectedTypeException
        _minutes = Math.floor(totalSecs / 60);
        _seconds = totalSecs - (_minutes * 60);
        _selectedComponent = 0;
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.PacePickerLayout(dc));
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

    private function _pad2(n) {
        var s = n.toString();
        return (s.length() == 1) ? ("0" + s) : s;
    }

    private function updateDisplay() {
        if (_titleDrawable != null) { _titleDrawable.setText(_title); }

        if (_minutesDrawable != null) {
            var minutesInt = Math.floor(_minutes);
            _minutesDrawable.setText(Utils._stripIntegerString(minutesInt));
            _minutesDrawable.setColor(_selectedComponent == 0 ? Graphics.COLOR_WHITE : Graphics.COLOR_LT_GRAY);
        }
        if (_sepDrawable != null) {
            _sepDrawable.setText(":");
            _sepDrawable.setColor(_selectedComponent == 0 ? Graphics.COLOR_WHITE : Graphics.COLOR_LT_GRAY);
        }
        if (_secondsDrawable != null) {
            var secondsInt = Math.floor(_seconds);
            _secondsDrawable.setText(Utils._pad2Str(secondsInt));
            _secondsDrawable.setColor(_selectedComponent == 1 ? Graphics.COLOR_WHITE : Graphics.COLOR_LT_GRAY);
        }
    }

    function increment() {
        if (_selectedComponent == 0) {
            if (_minutes < _maxMinutes) {
                _minutes += 1;
            }
        } else {
            _seconds += _stepSeconds;
            while (_seconds >= 60) {
                _seconds -= 60;
                if (_minutes < _maxMinutes) { _minutes += 1; }
                else { _seconds = 59; break; }
            }
        }
        updateDisplay();
        WatchUi.requestUpdate();
    }

    function decrement() {
        if (_selectedComponent == 0) {
            if (_minutes > _minMinutes) {
                _minutes -= 1;
            }
        } else {
            _seconds -= _stepSeconds;
            while (_seconds < 0) {
                if (_minutes > _minMinutes) {
                    _minutes -= 1;
                    _seconds += 60;
                } else {
                    _seconds = 0;
                    break;
                }
            }
        }
        updateDisplay();
        WatchUi.requestUpdate();
    }

    function toggleComponent() {
        _selectedComponent = (_selectedComponent == 0) ? 1 : 0;
        updateDisplay();
        WatchUi.requestUpdate();
    }

    function getValue() {
        return _minutes + (_seconds / 60.0);
    }

    function getTotalSeconds() {
        return _minutes * 60 + _seconds;
    }

    function setSelectedComponent(component) {
        _selectedComponent = component;
        updateDisplay();
        WatchUi.requestUpdate();
    }
}

class PacePickerDelegate extends WatchUi.BehaviorDelegate {
    private var _picker;
    private var _callback;
    private var _selected;

    function initialize(picker, callback, selected) {
        BehaviorDelegate.initialize();
        _picker = picker;
        _callback = callback;
        _selected = selected;
    }

    function onKey(evt) {
        var key = evt.getKey();
        if(_selected){
            if (key == WatchUi.KEY_UP) {
                _picker.increment();
                return true;
            } else if (key == WatchUi.KEY_DOWN) {
                _picker.decrement();
                return true;
            } else if(key == WatchUi.KEY_ESC) {
                _selected = false;
                _picker._minutesDrawable.setBackgroundColor(Graphics.COLOR_BLACK);
                _picker._secondsDrawable.setBackgroundColor(Graphics.COLOR_BLACK);
                WatchUi.requestUpdate();
                return true;
            }
        }else{
            if (key == WatchUi.KEY_ENTER) {
                _selected = true;
                return true;
            } else if (key == WatchUi.KEY_UP || key == WatchUi.KEY_DOWN) {
                _picker.toggleComponent();
                return true;
            } else if (key == WatchUi.KEY_ESC) {
                // Exit pace picker
                _selected = false;
                _callback.invoke(_picker.getValue());
                WatchUi.popView(WatchUi.SLIDE_DOWN);
                return true;
            }
        }
        return false;
    }

    function onSelect() {
        if (_selected) {
            // If a component is selected, deselect it
            _selected = false;
            _picker._minutesDrawable.setBackgroundColor(Graphics.COLOR_BLACK);
            _picker._secondsDrawable.setBackgroundColor(Graphics.COLOR_BLACK);
        } else {
            // If no component is selected, select the current one
            _selected = true;
            if(_picker._selectedComponent == 0){
                _picker._minutesDrawable.setBackgroundColor(Graphics.COLOR_DK_GRAY);
            }else{
                _picker._secondsDrawable.setBackgroundColor(Graphics.COLOR_DK_GRAY);
            }
        }
        WatchUi.requestUpdate();
        return true;
    }
}