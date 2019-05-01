import Foundation

/// A protocol used for adding and removing storage observations
public protocol StorageObservationRegistry {
    associatedtype S: StorageAware

    /**
     Registers observation closure which will be removed automatically
     when the weakly captured observer has been deallocated.
     - Parameter observer: Any object that helps determine if the observation is still valid
     - Parameter closure: Observation closure
     - Returns: Token used to cancel the observation and remove the observation closure
     */
    @discardableResult
    func addStorageObserver<O: AnyObject>(
        _ observer: O,
        closure: @escaping (O, S, StorageChange) -> Void
    ) -> ObservationToken

    /// Removes all registered key observers
    func removeAllStorageObservers()
}

// MARK: - StorageChange

public enum StorageChange: Equatable {
    case add(key: String)
    case remove(key: String)
    case removeAll
    case removeExpired
}

public func == (lhs: StorageChange, rhs: StorageChange) -> Bool {
    switch (lhs, rhs) {
    case let (.add(key1), .add(key2)), let (.remove(key1), .remove(key2)):
        return key1 == key2
    case (.removeAll, .removeAll), (.removeExpired, .removeExpired):
        return true
    default:
        return false
    }
}
