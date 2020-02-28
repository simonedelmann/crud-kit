import Vapor

public protocol Createable {
    associatedtype Create: Content
    init(from create: Create)
}
