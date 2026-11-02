import Toybox.Math;

class PaceCalculator {
    private var _distance = 42.2;
    private var _paceSeconds = 4 * 60 + 15;

    function initialize() {}

    function setDistance(distance) { _distance = distance; }
    function getDistance() { return _distance; }

    function setPaceSeconds(seconds) {
        _paceSeconds = Math.floor(seconds);
    }

    function getPaceSeconds() {
        return _paceSeconds;
    }

    function getPaceString() {
        return Utils.formatPace(_paceSeconds);
    }

    function calculateTime() {
        var totalSeconds = Math.round(_distance * _paceSeconds);
        var hours = Math.floor(totalSeconds / 3600);
        var rem = totalSeconds - hours * 3600;
        var minutes = Math.floor(rem / 60);
        var seconds = rem - minutes * 60;

        return Utils.formatTime(hours, minutes, seconds);
    }
}