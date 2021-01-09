import Vapor
import Fluent

public protocol Publicable: Content {
    associatedtype Public: Content = Self
    var `public`: Public { get }
    func `public`(eventLoop: EventLoop, db: Database) -> EventLoopFuture<Public>
}

extension Publicable {
    public func `public`(eventLoop: EventLoop, db: Database) -> EventLoopFuture<Public> {
        eventLoop.makeSucceededFuture(self.public)
    }
}

extension Publicable where Public == Self {
    public var `public`: Public {
        return self
    }
}

extension EventLoopFuture where Value: Publicable {
    public func `public`(db: Database) -> EventLoopFuture<Value.Public> {
        self.flatMap {
            $0.public(eventLoop: self.eventLoop, db: db)
        }
    }
}

extension EventLoopFuture where Value: Sequence, Value.Element: Publicable {
    public func `public`(db: Database) -> EventLoopFuture<[Value.Element.Public]> {
        self.flatMapEach(on: self.eventLoop) {
            $0.public(eventLoop: self.eventLoop, db: db)
        }
    }
}
