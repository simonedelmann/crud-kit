import Vapor
import Fluent

public struct CrudController<T: Crudable & Model & Content> {
    func indexAll(req: Request) -> EventLoopFuture<[T]> {
        return T.query(on: req.db).all()
    }
}
