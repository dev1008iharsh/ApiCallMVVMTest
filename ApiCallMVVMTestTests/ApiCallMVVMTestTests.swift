//
//  ApiCallMVVMTestTests.swift
//  ApiCallMVVMTestTests
//
//  Created by Harsh on 09/04/26.
//

@testable import ApiCallMVVMTest
import XCTest

final class ApiCallMVVMTestTests: XCTestCase {
    override func setUpWithError() throws {
        print("🔵 setUp - before each test")
    }

    override func tearDownWithError() throws {
        print("🔴 tearDown - after each test")
    }

    func testAssertions() {
        print("🧪 testAssertions started")

        let a = 5
        let b = 5
        let c: Int? = nil

        XCTAssertEqual(a, b)
        print("✅ XCTAssertEqual passed")

        XCTAssertTrue(a == b)
        print("✅ XCTAssertTrue passed")

        XCTAssertFalse(a == 10)
        print("✅ XCTAssertFalse passed")

        XCTAssertNil(c)
        print("✅ XCTAssertNil passed")

        XCTAssertNotNil(a)
        print("✅ XCTAssertNotNil passed")
    }

    func testAsyncExample() async {
        print("🧪 testAsyncExample started")

        let exp = expectation(description: "Async wait")

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            print("⏳ Async work done")
            exp.fulfill()
        }

        await fulfillment(of: [exp], timeout: 1)
        print("✅ Async test completed")
    }

    func testPerformanceExample() {
        print("🧪 testPerformanceExample started")

        measure {
            for _ in 0 ..< 1000 {
                _ = UUID().uuidString
            }
        }

        print("⚡ Performance measured")
    }
}
