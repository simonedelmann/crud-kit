import Vapor

public protocol Createable: Content {
    associatedtype Create: Content = Self
    init(from data: Create) throws
}

extension Createable where Create: Content, Create == Self {
    public init(from data: Create) throws {
        self = data
    }
}
