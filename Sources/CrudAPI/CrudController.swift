import Vapor
import Fluent

protocol CrudControllerProtocol {
    associatedtype ModelT: Crudable & Model & Content where ModelT.IDValue: LosslessStringConvertible
}

extension CrudControllerProtocol {
    internal static func indexAll(on database: Database) -> EventLoopFuture<[ModelT]> {
        return ModelT.query(on: database).all()
    }
    
    internal static func index(_ id: ModelT.IDValue?, on database: Database) -> EventLoopFuture<ModelT> {
        return ModelT.find(id, on: database).unwrap(or: Abort(.notFound))
    }
}

public struct CrudController<T: Crudable & Model & Content>: CrudControllerProtocol where T.IDValue: LosslessStringConvertible {
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


