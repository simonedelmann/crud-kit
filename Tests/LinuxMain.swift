import XCTest

import CrudAPITests

var tests = [XCTestCaseEntry]()
tests += RoutingTests.allTests()
tests += IndexAllTests.allTests()
XCTMain(tests)
