import Vapor
import Fluent

struct CrudController<T: Model & Content & Publicable> where T.IDValue: LosslessStringConvertible { }

extension CrudController {
    func indexAll(req: Request) -> EventLoopFuture<[T.Public]> {
        T.query(on: req.db).all().public()
    }
    
    func index(req: Request) -> EventLoopFuture<T.Public> {
        T.fetch(from: "id", on: req).public()
    }
    
    func create(req: Request) throws -> EventLoopFuture<T.Public> {
        try T.validate(on: req)
        let data = try req.content.decode(T.self)
        return data.save(on: req.db).map { data }.public()
    }

    func replace(req: Request) throws -> EventLoopFuture<T.Public> {
        try T.validate(on: req)
        let data = try req.content.decode(T.self)
        return T.fetch(from: "id", on: req).flatMap {
            data.id = $0.id
            data._$id.exists = true
            return data.update(on: req.db).map { data }.public()
        }
    }

    func delete(req: Request) -> EventLoopFuture<HTTPStatus> {
        T.fetch(from: "id", on: req)
            .flatMap { $0.delete(on: req.db) }.map { .ok }
    }
}

extension CrudController where T: Createable {
    func create(req: Request) throws -> EventLoopFuture<T.Public> {
        try T.Create.validate(on: req)
        let data = try req.content.decode(T.Create.self)
        let model = try T.init(from: data)
        return model.save(on: req.db).map { model.public() }
    }
}

extension CrudController where T: Replaceable {
    func replace(req: Request) throws -> EventLoopFuture<T.Public> {
        try T.Replace.validate(on: req)
        let data = try req.content.decode(T.Replace.self)
        return T.fetch(from: "id", on: req).flatMap { model in
            do {
                try model.replace(with: data)
                return model.update(on: req.db).map { model }.public()
            } catch {
                return req.eventLoop.makeFailedFuture(error)
            }
        }
    }
}

extension CrudController where T: Patchable {
    func patch(req: Request) throws -> EventLoopFuture<T.Public> {
        try T.Patch.validate(on: req)
        let data = try req.content.decode(T.Patch.self)
        return T.fetch(from: "id", on: req).flatMap { model in
            do {
                try model.patch(with: data)
                return model.update(on: req.db).map { model }.public()
            } catch {
                return req.eventLoop.makeFailedFuture(error)
            }
        }
    }
}
