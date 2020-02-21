import Vapor
import Fluent

public struct CrudController<T: Model & Content>: CrudControllerProtocol where T.IDValue: LosslessStringConvertible {
    typealias ModelT = T
    
    static func indexAll(req: Request) -> EventLoopFuture<[T]> {
        indexAll(on: req.db)
    }
    
    static func index(req: Request) -> EventLoopFuture<T> {
        let id: T.IDValue? = req.parameters.get("id")
        return index(id, on: req.db)
    }
}

extension CrudController where T: Publicable {
    static func indexAll(req: Request) -> EventLoopFuture<[T.Public]> {
        indexAll(on: req.db).public()
    }

    static func index(req: Request) -> EventLoopFuture<T.Public> {
        let id: T.IDValue? = req.parameters.get("id")
        return index(id, on: req.db).public()
    }
}


