import Foundation

/// Used for callback in async operations.
public enum Result<T> {
    case value(T)
    case error(Error)

    public func map<U>(_ transform: (T) -> U) -> Result<U> {
        switch self {
        case let .value(value):
            return Result<U>.value(transform(value))
        case let .error(error):
            return Result<U>.error(error)
        }
    }
}
