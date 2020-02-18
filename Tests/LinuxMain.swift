import XCTest

import CrudAPITests

var tests = [XCTestCaseEntry]()
tests += RoutingTests.allTests()
XCTMain(tests)
