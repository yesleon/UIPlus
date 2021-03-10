import XCTest
@testable import UIPlus

final class UIPlusTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(UIPlus().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
