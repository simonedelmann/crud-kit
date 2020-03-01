import Vapor

public protocol Patchable {
    associatedtype Patch: Content
    func patch(with data: Patch)
}
