# Garmin Pace Calculator

A Connect IQ watch app that estimates the time needed to cover a distance at a selected running pace. It currently supports kilometers, pace in minutes and seconds per kilometer, and English and Spanish UI strings.

## Project layout

`source/`
- App.mc — application entry
- `MainView.mc` - calculator display
- `MainDelegate.mc` - opens the settings menu
- `CustomMenuView.mc` / `CustomMenuDelegate.mc` - distance and pace menu
- `NumberPicker.mc` - distance picker and input delegate
- `PacePicker.mc` - pace picker and input delegate
- `PaceCalculator.mc` - distance/pace state and time calculation
- `Utils.mc` - time and pace formatting

`resources/`
- `layouts/` - calculator, menu, and picker layouts
- `strings/strings.xml` - English strings
- `drawables/` - launcher icon

`resources-spa/strings/strings.xml` contains the Spanish strings. Keep its string IDs in sync with the English file.

## Using the app

- Tap the calculator screen, or press Enter, to open the settings menu.
- Tap a menu item to open its picker.
- In the distance picker, drag up or down to adjust the value. Tap anywhere to save.
- In the pace picker, tap the minutes or seconds value to choose that component, then drag up or down to adjust it. Tap elsewhere to save.
- Button controls are also available: Up/Down adjust values, Enter saves, and Back cancels. Repeated button presses accelerate. In the pace picker, the device's next/previous-page controls switch between minutes and seconds.

The default distance is 42.2 km and the default pace is 4:15 min/km. Distance changes use 0.1 km steps, pace changes use 5-second steps, and the calculated time is rounded to the nearest second.

## Build and run

1. Make sure Connect IQ SDK and the VS Code Connect IQ extension are installed.
2. Run `Monkey C: Clean Project`, then `Monkey C: Build Project` from the Command Palette.
3. Run the app with `Monkey C: Run on Simulator` or the Connect IQ extension's Run control.
4. To check localized strings, set the simulator/device language to English or Spanish and rebuild if needed.

## Contribution

Keep English and Spanish string IDs consistent. The project does not currently include automated tests.

## License

MIT
