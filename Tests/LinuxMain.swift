import XCTest

import CrudAPITests

var tests = [XCTestCaseEntry]()
tests += RoutingTests.allTests()
tests += IndexAllTests.allTests()
tests += IndexTests.allTests()
tests += CreateTests.allTests()
tests += ReplaceTests.allTests()
XCTMain(tests)
