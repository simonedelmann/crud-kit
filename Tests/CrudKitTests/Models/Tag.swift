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
    
    init(id: Int? = nil, title: String, todo_id: Todo.IDValue?) {
        self.id = id
        self.title = title
        if let todo = todo_id {
            self.$todo.id = todo
        }
    }
}

extension Tag: Crudable {
    struct Create: Content {
        var title: String
        var todo_id: Todo.IDValue?
    }

    convenience init(from data: Create) throws {
        self.init(title: data.title, todo_id: data.todo_id)
    }
    
    struct Replace: Content {
        var title: String
        var todo_id: Todo.IDValue?
    }
    
    func replace(with data: Replace) throws -> Self {
        Self.init(title: data.title, todo_id: data.todo_id)
    }
}

extension Tag: Patchable {
    struct Patch: Content {
        var title: String?
    }

    func patch(with data: Patch) throws {
        self.title = data.title ?? self.title
    }
}

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
            try todo.$tags.create(Tag(title: "Important", todo_id: todo.id!), on: database).wait()
        }
    }
}
