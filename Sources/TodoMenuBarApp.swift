import SwiftUI

@main
struct TodoMenuBarApp: App {
    @StateObject private var store = TodoStore()
    
    var body: some Scene {
        MenuBarExtra {
            ContentView(store: store)
        } label: {
            Image(systemName: "checkmark.circle.fill")
                .symbolRenderingMode(.hierarchical)
        }
        .menuBarExtraStyle(.window)
    }
}

