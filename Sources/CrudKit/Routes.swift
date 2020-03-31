import Vapor
import Fluent

extension RoutesBuilder {
    public func crud<T: Model & Crudable>(_ endpoint: String, model: T.Type, custom: ((RoutesBuilder, CrudController<T>) -> ())? = nil) where T.IDValue: LosslessStringConvertible {
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
                
        custom?(idRoutes, controller)
    }
    
    public func crud<T: Model & Crudable & Patchable>(_ endpoint: String, model: T.Type, custom: ((RoutesBuilder, CrudController<T>) -> ())? = nil) where T.IDValue: LosslessStringConvertible {
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
                
        custom?(idRoutes, controller)
    }
    
    // MARK: Children
    
    public func crud<T: Model & Crudable, ParentT: Model>(_ endpoint: String, children: T.Type, on parentController: CrudController<ParentT>, via keypath: KeyPath<ParentT, ChildrenProperty<ParentT, T>>, custom: ((RoutesBuilder, CrudChildrenController<T, ParentT>) -> ())? = nil) where T.IDValue: LosslessStringConvertible {
        let modelComponent = PathComponent(stringLiteral: endpoint)
        let idComponent = PathComponent(stringLiteral: ":\(endpoint)")
        let routes = self.grouped(modelComponent)
        let idRoutes = routes.grouped(idComponent)
        
        let controller = CrudChildrenController<T, ParentT>(idComponentKey: endpoint, parentIdComponentKey: parentController.idComponentKey, children: keypath)
        routes.get(use: controller.indexAll)
        routes.post(use: controller.create)
        idRoutes.get(use: controller.index)
//        idRoutes.put(use: controller.replace)
//        idRoutes.delete(use: controller.delete)
                
        custom?(idRoutes, controller)
    }
}
