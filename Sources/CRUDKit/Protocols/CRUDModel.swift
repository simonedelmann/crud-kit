import Vapor
import Fluent

public protocol CRUDModel: Publicable, Createable, Replaceable {}
