import XCTest
@testable import UIPlus
import UIKit

@available(iOS 13.0, *)
final class UIPlusTests: XCTestCase {
    @available(iOS 13.0, *)
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(UIPlus().text, "Hello, World!")
        
        let button = UIButton()
        button.addAction(for: .allEditingEvents) { (button) in
            
        }
        
//        button.addAction(for: .touchUpInside) { button in
//            let a = button as! UIButton
//            print(a)
//        }
//        button.sendActions(for: .touchUpInside)
//        button.publisher(for: .allEditingEvents)
//            .sink { control in
//                control
//            }
        
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
