# CrudKit for Vapor 4

We all write CRUD (Create-Read-Update-Delete) routes all the time. The intention of this package is to reduce repeating code and to provide a fast start for an API. 

## Installation

Add this package to your `Package.swift` as dependency and to your target.

```swift
dependencies: [
    .package(url: "https://github.com/simonedelmann/crud-kit.git", from: "0.0.1")
],
targets: [
    .target(name: "App", dependencies: [
        .product(name: "CrudKit", package: "crud-kit")
    ])
]
```

## Basic Usage

##### Conform you model to `Publicable`

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

extension Todo: Publicable {
    // Use original model as public instance
    func `public`() -> Todo { self }
}
```

##### Registering routes in `routes.swift`

```swift
app.crud("todos", model: Todo.self)
```

This will register basic crud routes:

```
POST /todos         # create todo
GET /todos          # get all todos
GET /todos/:id      # get todo
PUT /todos/:id      # replace todo
DELETE /todos/:id   # delete todo
```

## Additional features

##### Custom public instance

You can return a custom struct as public instance, which will be returned from all CRUD routes then.

```swift
extension Todo: Publicable {
    struct Public: Content {
        var title: String
        var done: Bool
    }
    
    func `public`() -> Public {
        Public.init(title: title, done: done)
    }
}
```

##### Customize create / replace

You can confirm your model to `Createable` to add specific logic while create. This is especially helpful, if your create request should take a subset of the models properties.

```swift
extension Todo: Createable {
    struct Create: Content {
        var title: String
    }
    
    convenience init(from data: Create) {
        // Call model initializer with default value for done
        Todo.init(title: data.title, done: false)
        
        // Do custom stuff (e.g. hashing passwords)
    }
}

extension Todo: Replaceable {
    struct Replace: Content {
        var title: String
    }
    
    func replace(with data: Replace) {
        // Replace all properties manually
        self.title = data.title
        
        // Again you can add custom stuff here
    }
}
```

##### Patch support

You can add patch support to your model by confirming to `Patchable`.

```
PATCH /todos/:id      # patch todo
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

##### Add validations

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

## Planned features

##### Get rid of `Publicable` requirement

Currently it is required to conform to `Publicable`. In the future this package should be usable out of the box without any changes to any models. 

##### Relationship support
