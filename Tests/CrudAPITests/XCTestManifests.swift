import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(RoutingTests.allTests),
        testCase(IndexAllTests.allTests),
        testCase(IndexTests.allTests),
    ]
}
#endif
