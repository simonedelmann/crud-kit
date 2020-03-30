import Vapor
import Fluent
import CrudKit

final class Tag: Model, Content {
    static var schema = "tags"
    
    init() { }
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "title")
    var title: String
    
    @Parent(key: "todo_id")
    var todo: Todo
    
    init(id: Int? = nil, title: String) {
        self.id = id
        self.title = title
    }
}

extension Tag: Crudable { }

extension Tag {
    struct migration: Migration {
        var name = "TagMigration"
        
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("tags")
                .field("id", .int, .identifier(auto: true))
                .field("title", .string, .required)
                .field("todo_id", .int, .required, .references("todos", "id", onDelete: .cascade, onUpdate: .cascade))
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("tags").delete()
        }
    }
}

extension Tag {
    static func seed(on database: Database) throws {
        let todos = try Todo.query(on: database).all().wait()
        try todos.forEach { todo in
            try todo.$tags.create(Tag(title: "Important"), on: database).wait()
        }
    }
}
