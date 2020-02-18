import Vapor
import Fluent

public func crud(_ app: Application, model: Crudable.Type) throws {
    let path = PathComponent(stringLiteral: model.path)

    app.group(path) { routes in
        // Dummy
        routes.get { req in
            "Hello, World"
        }
    }
}
