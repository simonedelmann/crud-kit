import Vapor
import Fluent

public struct CRUDController<T: Model & CRUDModel>: CRUDControllerProtocol where T.IDValue: LosslessStringConvertible {
    public var idComponentKey: String
}

public protocol CRUDControllerProtocol {
    associatedtype T: Model, CRUDModel where T.IDValue: LosslessStringConvertible
    var idComponentKey: String { get }
}

extension CRUDControllerProtocol {
    public func setup(_ routesBuilder: RoutesBuilder, on endpoint: String) {
        let modelComponent = PathComponent(stringLiteral: endpoint)
        let idComponent = PathComponent(stringLiteral: ":\(idComponentKey)")
        let routes = routesBuilder.grouped(modelComponent)
        let idRoutes = routes.grouped(idComponent)
        
        routes.get(use: self.indexAll)
        routes.post(use: self.create)
        idRoutes.get(use: self.index)
        idRoutes.put(use: self.replace)
        idRoutes.delete(use: self.delete)
    }
    
    public func indexAll(req: Request) -> EventLoopFuture<[T.Public]> {
        T.query(on: req.db).all().public()
    }
    
    public func index(req: Request) -> EventLoopFuture<T.Public> {
        T.fetch(from: idComponentKey, on: req).public()
    }
    
    public func create(req: Request) throws -> EventLoopFuture<T.Public> {
        try T.Create.validate(on: req)
        let data = try req.content.decode(T.Create.self)
        let model = try T.init(from: data)
        return model.save(on: req.db).map { model }.public()
    }

    public func replace(req: Request) throws -> EventLoopFuture<T.Public> {
        try T.Replace.validate(on: req)
        let data = try req.content.decode(T.Replace.self)
        return T.fetch(from: idComponentKey, on: req).flatMap { oldModel in
            do {
                let model = try oldModel.replace(with: data)
                model.id = oldModel.id
                model._$id.exists = oldModel._$id.exists
                return model.update(on: req.db).map { model }.public()
            } catch {
                return req.eventLoop.makeFailedFuture(error)
            }
        }
    }

    public func delete(req: Request) -> EventLoopFuture<HTTPStatus> {
        T.fetch(from: idComponentKey, on: req)
            .flatMap { $0.delete(on: req.db) }.map { .ok }
    }
}

extension CRUDControllerProtocol where T: Patchable {
    public func setup(_ routesBuilder: RoutesBuilder, on endpoint: String) {
            let modelComponent = PathComponent(stringLiteral: endpoint)
            let idComponent = PathComponent(stringLiteral: ":\(idComponentKey)")
            let routes = routesBuilder.grouped(modelComponent)
            let idRoutes = routes.grouped(idComponent)
            
            routes.get(use: self.indexAll)
            routes.post(use: self.create)
            idRoutes.get(use: self.index)
            idRoutes.put(use: self.replace)
            idRoutes.patch(use: self.patch)
            idRoutes.delete(use: self.delete)
        }
    
    public func patch(req: Request) throws -> EventLoopFuture<T.Public> {
        try T.Patch.validate(on: req)
        let data = try req.content.decode(T.Patch.self)
        return T.fetch(from: idComponentKey, on: req).flatMap { model in
            do {
                try model.patch(with: data)
                return model.update(on: req.db).map { model }.public()
            } catch {
                return req.eventLoop.makeFailedFuture(error)
            }
        }
    }
}
