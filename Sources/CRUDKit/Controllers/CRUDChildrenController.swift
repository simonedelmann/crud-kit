import Vapor
import Fluent

public struct CRUDChildrenController<T: Model & CRUDModel, ParentT: Model>: CRUDChildrenControllerProtocol where T.IDValue: LosslessStringConvertible, ParentT.IDValue: LosslessStringConvertible {
    public var idComponentKey: String
    public var parentIdComponentKey: String
    public var children: KeyPath<ParentT, ChildrenProperty<ParentT, T>>
    
}

public protocol CRUDChildrenControllerProtocol {
    associatedtype T: Model, CRUDModel where T.IDValue: LosslessStringConvertible
    associatedtype ParentT: Model where ParentT.IDValue: LosslessStringConvertible
    var idComponentKey: String { get }
    var parentIdComponentKey: String { get }
    
    var children: KeyPath<ParentT, ChildrenProperty<ParentT, T>> { get }
}

extension CRUDChildrenControllerProtocol {
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
    
    public var parent: KeyPath<T, ParentProperty<T, ParentT>> {
        switch ParentT()[keyPath: self.children].parentKey {
        case .required(let required):
            return required
        case .optional(_):
            fatalError("OptionalParent currently not supported")
        }
    }

    public func indexAll(req: Request) -> EventLoopFuture<[T.Public]> {
        ParentT.fetch(from: parentIdComponentKey, on: req).flatMap { parent in
            parent[keyPath: self.children].query(on: req.db).all().public(db: req.db)
        }
    }
    
    public func index(req: Request) -> EventLoopFuture<T.Public> {
        guard let id = T.getID(from: idComponentKey, on: req) else {
            return req.eventLoop.future(error: Abort(.notFound))
        }
        return ParentT.fetch(from: parentIdComponentKey, on: req).flatMap { parent in
            parent[keyPath: self.children].query(on: req.db)
                .filter(\._$id == id).first()
                .unwrap(or: Abort(.notFound))
                .public(db: req.db)
        }
    }

    public func create(req: Request) throws -> EventLoopFuture<T.Public> {
        try T.Create.validate(on: req)
        let data = try req.content.decode(T.Create.self)
        let model = try T.init(from: data)
        return ParentT.fetch(from: parentIdComponentKey, on: req).flatMap { parent in
            model[keyPath: self.parent].id = parent.id!
            return parent[keyPath: self.children].create(model, on: req.db)
                .map { model }.public(db: req.db)
        }
    }

    public func replace(req: Request) throws -> EventLoopFuture<T.Public> {
        guard let id = T.getID(from: idComponentKey, on: req) else {
            return req.eventLoop.future(error: Abort(.notFound))
        }
        try T.Replace.validate(on: req)
        let data = try req.content.decode(T.Replace.self)
        return ParentT.fetch(from: parentIdComponentKey, on: req).flatMap { parent in
            parent[keyPath: self.children].query(on: req.db)
                .filter(\._$id == id).first()
                .unwrap(or: Abort(.notFound))
                .flatMap { oldModel in
                    do {
                        let model = try oldModel.replace(with: data)
                        model.id = oldModel.id
                        model._$id.exists = oldModel._$id.exists
                        model[keyPath: self.parent].id = parent.id!
                        return model.update(on: req.db).map { model }.public(db: req.db)
                    } catch {
                        return req.eventLoop.makeFailedFuture(error)
                    }
            }
        }
    }

    public func delete(req: Request) -> EventLoopFuture<HTTPStatus> {
        guard let id = T.getID(from: idComponentKey, on: req) else {
            return req.eventLoop.future(error: Abort(.notFound))
        }
        return ParentT.fetch(from: parentIdComponentKey, on: req).flatMap { parent in
            parent[keyPath: self.children].query(on: req.db)
                .filter(\._$id == id).first()
                .unwrap(or: Abort(.notFound))
                .flatMap { $0.delete(on: req.db) }.map { .ok }
        }
    }
}

extension CRUDChildrenControllerProtocol where T: Patchable {
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
        guard let id = T.getID(from: idComponentKey, on: req) else {
            return req.eventLoop.future(error: Abort(.notFound))
        }
        try T.Patch.validate(on: req)
        let data = try req.content.decode(T.Patch.self)
        return ParentT.fetch(from: parentIdComponentKey, on: req).flatMap { parent in
            parent[keyPath: self.children].query(on: req.db)
                .filter(\._$id == id).first()
                .unwrap(or: Abort(.notFound))
                .flatMap { model in
                    do {
                        try model.patch(with: data)
                        return model.update(on: req.db).map { model }.public(db: req.db)
                    } catch {
                        return req.eventLoop.makeFailedFuture(error)
                    }
            }
        }
    }
}
