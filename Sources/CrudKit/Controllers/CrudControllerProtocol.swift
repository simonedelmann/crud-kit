import Vapor
import Fluent

protocol CrudControllerProtocol {
    associatedtype ModelT: Model & Content where ModelT.IDValue: LosslessStringConvertible
}

extension CrudControllerProtocol {
    internal func indexAll(on database: Database) -> EventLoopFuture<[ModelT]> {
        ModelT.query(on: database).all()
    }
    
    internal func index(_ id: ModelT.IDValue?, on database: Database) -> EventLoopFuture<ModelT> {
        ModelT.find(id, on: database).unwrap(or: Abort(.notFound))
    }
    
    internal func create(from data: ModelT, on database: Database) -> EventLoopFuture<ModelT> {
        data.save(on: database).map { data }
    }
    
    internal func replace(_ id: ModelT.IDValue?, from data: ModelT, on database: Database) -> EventLoopFuture<ModelT> {
        ModelT.find(id, on: database).unwrap(or: Abort(.notFound))
            .flatMap { model in
                data.id = model.id
                data._$id.exists = true
                return data.update(on: database).map { data }
        }
    }
    
    internal func delete(_ id: ModelT.IDValue?, on database: Database) -> EventLoopFuture<HTTPStatus> {
        ModelT.find(id, on: database)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: database) }
            .map { .ok }
    }
}

extension CrudControllerProtocol where ModelT: Createable {
    internal func create(from data: ModelT.Create, on database: Database) -> EventLoopFuture<ModelT> {
        do {
            let model = try ModelT.init(from: data)
            return model.save(on: database).map { model }
        } catch {
            return database.eventLoop.makeFailedFuture(error)
        }
    }
}

extension CrudControllerProtocol where ModelT: Replaceable {
    internal func replace(_ id: ModelT.IDValue?, from data: ModelT.Replace, on database: Database) -> EventLoopFuture<ModelT> {
        ModelT.find(id, on: database).unwrap(or: Abort(.notFound))
            .flatMap { model in
                do {
                    try model.replace(with: data)
                    return model.update(on: database).map { model }
                } catch {
                    return database.eventLoop.makeFailedFuture(error)
                }
        }
    }
}

extension CrudControllerProtocol where ModelT: Patchable {
    internal func patch(_ id: ModelT.IDValue?, from data: ModelT.Patch, on database: Database) -> EventLoopFuture<ModelT> {
        ModelT.find(id, on: database).unwrap(or: Abort(.notFound))
            .flatMap { model in
                do {
                    try model.patch(with: data)
                    return model.update(on: database).map { model }
                } catch {
                    return database.eventLoop.makeFailedFuture(error)
                }
        }
    }
}
