import Vapor
import Fluent

public struct CrudController<T: Crudable & Model & Content> where T.IDValue: LosslessStringConvertible {
    func indexAll(req: Request) -> EventLoopFuture<[T]> {
        return T.query(on: req.db).all()
    }
    
    func index(req: Request) -> EventLoopFuture<T> {
        let id: T.IDValue? = req.parameters.get("id")
        return T.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
    }
}
