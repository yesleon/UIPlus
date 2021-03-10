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
//        XCTAssertEqual(UIPlus().text, "Hello, World!")
        
        let button = UIButton()
        button.addAction(for: .allEditingEvents) { (button) in
            
        }
        
        let vc = UIViewController()
        vc.alertPublisher(
            title: "a", message: "m", preferredStyle: .alert,
            textFieldHandlers: [
                { $0.placeholder = "asdf" }
            ],
            actions: [
                .init(title: "asdf", style: .default, handler: { alert in
                    
                })
            ])
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
