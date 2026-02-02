import Foundation

class TodoRepository: ObservableObject {
    @Published var todos: [Todo] = [] {
        didSet {
            saveToPersistence()
        }
    }
    
    private let saveKey = "my_todo_list"
    
    init() {
        self.todos = loadTodos()
    }
    
    private func saveToPersistence() {
        if let encoded = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    func loadTodos() -> [Todo] {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let savedItems = try? JSONDecoder().decode([Todo].self, from: data) else {
            return [
                Todo(title: "Học Swift", description: "Hoàn thành khóa học cơ bản", isCompleted: false, dueDate: Date()),
                Todo(title: "Làm bài tập", description: "Nộp bài đúng hạn", isCompleted: false, dueDate: Date())
            ]
        }
        return savedItems
    }
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
    }
    
    func deleteTodo(_ todo: Todo) {
        todos.removeAll { $0.id == todo.id }
    }
    
    func toggleComplete(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
        }
    }
}
