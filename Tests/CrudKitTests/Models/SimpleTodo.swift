import Vapor
import Fluent
import CrudKit

final class SimpleTodo: Model, Content {
    static var schema = "todos"
    
    init() { }
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "title")
    var title: String
    
    init(id: Int? = nil, title: String) {
        self.id = id
        self.title = title
    }
}

extension SimpleTodo: Publicable {}

