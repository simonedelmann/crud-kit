import Vapor
import Fluent

extension RoutesBuilder {
    public func crud<T: Model & Content & Publicable>(_ endpoint: String, model: T.Type) where T.IDValue: LosslessStringConvertible {
        let controller = CrudController<T>(idComponentKey: "id")
        let routes = self.grouped(PathComponent(stringLiteral: endpoint))
        let idComponent = PathComponent(stringLiteral: ":\(controller.idComponentKey)")
        
        routes.get(use: controller.indexAll)
        routes.get(idComponent, use: controller.index)
        routes.post(use: controller.create)
        routes.put(idComponent, use: controller.replace)
        routes.delete(idComponent, use: controller.delete)
    }
    
    public func crud<T: Model & Content & Publicable & Createable>(_ endpoint: String, model: T.Type) where T.IDValue: LosslessStringConvertible {
        let controller = CrudController<T>(idComponentKey: "id")
        let routes = self.grouped(PathComponent(stringLiteral: endpoint))
        let idComponent = PathComponent(stringLiteral: ":\(controller.idComponentKey)")
        
        routes.get(use: controller.indexAll)
        routes.get(idComponent, use: controller.index)
        routes.post(use: controller.create)
        routes.put(idComponent, use: controller.replace)
        routes.delete(idComponent, use: controller.delete)
    }
    
    public func crud<T: Model & Content & Publicable & Replaceable>(_ endpoint: String, model: T.Type) where T.IDValue: LosslessStringConvertible {
        let controller = CrudController<T>(idComponentKey: "id")
        let routes = self.grouped(PathComponent(stringLiteral: endpoint))
        let idComponent = PathComponent(stringLiteral: ":\(controller.idComponentKey)")
        
        routes.get(use: controller.indexAll)
        routes.get(idComponent, use: controller.index)
        routes.post(use: controller.create)
        routes.put(idComponent, use: controller.replace)
        routes.delete(idComponent, use: controller.delete)
    }
    
    public func crud<T: Model & Content & Publicable & Createable & Replaceable>(_ endpoint: String, model: T.Type) where T.IDValue: LosslessStringConvertible {
        let controller = CrudController<T>(idComponentKey: "id")
        let routes = self.grouped(PathComponent(stringLiteral: endpoint))
        let idComponent = PathComponent(stringLiteral: ":\(controller.idComponentKey)")
        
        routes.get(use: controller.indexAll)
        routes.get(idComponent, use: controller.index)
        routes.post(use: controller.create)
        routes.put(idComponent, use: controller.replace)
        routes.delete(idComponent, use: controller.delete)
    }
    
    public func crud<T: Model & Content & Publicable & Patchable>(_ endpoint: String, model: T.Type) where T.IDValue: LosslessStringConvertible {
        let controller = CrudController<T>(idComponentKey: "id")
        let routes = self.grouped(PathComponent(stringLiteral: endpoint))
        let idComponent = PathComponent(stringLiteral: ":\(controller.idComponentKey)")
        
        routes.get(use: controller.indexAll)
        routes.get(idComponent, use: controller.index)
        routes.post(use: controller.create)
        routes.put(idComponent, use: controller.replace)
        routes.delete(idComponent, use: controller.delete)
        routes.patch(idComponent, use: controller.patch)
    }
    
    public func crud<T: Model & Content & Publicable & Createable & Patchable>(_ endpoint: String, model: T.Type) where T.IDValue: LosslessStringConvertible {
        let controller = CrudController<T>(idComponentKey: "id")
        let routes = self.grouped(PathComponent(stringLiteral: endpoint))
        let idComponent = PathComponent(stringLiteral: ":\(controller.idComponentKey)")
        
        routes.get(use: controller.indexAll)
        routes.get(idComponent, use: controller.index)
        routes.post(use: controller.create)
        routes.put(idComponent, use: controller.replace)
        routes.delete(idComponent, use: controller.delete)
        routes.patch(idComponent, use: controller.patch)
    }
    
    public func crud<T: Model & Content & Publicable & Replaceable & Patchable>(_ endpoint: String, model: T.Type) where T.IDValue: LosslessStringConvertible {
        let controller = CrudController<T>(idComponentKey: "id")
        let routes = self.grouped(PathComponent(stringLiteral: endpoint))
        let idComponent = PathComponent(stringLiteral: ":\(controller.idComponentKey)")
        
        routes.get(use: controller.indexAll)
        routes.get(idComponent, use: controller.index)
        routes.post(use: controller.create)
        routes.put(idComponent, use: controller.replace)
        routes.delete(idComponent, use: controller.delete)
        routes.patch(idComponent, use: controller.patch)
    }
    
    public func crud<T: Model & Content & Publicable & Createable & Replaceable & Patchable>(_ endpoint: String, model: T.Type) where T.IDValue: LosslessStringConvertible {
        let controller = CrudController<T>(idComponentKey: "id")
        let routes = self.grouped(PathComponent(stringLiteral: endpoint))
        let idComponent = PathComponent(stringLiteral: ":\(controller.idComponentKey)")
        
        routes.get(use: controller.indexAll)
        routes.get(idComponent, use: controller.index)
        routes.post(use: controller.create)
        routes.put(idComponent, use: controller.replace)
        routes.delete(idComponent, use: controller.delete)
        routes.patch(idComponent, use: controller.patch)
    }
}
