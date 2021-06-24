# CRUDKit for Vapor 4

**Not actively maintained** (see https://github.com/simonedelmann/crud-kit/issues/9)

We all write CRUD (Create-Read-Update-Delete) routes all the time. The intention of this package is to reduce repeating code and to provide a fast start for an API. 

## Contribution

This project is open for contributions. Feel free to clone, fork or make a PR. Help is very welcome!

## Installation

Add this package to your `Package.swift` as dependency and to your target.

```swift
dependencies: [
    .package(url: "https://github.com/simonedelmann/crud-kit.git", from: "1.1.0")
],
targets: [
    .target(name: "App", dependencies: [
        .product(name: "CRUDKit", package: "crud-kit")
    ])
]
```

## Basic Usage

### Conform you model to `CRUDModel`

```swift
import CRUDKit

final class Todo: Model, Content {
    @ID()
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "done")
    var done: Bool
    
    // ...
}

extension Todo: CRUDModel { }
```

### Registering routes in `routes.swift`

```swift
app.crud("todos", model: Todo.self)
```

This will register basic CRUD routes:

```
POST /todos             # create todo
GET /todos              # get all todos
GET /todos/:todos       # get todo
PUT /todos/:todos       # replace todo
DELETE /todos/:todos    # delete todo
```

Please note! The endpoints name (e.g. "todos") will be used as name for the named id parameter too. This is for avoiding duplications when having multiple parameters. 

## Additional features

### Custom public instance

You can return a custom struct as public instance, which will be returned from all CRUD routes then.

```swift
extension Todo: CRUDModel {
    struct Public: Content {
        var title: String
        var done: Bool
    }
    
    var `public`: Public {
        Public.init(title: title, done: done)
    }
}
```

That computed property will be converted to an `EventLoopFuture<Public>` afterwards. If you need to run asynchronous code to create your public instance (e.g. loading relationships), you can customize that conversion. Although you will have access to the database there, this should **not** be used to do any business logic.

```swift
extension Todo: CRUDModel {
    // ...
    
    // This is the default implementation
    func `public`(eventLoop: EventLoop, db: Database) -> EventLoopFuture<Public> {
        eventLoop.makeSucceededFuture(self.public)
    }
    
    // You can find an example for loading relationship in /Tests/CRUDKitTests/Models/Todo.swift
}
```

### Customize create / replace

You can add specific logic while create / replace. This is especially helpful, if your create / replace request should take a subset of the models properties or if you need to do special stuff while creating / replacing.

```swift
extension Todo: CRUDModel {
    struct Create: Content {
        var title: String
    }
    
    convenience init(from data: Create) {
        // Call model initializer with default value for done
        Todo.init(title: data.title, done: false)
        
        // Do custom stuff (e.g. hashing passwords)
    }

    struct Replace: Content {
        var title: String
    }
    
    func replace(with data: Replace) -> Self {
        // Replace all properties manually
        self.title = data.title
        
        // Again you can add custom stuff here
        
        // Return self
        return self
        
        // You can also return a new instance of your model, the id will be preserved.
    }
}
```

### Patch support

You can add patch support to your model by confirming to `Patchable`.

```
PATCH /todos/:todos     # patch todo
```

```swift
extension Todo: Patchable {
    struct Patch: Content {
        var title: String?
        var done: Bool?
    }
    
    func patch(with data: Patch) {
        if let title = data.title {
            self.title = title
        }
        
        // Shorter syntax
        self.done = data.done ?? self.done
    }
}
```

### Validations

To add automatic validation, you just need to conform your model (or your custom structs) to `Validatable`. 

```swift
extension Todo: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: .count(3...))
    }
}

// Using custom structs
extension Todo.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: .count(3...))
    }
}

extension Todo.Replace: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: .count(3...))
    }
}

extension Todo.Patch: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: .count(3...))
    }
}
```

### Custom routes

**Experimental** You can add your own child routes via a closure to `.crud()`. 

```swift
// routes.swift
app.crud("todos", model: Todo.self) { routes, _ in
    // GET /todos/:todos/hello 
    routes.get("hello") { _ in "Hello World" }
}
```

### Relationship support

**Experimental** Currently only Children relations are supported. See example below...

```swift
// Todo -> Tag
final class Todo: Model, Content {
    @Children(for: \.todo)
    var tags: [Tag]
    
    // ...
}

final class Tag: Model, Content { 
    @Parent(key: "todo_id")
    var todo: Todo
    
    // ...
}

extension Todo: CRUDModel { }
extension Tag: CRUDModel { }

// routes.swift
app.crud("todos", model: Todo.self) { routes, parentController in
    routes.crud("tags", children: Tag.self, on: parentController, via: \.$tags)
}
```

This will register CRUD routes for tags:

```
POST /todos/:todos/tags             # create tag
GET /todos/:todos/tags              # get all tags
GET /todos/:todos/tags/:tags        # get tag
PUT /todos/:todos/tags/:tags        # replace tag
PATCH /todos/:todos/tags/:tags      # patch tag (if Tag conforms to Patchable)
DELETE /todos/:todos/tags/:tags     # delete tag
```

Children relations support all features (public instances, custom create/replace, patch support, validations).

#### Notes on parent's id within payload

Currently Vapor does require to add the parent's id into a create / replace request. 

```swift
final class Tag: Model, Content {
    // ...
    
    @Parent(key: "todo_id")
    var todo: Todo
    
    init(id: Tag.IDValue? = nil, title: String, todo_id: Todo.IDValue) {
        // ...
        self.$todo.id = todo_id
    }
}

extension Tag: CRUDModel { }
```
This requires a create payload like this:
```
{
    title: "Foo",
    todo {
        id: 1 
    }
}
```

You can avoid that using a custom create / replace struct. This package will take care and fill the correct id for you.

```swift
final class Tag: Model, Content {
    // ...
    
    @Parent(key: "todo_id")
    var todo: Todo
    
    // Make todo_id parameter optional
    init(id: Tag.IDValue? = nil, title: String, todo_id: Todo.IDValue?) {
        // ...
        
        // Use if let for unwrapping the optional
        if let todo = todo_id {
            self.$todo.id = todo
        }
    }
}

extension Tag: CRUDModel {
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
```
Then you can create a child without parent id within payload.
```
{
    title: "Foo"
}
```
