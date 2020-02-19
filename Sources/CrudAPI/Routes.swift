import Vapor
import Fluent

public func crud<T: Crudable & Model & Content>(_ app: Application, model: T.Type) throws {
    let path = PathComponent(stringLiteral: T.path)

    app.group(path) { routes in
        routes.get(use: CrudController<T>().indexAll)
    }
}
