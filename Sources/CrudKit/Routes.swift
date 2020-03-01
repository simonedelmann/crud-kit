import Vapor
import Fluent

extension RoutesBuilder {
    public func crud<T: Model & Content & Publicable>(model: T.Type) where T.IDValue: LosslessStringConvertible {
        let crudController = CrudController<T>()
        self.get(use: crudController.indexAll)
        self.get(":id", use: crudController.index)
        self.post(use: crudController.create)
        self.put(":id", use: crudController.replace)
        self.delete(":id", use: crudController.delete)
    }
    
    public func crud<T: Model & Content & Publicable & Createable>(model: T.Type) where T.IDValue: LosslessStringConvertible {
        let crudController = CrudController<T>()
        self.get(use: crudController.indexAll)
        self.get(":id", use: crudController.index)
        self.post(use: crudController.create)
        self.put(":id", use: crudController.replace)
        self.delete(":id", use: crudController.delete)
    }
    
    public func crud<T: Model & Content & Publicable & Replaceable>(model: T.Type) where T.IDValue: LosslessStringConvertible {
        let crudController = CrudController<T>()
        self.get(use: crudController.indexAll)
        self.get(":id", use: crudController.index)
        self.post(use: crudController.create)
        self.put(":id", use: crudController.replace)
        self.delete(":id", use: crudController.delete)
    }
    
    public func crud<T: Model & Content & Publicable & Createable & Replaceable>(model: T.Type) where T.IDValue: LosslessStringConvertible {
        let crudController = CrudController<T>()
        self.get(use: crudController.indexAll)
        self.get(":id", use: crudController.index)
        self.post(use: crudController.create)
        self.put(":id", use: crudController.replace)
        self.delete(":id", use: crudController.delete)
    }
    
    public func crud<T: Model & Content & Publicable & Patchable>(model: T.Type) where T.IDValue: LosslessStringConvertible {
        let crudController = CrudController<T>()
        self.get(use: crudController.indexAll)
        self.get(":id", use: crudController.index)
        self.post(use: crudController.create)
        self.put(":id", use: crudController.replace)
        self.patch(":id", use: crudController.patch)
        self.delete(":id", use: crudController.delete)
    }
    
    public func crud<T: Model & Content & Publicable & Createable & Patchable>(model: T.Type) where T.IDValue: LosslessStringConvertible {
        let crudController = CrudController<T>()
        self.get(use: crudController.indexAll)
        self.get(":id", use: crudController.index)
        self.post(use: crudController.create)
        self.put(":id", use: crudController.replace)
        self.patch(":id", use: crudController.patch)
        self.delete(":id", use: crudController.delete)
    }
    
    public func crud<T: Model & Content & Publicable & Replaceable & Patchable>(model: T.Type) where T.IDValue: LosslessStringConvertible {
        let crudController = CrudController<T>()
        self.get(use: crudController.indexAll)
        self.get(":id", use: crudController.index)
        self.post(use: crudController.create)
        self.put(":id", use: crudController.replace)
        self.patch(":id", use: crudController.patch)
        self.delete(":id", use: crudController.delete)
    }
    
    public func crud<T: Model & Content & Publicable & Createable & Replaceable & Patchable>(model: T.Type) where T.IDValue: LosslessStringConvertible {
        let crudController = CrudController<T>()
        self.get(use: crudController.indexAll)
        self.get(":id", use: crudController.index)
        self.post(use: crudController.create)
        self.put(":id", use: crudController.replace)
        self.patch(":id", use: crudController.patch)
        self.delete(":id", use: crudController.delete)
    }
}
