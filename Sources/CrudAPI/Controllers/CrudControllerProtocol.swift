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
    
    internal func delete(_ id: ModelT.IDValue?, on database: Database) -> EventLoopFuture<HTTPStatus> {
        ModelT.find(id, on: database)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: database) }
            .map { .ok }
    }
}

extension CrudControllerProtocol where ModelT: Createable {
    internal func create(from data: ModelT.Create, on database: Database) -> EventLoopFuture<ModelT> {
        let model = ModelT.init(from: data)
        return model.save(on: database).map { model }
    }
}
