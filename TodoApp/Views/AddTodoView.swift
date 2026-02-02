import SwiftUI

struct AddTodoView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: AddTodoViewModel
    
    init(repository: TodoRepository) {
        _viewModel = StateObject(wrappedValue: AddTodoViewModel(repository: repository))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Thông tin")) {
                    TextField("Tiêu đề", text: $viewModel.title)
                    
                    TextField("Ghi chú (Note)", text: $viewModel.description, axis: .vertical)
                        .lineLimit(5, reservesSpace: true)
                }
                    Section(header: Text("Ngày thực hiện")) {
                        DatePicker("Chọn ngày", selection: $viewModel.dueDate, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .accentColor(.black)
        
                }
                
            }
            .navigationTitle("Thêm Todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Hủy") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Lưu") {
                        viewModel.saveTodo()
                        dismiss()
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
}

// Tạo một class Mock đơn giản
class MockTodoRepository: TodoRepository {
    func save(_ todo: Todo) {
        print("Mock: Đã lưu \(todo.title)")
    }
    
    func fetchAll() -> [Todo] {
        return [] // Trả về mảng rỗng cho preview
    }
    
    func delete(_ todo: Todo) {}
    func update(_ todo: Todo) {}
}



#Preview {
    // Khởi tạo Mock Repository
    let mockRepo = MockTodoRepository()
    
    // Truyền vào View
    return AddTodoView(repository: mockRepo)
}
