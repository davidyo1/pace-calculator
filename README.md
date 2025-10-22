# Garmin Pace Calculator

A small Connect IQ watch app that calculates the time required to run a given distance at a given pace.  
Current implementation supports distance in kilometers, pace as sexagesimal (minutes:seconds per km), localized strings (English / Spanish) and a basic number picker.

## Project layout
source/
- App.mc — application entry
- MainView.mc — main UI view (uses Rez layout)
- MainDelegate.mc — main behavior (opens menu)
- MenuDelegate.mc — handles menu actions and launches pickers
- NumberPicker.mc — generic numeric picker view
- PaceCalculator.mc — business logic; stores pace as seconds-per-km and computes total time
- Utils.mc — formatting helpers (HH:MM:SS, M:SS)

resources/
- layouts/layout.xml — main layout (labels with IDs: distanceValue, paceValue, timeValue)
- strings/strings.xml — default (English) strings
- drawables/drawables.xml — icons, if present

resources-spa/
- strings/strings.xml — Spanish strings (alternative resource directory used in this project)

manifest.xml — app manifest (lists supported languages: `eng`, `spa`)  
project.properties — build metadata  
monkey.jungle — project file for the toolchain

## Key behavior
- Pace is stored as total seconds per kilometer (`PaceCalculator._paceSeconds`).
- Display:
  - Pace shown as `M:SS` via `Utils.formatPace()`
  - Total time shown as `HH:MM:SS` via `Utils.formatTime()`
- Locale selection is driven by the manifest languages entry and the resource files. The simulator/device language determines which resource bundle is used.

## Build & run (VS Code / Connect IQ extension)
1. Make sure Connect IQ SDK and the VS Code Connect IQ extension are installed.
2. Clean & build:
   - Command Palette → `Monkey C: Clean Project`
   - Command Palette → `Monkey C: Build Project`
   - (Or delete `bin/` then build)
3. Run in simulator:
   - Command Palette → `Monkey C: Run on Simulator` or use the Run control in the Connect IQ extension.
4. When changing resources or languages, restart the simulator and rebuild the app.

## Contribution
- Fork, add tests or features (PacePicker, meters support, mile option), open PRs.
- Keep strings consistent across language files (same ids).

## License
MIT