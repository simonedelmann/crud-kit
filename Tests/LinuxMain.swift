import XCTest

import CrudAPITests

var tests = [XCTestCaseEntry]()
tests += CrudAPIRoutingTests.allTests()
XCTMain(tests)
