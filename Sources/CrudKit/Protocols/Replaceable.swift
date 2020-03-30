import Vapor

public protocol Replaceable: Content {
    associatedtype Replace: Content = Self
    func replace(with data: Replace) throws -> Self
}

extension Replaceable where Replace == Self {
    public func replace(with data: Replace) throws -> Self {
        return data
    }
}
