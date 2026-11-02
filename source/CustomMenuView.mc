import Toybox.WatchUi;
import Toybox.Graphics;

class CustomMenuView extends WatchUi.View {
    private var _items;
    private var _ids;
    private var _selected;
    private var _itemDrawables;
    private var _height;

    function initialize(items, ids) {
        View.initialize();
        _items = items;
        _ids = ids;
        _selected = 0;
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.CustomMenuLayout(dc));
        _height = dc.getHeight();
        _itemDrawables = [
            View.findDrawableById("menuItem0"),
            View.findDrawableById("menuItem1")
        ];
        updateDisplay();
    }

    function onShow() {
        updateDisplay();
    }

    function updateDisplay() {
        // iterate over drawables, use corresponding item if present
        for (var i = 0; i < _itemDrawables.size(); i++) {
            var d = _itemDrawables[i];
            if (d != null) {
                var text = "";
                if (i < _items.size()) {
                    text = _items[i];
                }
                d.setText(text);
                if (i == _selected) {
                    d.setColor(Graphics.COLOR_WHITE);
                } else {
                    d.setColor(Graphics.COLOR_LT_GRAY);
                }
            }
        }
    }

    function size() {
        return _items.size();
    }

    function setSelected(idx) {
        _selected = idx;
        updateDisplay();
    }

    function getSelected() {
        return _selected;
    }

    function getItemAtY(y) {
        var firstDistance = y - (_height * 0.35);
        var secondDistance = y - (_height * 0.50);
        if (firstDistance < 0) { firstDistance = -firstDistance; }
        if (secondDistance < 0) { secondDistance = -secondDistance; }
        if (firstDistance > _height * 0.10 && secondDistance > _height * 0.10) {
            return -1;
        }
        return firstDistance < secondDistance ? 0 : 1;
    }

    function getId(idx) {
        if (idx >= 0 && idx < _ids.size()) {
            return _ids[idx];
        }
        return null;
    }
}