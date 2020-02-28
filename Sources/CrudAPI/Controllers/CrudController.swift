import Vapor
import Fluent

struct CrudController<T: Model & Content & Publicable>: CrudControllerProtocol where T.IDValue: LosslessStringConvertible {
    typealias ModelT = T
    
    internal func validate<Type>(_ type: Type, on request: Request) throws {
        if let validatable = type.self as? Validatable.Type {
            try validatable.validate(request)
        }
    }
    
    func indexAll(req: Request) -> EventLoopFuture<[T.Public]> {
        indexAll(on: req.db).public()
    }
    
    func index(req: Request) -> EventLoopFuture<T.Public> {
        let id: T.IDValue? = req.parameters.get("id")
        return index(id, on: req.db).public()
    }
    
    func create(req: Request) throws -> EventLoopFuture<T.Public> {
        try validate(T.self, on: req)
        let data = try req.content.decode(T.self)
        return create(from: data, on: req.db).public()
    }

    func replace(req: Request) throws -> EventLoopFuture<T.Public> {
        try validate(T.self, on: req)
        let id: T.IDValue? = req.parameters.get("id")
        let data = try req.content.decode(T.self)
        return replace(id, from: data, on: req.db).public()
    }

    func delete(req: Request) -> EventLoopFuture<HTTPStatus> {
        let id: T.IDValue? = req.parameters.get("id")
        return delete(id, on: req.db)
    }
}

extension CrudController where T: Createable {
    func create(req: Request) throws -> EventLoopFuture<T.Public> {
        try validate(T.Create.self, on: req)
        let data = try req.content.decode(T.Create.self)
        return create(from: data, on: req.db).public()
    }
}

extension CrudController where T: Replaceable {
    func replace(req: Request) throws -> EventLoopFuture<T.Public> {
        try validate(T.Replace.self, on: req)
        let id: T.IDValue? = req.parameters.get("id")
        let data = try req.content.decode(T.Replace.self)
        return replace(id, from: data, on: req.db).public()
    }
}
