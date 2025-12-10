# TodoMenuBar

A simple macOS menu bar todo app built with SwiftUI.

## Features

- Lives in the menu bar (no Dock icon)
- Add, complete, edit, and delete tasks
- Data persists locally between app restarts
- Clean, native macOS look and feel

## Requirements

- macOS 13.0 (Ventura) or later
- Xcode 15 or later

## Building the App

### Option 1: Create Xcode Project (Recommended)

1. Open Xcode
2. File → New → Project
3. Choose **macOS** → **App**
4. Configure:
   - Product Name: `TodoMenuBar`
   - Interface: **SwiftUI**
   - Language: **Swift**
5. Delete the auto-generated `ContentView.swift` and `TodoMenuBarApp.swift`
6. Drag the `Sources` folder contents into your Xcode project
7. In Project Settings → Target → Info, add:
   - Key: `Application is agent (UIElement)` → Value: `YES`
8. Build and Run (⌘R)

### Option 2: Swift Package (Command Line)

```bash
swift build -c release
```

Note: The command line build creates an executable, but for a proper menu bar app experience with the correct Info.plist settings, use Option 1.

## Usage

- Click the checkmark icon (✓) in the menu bar to open the app
- Type in the text field and press Enter to add a task
- Click the circle to mark a task as complete
- Hover over a task to see edit (pencil) and delete (trash) buttons
- Click "Clear Completed" to remove all completed tasks

## File Storage

Tasks are saved to:
```
~/Documents/todos.json
```

