class PaceCalculator {
    // store pace as integer seconds per km
    private var _distance = 42.192; // km
    private var _paceSeconds = 4 * 60 + 15; // default 4:30 -> 270s

    function initialize() {}

    // distance in kilometers (float)
    function setDistance(distance) { _distance = distance; }
    function getDistance() { return _distance; }

    // set pace by components (minutes, seconds)
    function setPaceFromComponents(minutes, seconds) {
        _paceSeconds = Math.floor(minutes) * 60 + Math.floor(seconds);
    }

    // set pace from float minutes (e.g. 4.5 -> 4:30)
    function setPaceFromMinutesFloat(minsFloat) {
        _paceSeconds = Math.floor(minsFloat * 60.0 + 0.5);
    }

    // return pace as total seconds
    function getPaceSeconds() {
        return _paceSeconds;
    }

    // return a display string "M:SS" (uses Utils)
    function getPaceString() {
        return Utils.formatPace(_paceSeconds);
    }

    // return pace as float minutes (for compatibility)
    function getPaceAsMinutesFloat() {
        return _paceSeconds / 60.0;
    }

    // calculate total time (HH:MM:SS) using paceSeconds
    function calculateTime() {
        var totalSeconds = Math.floor(_distance * _paceSeconds); // integer total seconds
        var hours = Math.floor(totalSeconds / 3600);
        var rem = totalSeconds - hours * 3600;
        var minutes = Math.floor(rem / 60);
        var seconds = rem - minutes * 60;

        return Utils.formatTime(hours, minutes, seconds);
    }
}