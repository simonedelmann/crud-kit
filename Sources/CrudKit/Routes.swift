import Vapor
import Fluent

extension RoutesBuilder {
    public func crud<T: Model & Crudable>(_ endpoint: String, model: T.Type, custom: ((RoutesBuilder) -> ())? = nil) where T.IDValue: LosslessStringConvertible {
        let modelComponent = PathComponent(stringLiteral: endpoint)
        let idComponent = PathComponent(stringLiteral: ":\(endpoint)")
        let routes = self.grouped(modelComponent)
        let idRoutes = routes.grouped(idComponent)
        
        let controller = CrudController<T>(idComponentKey: endpoint)
        routes.get(use: controller.indexAll)
        routes.post(use: controller.create)
        idRoutes.get(use: controller.index)
        idRoutes.put(use: controller.replace)
        idRoutes.delete(use: controller.delete)
                
        custom?(idRoutes)
    }
    
    public func crud<T: Model & Crudable & Patchable>(_ endpoint: String, model: T.Type, custom: ((RoutesBuilder) -> ())? = nil) where T.IDValue: LosslessStringConvertible {
        let modelComponent = PathComponent(stringLiteral: endpoint)
        let idComponent = PathComponent(stringLiteral: ":\(endpoint)")
        let routes = self.grouped(modelComponent)
        let idRoutes = routes.grouped(idComponent)
        
        let controller = CrudController<T>(idComponentKey: endpoint)
        routes.get(use: controller.indexAll)
        routes.post(use: controller.create)
        idRoutes.get(use: controller.index)
        idRoutes.put(use: controller.replace)
        idRoutes.patch(use: controller.patch)
        idRoutes.delete(use: controller.delete)
                
        custom?(idRoutes)
    }
}
