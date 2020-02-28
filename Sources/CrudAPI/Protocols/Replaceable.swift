import Vapor

public protocol Replaceable {
    associatedtype Replace: Content
    func replace(from data: Replace)
}
