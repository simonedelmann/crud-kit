import Vapor

public protocol Replaceable {
    associatedtype Replace: Content
    func replace(with data: Replace) throws
}
