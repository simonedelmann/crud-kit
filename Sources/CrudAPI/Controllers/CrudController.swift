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
    
    func delete(req: Request) -> EventLoopFuture<HTTPStatus> {
        let id: T.IDValue? = req.parameters.get("id")
        return delete(id, on: req.db)
    }
}

extension CrudController where T: Createable {
    func create(req: Request) throws -> EventLoopFuture<T.Public> {
        if let validatable = T.Create.self as? Validatable.Type {
            try validatable.validate(req)
        }
        let data = try req.content.decode(T.Create.self)
        return create(from: data, on: req.db).public()
    }
}
