import Vapor
import Fluent

public func crud<T: Crudable & Model>(_ app: Application, model: T.Type) throws {
    let path = PathComponent(stringLiteral: T.path)

    app.group(path) { routes in
        // Dummy
        routes.get { req in
            HTTPStatus(statusCode: 200)
        }
    }
}
