@testable import Cache
import XCTest

final class MemoryStorageTests: XCTestCase {
    private let key = "youknownothing"
    private let testObject = User(firstName: "John", lastName: "Snow")
    private var storage: MemoryStorage<User>!
    private let config = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)

    override func setUp() {
        super.setUp()
        storage = MemoryStorage<User>(config: config)
    }

    override func tearDown() {
        storage.removeAll()
        super.tearDown()
    }

    /// Test that it saves an object
    func testSetObject() {
        storage.setObject(testObject, forKey: key)
        let cachedObject = try! storage.object(forKey: key)
        XCTAssertNotNil(cachedObject)
        XCTAssertEqual(cachedObject.firstName, testObject.firstName)
        XCTAssertEqual(cachedObject.lastName, testObject.lastName)
    }

    func testCacheEntry() {
        // Returns nil if entry doesn't exist
        var entry = try? storage.entry(forKey: key)
        XCTAssertNil(entry)

        // Returns entry if object exists
        storage.setObject(testObject, forKey: key)
        entry = try! storage.entry(forKey: key)

        XCTAssertEqual(entry?.object.firstName, testObject.firstName)
        XCTAssertEqual(entry?.object.lastName, testObject.lastName)
        XCTAssertEqual(entry?.expiry.date, config.expiry.date)
    }

    func testSetObjectWithExpiry() {
        let date = Date().addingTimeInterval(1)
        storage.setObject(testObject, forKey: key, expiry: .seconds(1))
        var entry = try! storage.entry(forKey: key)
        XCTAssertEqual(entry.expiry.date.timeIntervalSinceReferenceDate,
                       date.timeIntervalSinceReferenceDate,
                       accuracy: 0.1)
        // Timer vs sleep: do not complicate
        sleep(1)
        entry = try! storage.entry(forKey: key)
        XCTAssertEqual(entry.expiry.date.timeIntervalSinceReferenceDate,
                       date.timeIntervalSinceReferenceDate,
                       accuracy: 0.1)
    }

    /// Test that it removes cached object
    func testRemoveObject() {
        storage.setObject(testObject, forKey: key)
        storage.removeObject(forKey: key)
        let cachedObject = try? storage.object(forKey: key)
        XCTAssertNil(cachedObject)
    }

    /// Test that it removes expired object
    func testRemoveObjectIfExpiredWhenExpired() {
        let expiry: Expiry = .date(Date().addingTimeInterval(-10))
        storage.setObject(testObject, forKey: key, expiry: expiry)
        storage.removeObjectIfExpired(forKey: key)
        let cachedObject = try? storage.object(forKey: key)

        XCTAssertNil(cachedObject)
    }

    /// Test that it doesn't remove not expired object
    func testRemoveObjectIfExpiredWhenNotExpired() {
        storage.setObject(testObject, forKey: key)
        storage.removeObjectIfExpired(forKey: key)
        let cachedObject = try! storage.object(forKey: key)

        XCTAssertNotNil(cachedObject)
    }

    /// Test expired object
    func testExpiredObject() throws {
        storage.setObject(testObject, forKey: key, expiry: .seconds(0.9))
        XCTAssertFalse(try! storage.isExpiredObject(forKey: key))
        sleep(1)
        XCTAssertTrue(try! storage.isExpiredObject(forKey: key))
    }

    /// Test that it clears cache directory
    func testRemoveAll() {
        storage.setObject(testObject, forKey: key)
        storage.removeAll()
        let cachedObject = try? storage.object(forKey: key)
        XCTAssertNil(cachedObject)
    }

    /// Test that it removes expired objects
    func testClearExpired() {
        let expiry1: Expiry = .date(Date().addingTimeInterval(-10))
        let expiry2: Expiry = .date(Date().addingTimeInterval(10))
        let key1 = "item1"
        let key2 = "item2"
        storage.setObject(testObject, forKey: key1, expiry: expiry1)
        storage.setObject(testObject, forKey: key2, expiry: expiry2)
        storage.removeExpiredObjects()
        let object1 = try? storage.object(forKey: key1)
        let object2 = try! storage.object(forKey: key2)

        XCTAssertNil(object1)
        XCTAssertNotNil(object2)
    }
}
