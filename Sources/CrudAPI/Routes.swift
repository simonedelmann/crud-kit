import Vapor
import Fluent

public func crud<T: Crudable & Model & Content>(_ app: Application, model: T.Type) throws where T.IDValue: LosslessStringConvertible {
    let path = PathComponent(stringLiteral: T.path)

    app.group(path) { routes in
        let crud = CrudController<T>()
        routes.get(use: crud.indexAll)
        routes.get(":id", use: crud.index)
    }
}
