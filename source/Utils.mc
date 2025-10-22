import Toybox.Math;

class Utils {
    static function _stripIntegerString(n) {
        // convert number to string and remove fractional part if any
        var s = n.toString();
        var idx = s.find(".");
        if (idx != null) { s = s.substring(0, idx); }
        return s;
    }

    static function _pad2Str(n) {
        var s = Utils._stripIntegerString(n);
        return (s.length() == 1) ? ("0" + s) : s;
    }

    // format HH:MM:SS
    static function formatTime(hours, minutes, seconds) {
        if (hours == null || minutes == null || seconds == null) {
            return "00:00:00";
        }
        var h = Utils._stripIntegerString(Math.floor(hours));
        if (h.length == 1) {h = "0" + h;}
        var m = Utils._pad2Str(Math.floor(minutes));
        var s = Utils._pad2Str(Math.floor(seconds));
        return h + ":" + m + ":" + s;
    }

    // format pace (seconds) as M:SS (no left pad for minutes, pad seconds)
    static function formatPace(totalSeconds) {
        if (totalSeconds == null) {return "0:00";}
        var ts = Math.floor(totalSeconds);
        var m = Math.floor(ts / 60);
        var s = ts - m * 60;
        var ms = Utils._stripIntegerString(Math.floor(m));
        var ss = Utils._pad2Str(Math.floor(s));
        return ms + ":" + ss;
    }
}