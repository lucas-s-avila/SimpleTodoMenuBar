import SwiftUI

struct ContentView: View {
    @ObservedObject var store: TodoStore
    @State private var newTaskTitle = ""
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.accentColor)
                
                TextField("Add Task...", text: $newTaskTitle)
                    .textFieldStyle(.plain)
                    .font(.system(size: 14))
                    .focused($isInputFocused)
                    .onSubmit {
                        addTask()
                    }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            if store.todos.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 32))
                        .foregroundColor(.secondary.opacity(0.5))
                    Text("No tasks yet")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 40)
            } else {
                ScrollView {
                    LazyVStack(spacing: 2) {
                        ForEach(store.todos) { todo in
                            TodoRowView(
                                todo: todo,
                                onToggle: { store.toggle(todo) },
                                onEdit: { newTitle in store.update(todo, title: newTitle) },
                                onDelete: { store.delete(todo) }
                            )
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            
            Divider()
            
            HStack {
                Text("\(store.todos.filter { !$0.isCompleted }.count) remaining")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if store.todos.contains(where: { $0.isCompleted }) {
                    Button("Clear Completed") {
                        withAnimation {
                            store.todos.removeAll { $0.isCompleted }
                        }
                    }
                    .font(.system(size: 11))
                    .buttonStyle(.plain)
                    .foregroundColor(.accentColor)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
        }
        .frame(width: 320, height: 400)
        .background(Color(NSColor.windowBackgroundColor))
    }
    
    private func addTask() {
        let trimmed = newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        store.add(trimmed)
        newTaskTitle = ""
    }
}

