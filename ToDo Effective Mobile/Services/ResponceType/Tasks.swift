import Foundation

struct Tasks: Decodable {
    let todos: [Todo]
}

struct Todo: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
}
