import Vapor

extension Content {
    internal static func validate(on request: Request) throws {
        if let validatable = Self.self as? Validatable.Type {
            try validatable.validate(content: request)
        }
    }
}
