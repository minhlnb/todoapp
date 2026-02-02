import SwiftUI

struct TodoListView: View {
    @StateObject var viewModel: TodoListViewModel
    @State private var showingAddTodo = false
    @State private var showingDeleteAlert = false
    @State private var showingCompleteAlert = false
    @State private var showCelebration = false
    @State private var itemToDelete: Todo?
    @State private var selectedTodo: Todo?
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 0) {
                    DatePickerRow(viewModel: viewModel)
                        .padding(.vertical, 10)
                    
                    HStack(spacing: 15) {
                        StatisticCard(title: "Hoàn thành", count: viewModel.completedCount, color: .black)
                        StatisticCard(title: "Chưa xong", count: viewModel.pendingCount, color: .gray.opacity(0.6))
                    }
                    .padding()
                    
                    SearchBar(text: $viewModel.searchText)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    
                    List {
                        ForEach(viewModel.filteredTodos) { todo in
                            TodoRowView(todo: todo) {
                                selectedTodo = todo
                                showingCompleteAlert = true
                            }
                        }
                        .onDelete { indexSet in
                            if let index = indexSet.first {
                                itemToDelete = viewModel.filteredTodos[index]
                                showingDeleteAlert = true
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                
                Button(action: { showingAddTodo = true }) {
                    Image(systemName: "plus")
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .frame(width: 65, height: 65)
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(25)
                
                if showCelebration {
                    ZStack {
                        Color.black.opacity(0.1)
                            .ignoresSafeArea()
                            .onTapGesture { showCelebration = false }

                        VStack(spacing: 16) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.black)
                                .shadow(color: .black.opacity(0.5), radius: 10)
                            
                            VStack(spacing: 4) {
                                Text("GIỎI LẮM!")
                                    .font(.system(.title2, design: .rounded))
                                    .fontWeight(.black)
                                
                                Text("Nhiệm vụ đã hoàn thành")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(30)
                        .background(.ultraThinMaterial)
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.8).combined(with: .opacity),
                            removal: .opacity.combined(with: .scale(scale: 1.2))
                        ))
                    }
                    .zIndex(2) 
                }
            }
            .navigationTitle("Nhiệm vụ")
            .sheet(isPresented: $showingAddTodo) {
                AddTodoView(repository: viewModel.repository)
            }
            .alert("Xác nhận xóa", isPresented: $showingDeleteAlert) {
                Button("Hủy", role: .cancel) { itemToDelete = nil }
                Button("Xóa", role: .destructive) {
                    if let todo = itemToDelete {
                        viewModel.deleteTodo(todo)
                    }
                    itemToDelete = nil
                }
            } message: {
                Text("Bạn có chắc chắn muốn xóa nhiệm vụ này không?")
            }
            .alert((selectedTodo?.isCompleted ?? false) ? "Chưa xong nhiệm vụ này hả?" : "Xong nhiệm vụ này rồi?", isPresented: $showingCompleteAlert) {
                Button("Hủy", role: .cancel) { selectedTodo = nil }
                Button("Đồng ý") {
                    if let todo = selectedTodo {
                        if !todo.isCompleted {
                            triggerSuccessHaptic()
                            withAnimation(.spring()) { showCelebration = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                                withAnimation { showCelebration = false }
                            }
                        }
                        viewModel.toggleComplete(todo)
                    }
                    selectedTodo = nil
                }
            }
        }
    }
}

func triggerSuccessHaptic() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
}

struct StatisticCard: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            Text("\(count)")
                .font(.title2)
                .fontWeight(.black)
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(color)
        .cornerRadius(12)
    }
}

struct SearchBar: View {
    @Binding var text: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.gray)
            TextField("Tìm kiếm công việc...", text: $text)
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct DatePickerRow: View {
    @ObservedObject var viewModel: TodoListViewModel
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.dateList, id: \.self) { date in
                    VStack(spacing: 5) {
                        Text(date.format("EEE")).font(.system(size: 10, weight: .bold))
                        Text(date.format("d")).font(.system(size: 16, weight: .black))
                    }
                    .foregroundColor(Calendar.current.isDate(viewModel.selectedDate, inSameDayAs: date) ? .white : .primary)
                    .frame(width: 45, height: 60)
                    .background(Calendar.current.isDate(viewModel.selectedDate, inSameDayAs: date) ? Color.black : Color(.systemGray6))
                    .cornerRadius(10)
                    .onTapGesture {
                        withAnimation(.snappy) { viewModel.selectedDate = date }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

extension Date {
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
