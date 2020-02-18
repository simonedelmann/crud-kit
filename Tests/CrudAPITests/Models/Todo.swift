import Fluent
import CrudAPI

final class Todo: Crudable, Model {
    static var schema = "todos"
    static var path = "todos"
    
    init() { }
    
    @ID(key: "id")
    var id: Int?
    
    init(id: Int? = nil) {
        self.id = id
    }
}
