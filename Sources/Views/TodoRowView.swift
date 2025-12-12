import SwiftUI
import UniformTypeIdentifiers

struct TodoRowView: View {
    let todo: TodoItem
    let onToggle: () -> Void
    let onEdit: (String) -> Void
    let onDelete: () -> Void
    let index: Int
    let onDragStarted: (Int) -> Void
    let onDropReceived: (Int) -> Void
    
    @State private var isEditing = false
    @State private var editText = ""
    @State private var isHovering = false
    @State private var isDragTarget = false
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(isHovering ? .secondary : .clear)
                .frame(width: 16)
                .onDrag {
                    onDragStarted(index)
                    return NSItemProvider(object: todo.id.uuidString as NSString)
                } preview: {
                    DragPreviewView(title: todo.title, isCompleted: todo.isCompleted)
                }
            
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
        .background(isDragTarget ? Color.accentColor.opacity(0.2) : (isHovering ? Color.gray.opacity(0.1) : Color.clear))
        .cornerRadius(6)
        .onHover { hovering in
            isHovering = hovering
        }
        .onDrop(of: [UTType.text], delegate: TodoDropDelegate(
            index: index,
            isDragTarget: $isDragTarget,
            onDropReceived: onDropReceived
        ))
    }
}

struct DragPreviewView: View {
    let title: String
    let isCompleted: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(isCompleted ? Color.accentColor : Color.clear)
                    .frame(width: 20, height: 20)
                
                Circle()
                    .strokeBorder(isCompleted ? Color.accentColor : Color.gray.opacity(0.4), lineWidth: 1.5)
                    .frame(width: 20, height: 20)
                
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(isCompleted ? .secondary : .primary)
                .strikethrough(isCompleted, color: .secondary)
                .lineLimit(1)
            
            Spacer()
        }
        .frame(width: 280)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(6)
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

struct TodoDropDelegate: DropDelegate {
    let index: Int
    @Binding var isDragTarget: Bool
    let onDropReceived: (Int) -> Void
    
    func performDrop(info: DropInfo) -> Bool {
        isDragTarget = false
        onDropReceived(index)
        return true
    }
    
    func dropEntered(info: DropInfo) {
        isDragTarget = true
    }
    
    func dropExited(info: DropInfo) {
        isDragTarget = false
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}

