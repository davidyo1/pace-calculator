import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
using Toybox.WatchUi as Ui;

class MainView extends WatchUi.View {
    private var _calculator;
    private var _distanceValue;
    private var _paceValue;
    private var _timeValue;

    function initialize() {
        View.initialize();
        _calculator = new PaceCalculator();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
        
        // Get references to layout labels
        _distanceValue = View.findDrawableById("distanceValue");
        _paceValue = View.findDrawableById("paceValue");
        _timeValue = View.findDrawableById("timeValue");
        
        // Update initial values
        updateDisplay();
    }

    function onShow() {
        updateDisplay();
    }

    function onUpdate(dc) {
        View.onUpdate(dc);
    }

    private function updateDisplay() {
       _distanceValue.setText(_calculator.getDistance().format("%.1f") + " " + WatchUi.loadResource(Rez.Strings.KmUnit));
        // use sexagesimal pace string
        _paceValue.setText(_calculator.getPaceString() + " " + WatchUi.loadResource(Rez.Strings.PaceUnit));
        _timeValue.setText(_calculator.calculateTime());

    }

    function getCalculator() {
        return _calculator;
    }
}