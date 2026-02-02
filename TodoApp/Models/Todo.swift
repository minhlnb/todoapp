import Foundation

struct Todo: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var isCompleted: Bool
    var createdAt: Date
    var dueDate: Date
    
    init(id: UUID = UUID(), title: String, description: String = "", isCompleted: Bool = false, createdAt: Date = Date(), dueDate: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.dueDate = dueDate
    }
}
