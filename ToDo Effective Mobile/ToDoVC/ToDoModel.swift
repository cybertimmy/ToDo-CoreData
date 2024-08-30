import UIKit
import CoreData

final class ToDoModel {
    
    static let shared = ToDoModel()

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getAllItems(completion: @escaping ([ToDoListItem]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let items = try self.context.fetch(ToDoListItem.fetchRequest())
                DispatchQueue.main.async {
                    completion(items)
                }
            } catch {
                print("Failed to fetch items: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    func createItem(name: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let newItem = ToDoListItem(context: self.context)
            newItem.name = name
            newItem.createdAt = Date()
            newItem.completed = false
            do {
                try self.context.save()
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                print("Failed to create item: \(error)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func deleteItem(item: ToDoListItem, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            self.context.delete(item)
            do {
                try self.context.save()
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                print("Failed to delete item: \(error)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func updateItem(item: ToDoListItem, newName: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            item.name = newName
            do {
                try self.context.save()
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                print("Failed to update item: \(error)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func updateItemDescription(item: ToDoListItem, newDescription: String, completion: @escaping (Bool) -> Void) {
           DispatchQueue.global(qos: .background).async {
               item.descriptionTask = newDescription
               do {
                   try self.context.save()
                   DispatchQueue.main.async {
                       completion(true)
                   }
               } catch {
                   DispatchQueue.main.async {
                       completion(false)
                   }
               }
           }
       }
   }
