import Vapor
import Fluent

struct CrudController<T: Model & Content & Publicable>: CrudControllerProtocol where T.IDValue: LosslessStringConvertible {
    typealias ModelT = T
    
    func indexAll(req: Request) -> EventLoopFuture<[T.Public]> {
        indexAll(on: req.db).public()
    }
    
    func index(req: Request) -> EventLoopFuture<T.Public> {
        let id: T.IDValue? = req.parameters.get("id")
        return index(id, on: req.db).public()
    }
}

