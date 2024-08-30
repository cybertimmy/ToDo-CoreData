import Foundation
import CoreData

@objc(ToDoListItem)
public class ToDoListItem: NSManagedObject {
    @NSManaged public var completed: Bool
    @NSManaged public var descriptionTask: String
}
