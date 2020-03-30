# CrudKit for Vapor 4

We all write CRUD (Create-Read-Update-Delete) routes all the time. The intention of this package is to reduce repeating code and to provide a fast start for an API. 

## Installation

Add this package to your `Package.swift` as dependency and to your target.

```swift
dependencies: [
    .package(url: "https://github.com/simonedelmann/crud-kit.git", .branch("master"))
],
targets: [
    .target(name: "App", dependencies: [
        .product(name: "CrudKit", package: "crud-kit")
    ])
]
```

## Basic Usage

### Conform you model to `Crudable`

```swift
import CrudKit

final class Todo: Model, Content {
    @ID()
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "done")
    var done: Bool
    
    // ...
}

extension Todo: Crudable { }
```

### Registering routes in `routes.swift`

```swift
app.crud("todos", model: Todo.self)
```

This will register basic crud routes:

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
extension Todo: Crudable {
    struct Public: Content {
        var title: String
        var done: Bool
    }
    
    func `public`() -> Public {
        Public.init(title: title, done: done)
    }
}
```

### Customize create / replace

You can add specific logic while create / replace. This is especially helpful, if your create / replace request should take a subset of the models properties or if you need to do special stuff while creating / replacing.

```swift
extension Todo: Crudable {
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
app.crud("todos", model: Todo.self) { routes in
    // GET /todos/:todos/hello 
    routes.get("hello") { _ in "Hello World" }
}
```

## Planned features for release

- Relationship support
