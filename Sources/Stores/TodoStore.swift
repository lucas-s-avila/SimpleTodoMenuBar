import Foundation
import SwiftUI

@MainActor
class TodoStore: ObservableObject {
    @Published var todos: [TodoItem] = []
    
    private let saveKey = "todos.json"
    
    private var fileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(saveKey)
    }
    
    init() {
        load()
    }
    
    func add(_ title: String) {
        let todo = TodoItem(title: title)
        todos.insert(todo, at: 0)
        save()
    }
    
    func toggle(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
            save()
        }
    }
    
    func update(_ todo: TodoItem, title: String) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].title = title
            save()
        }
    }
    
    func delete(_ todo: TodoItem) {
        todos.removeAll { $0.id == todo.id }
        save()
    }
    
    func delete(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
        save()
    }
    
    func move(from source: Int, to destination: Int) {
        var updatedTodos = todos
        let item = updatedTodos.remove(at: source)
        updatedTodos.insert(item, at: destination > source ? destination - 1 : destination)
        todos = updatedTodos
        save()
    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(todos)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Failed to save todos: \(error)")
        }
    }
    
    private func load() {
        do {
            let data = try Data(contentsOf: fileURL)
            todos = try JSONDecoder().decode([TodoItem].self, from: data)
        } catch {
            todos = []
        }
    }
}

