import SwiftUI

struct TodoRowView: View {
    let todo: TodoItem
    let onToggle: () -> Void
    let onEdit: (String) -> Void
    let onDelete: () -> Void
    
    @State private var isEditing = false
    @State private var editText = ""
    @State private var isHovering = false
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                ZStack {
                    Circle()
                        .fill(todo.isCompleted ? Color.accentColor : Color.clear)
                        .frame(width: 20, height: 20)
                    
                    Circle()
                        .strokeBorder(todo.isCompleted ? Color.accentColor : Color.gray.opacity(0.4), lineWidth: 1.5)
                        .frame(width: 20, height: 20)
                    
                    if todo.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .contentShape(Circle())
            }
            .buttonStyle(.borderless)
            
            if isEditing {
                TextField("", text: $editText, onCommit: {
                    if !editText.isEmpty {
                        onEdit(editText)
                    }
                    isEditing = false
                })
                .textFieldStyle(.plain)
                .font(.system(size: 13))
                .onExitCommand {
                    isEditing = false
                }
            } else {
                Text(todo.title)
                    .font(.system(size: 13))
                    .foregroundColor(todo.isCompleted ? .secondary : .primary)
                    .strikethrough(todo.isCompleted, color: .secondary)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            if isHovering && !isEditing {
                HStack(spacing: 4) {
                    Button(action: {
                        editText = todo.title
                        isEditing = true
                    }) {
                        Image(systemName: "pencil")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isHovering ? Color.gray.opacity(0.1) : Color.clear)
        .cornerRadius(6)
        .onHover { hovering in
            isHovering = hovering
        }
    }
}

