import Foundation
import Combine

class TodoListViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    @Published var searchText: String = ""
    @Published var selectedDate: Date = Date()
    
    let repository: TodoRepository
    private var cancellables = Set<AnyCancellable>()
    
    var dateList: [Date] {
        (0..<15).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: Date()) }
    }
    var filteredTodosByDate: [Todo] {
        todos.filter { todo in
            Calendar.current.isDate(todo.dueDate, inSameDayAs: selectedDate)
        }
    }
    
    var filteredTodos: [Todo] {
        let listByDate = filteredTodosByDate
        if searchText.isEmpty {
            return listByDate
        }
        return listByDate.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    
    var completedCount: Int { todos.filter { todo in
        todo.isCompleted && Calendar.current.isDate(todo.dueDate, inSameDayAs: selectedDate)
    }.count}
    
    var pendingCount: Int {
        todos.filter { !$0.isCompleted && Calendar.current.isDate($0.dueDate, inSameDayAs: selectedDate)}.count
    }
    
    init(repository: TodoRepository) {
        self.repository = repository
        
        repository.$todos
            .assign(to: \.todos, on: self)
            .store(in: &cancellables)
    }
    
    func toggleComplete(_ todo: Todo) {
        repository.toggleComplete(todo)
    }
    
    func deleteTodo(_ todo: Todo) {
        repository.deleteTodo(todo)
    }
}
