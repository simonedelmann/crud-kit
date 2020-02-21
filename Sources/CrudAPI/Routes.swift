import Vapor
import Fluent

extension RoutesBuilder {
    public func crud<T: Model & Content>(model: T.Type) where T.IDValue: LosslessStringConvertible {
        registerCrud(self, model: model)
    }

    public func crud<T: Model & Content & Publicable>(model: T.Type) where T.IDValue: LosslessStringConvertible {
        registerCrud(self, model: model)
    }
}

internal func registerCrud<T: Model & Content>(_ routes: RoutesBuilder, model: T.Type) where T.IDValue: LosslessStringConvertible {
    routes.get(use: CrudController<T>.indexAll)
    routes.get(":id", use: CrudController<T>.index)
}
