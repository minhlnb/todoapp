import Foundation

class AddTodoViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var dueDate: Date = Date()
    
    private let repository: TodoRepository
    
    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func saveTodo() {
        guard isValid else { return }
        
        let newTodo = Todo(
            title: title.trimmingCharacters(in: .whitespaces),
            description: description.trimmingCharacters(in: .whitespaces),
            dueDate: dueDate
        )
        
        repository.addTodo(newTodo)
    }
    
    func reset() {
        title = ""
        description = ""
        dueDate = Date()
    }
}
