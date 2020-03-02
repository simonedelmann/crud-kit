import Vapor

public protocol Createable {
    associatedtype Create: Content
    init(from data: Create) throws
}
