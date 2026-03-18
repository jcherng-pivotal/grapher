# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Grapher is a Swift Playgrounds App (`.swiftpm`) that visualizes Bible verse relationships as an interactive node-and-edge graph. It targets iOS 16+ and macOS 13+ using SwiftUI.

## Build & Run

This is a Swift Playground App project. Open `Grapher.swiftpm` in Xcode or Swift Playgrounds on iPad/Mac. There is no separate build command — use Xcode's build/run (Cmd+R) or Swift Playgrounds' Run button.

To build from command line:
```
cd Grapher.swiftpm && swift build
```

## Architecture

- **Package.swift** — SPM manifest; single executable target `AppModule` with all Swift files at the package root (`Grapher.swiftpm/`).
- **MyApp.swift** — `@main` app entry point, launches `ContentView` in a `WindowGroup`.
- **Models.swift** — Data layer: `VerseNode` (id, reference, text, position) and `VerseEdge` (source, target, type). `MockData` singleton provides hardcoded sample data.
- **ContentView.swift** — Main UI: renders nodes as tappable circles with labels and edges as lines inside a `GeometryReader`/`ZStack`. Tapping a node displays its verse text.

All source files live directly in `Grapher.swiftpm/` (flat structure, no subdirectories).
