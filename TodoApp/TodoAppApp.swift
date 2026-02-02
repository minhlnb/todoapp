//
//  TodoAppApp.swift
//  TodoApp
//
//  Created by minhgaa on 30/1/26.
//

import SwiftUI

@main
struct TodoAppApp: App {
    @StateObject private var repository = TodoRepository()
    
    var body: some Scene {
        WindowGroup {
            TodoListView(viewModel: TodoListViewModel(repository: repository))
        }
    }
}

#Preview {
    TodoListView(viewModel: TodoListViewModel(repository:    TodoRepository()))
}
