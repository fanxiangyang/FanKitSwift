import XCTest
@testable import FanKitSwift

final class FanKitSwiftTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        print(FanKitSwift().text)
        print("wemfdskfjdslfk")
        
        let hexColor = FanHexColor("f33245")
        print("hex颜色:\(hexColor)")
        
        XCTAssertEqual(FanKitSwift().text, "Hello, World!")
    }
    func testTool() throws {
        
    }
}
