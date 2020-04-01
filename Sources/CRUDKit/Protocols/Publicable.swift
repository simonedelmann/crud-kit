import Vapor

public protocol Publicable: Content {
    associatedtype Public: Content = Self
    var `public`: Public { get }
}

extension Publicable where Public == Self {
    public var `public`: Public {
        return self
    }
}

extension EventLoopFuture where Value: Publicable {
    public func `public`() -> EventLoopFuture<Value.Public> {
        self.map {
            $0.public
        }
    }
}

extension EventLoopFuture where Value: Sequence, Value.Element: Publicable {
    public func `public`() -> EventLoopFuture<[Value.Element.Public]> {
        self.mapEach {
            $0.public
        }
    }
}
