import Vapor
import Fluent

extension RoutesBuilder {
    public func crud<T: Model & Content & Crudable>(model: T.Type) where T.IDValue: LosslessStringConvertible {
        let crudController = CrudController<T>()
        self.get(use: crudController.indexAll)
        self.get(":id", use: crudController.index)
        self.post(use: crudController.create)
    }
}
