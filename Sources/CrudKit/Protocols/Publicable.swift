import Vapor

public protocol Publicable {
    associatedtype Public: Content
    func `public`() -> Public
}

extension EventLoopFuture where Value: Publicable {
    public func `public`() -> EventLoopFuture<Value.Public> {
        self.map {
            $0.public()
        }
    }
}

extension EventLoopFuture where Value: Sequence, Value.Element: Publicable {
    public func `public`() -> EventLoopFuture<[Value.Element.Public]> {
        self.mapEach {
            $0.public()
        }
    }
}
