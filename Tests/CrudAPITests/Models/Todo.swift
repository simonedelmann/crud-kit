import Vapor
import Fluent
import CrudAPI

final class Todo: Model, Content {
    static var schema = "todos"
    
    init() { }
    
    @ID(key: "id")
    var id: Int?
    
    @Field(key: "title")
    var title: String
    
    init(id: Int? = nil, title: String) {
        self.id = id
        self.title = title
    }
}

extension Todo: Crudable {
    static var path = "todos"
}

extension Todo {
    struct migration: Migration {
        var name = "TodoMigration"
        
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("todos")
                .field("id", .int, .identifier(auto: true))
                .field("title", .string, .required)
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("todos").delete()
        }
    }
}

extension Todo {
    static func seed(on database: Database) throws {
        try Todo(title: "Wash clothes").save(on: database).wait()
        try Todo(title: "Read book").save(on: database).wait()
        try Todo(title: "Prepare dinner").save(on: database).wait()
    }
}
