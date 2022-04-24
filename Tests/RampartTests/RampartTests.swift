@testable import Rampart
import XCTest

final class RampartTests: XCTestCase {
  func testCompareEndpoint() {
    XCTAssertEqual(ComparableEndpoint<Int>.including(5).compare(.including(6)), .orderedAscending)
    XCTAssertEqual(ComparableEndpoint<Int>.including(5).compare(.including(5)), .orderedSame)
    XCTAssertEqual(ComparableEndpoint<Int>.including(5).compare(.including(4)), .orderedDescending)

    XCTAssertEqual(ComparableEndpoint<Int>.excluding(5).compare(.excluding(6)), .orderedAscending)
    XCTAssertEqual(ComparableEndpoint<Int>.excluding(5).compare(.excluding(5)), .orderedSame)
    XCTAssertEqual(ComparableEndpoint<Int>.excluding(5).compare(.excluding(4)), .orderedDescending)

    XCTAssertEqual(ComparableEndpoint<Int>.including(5).compare(.excluding(6)), .orderedAscending)
    XCTAssertEqual(ComparableEndpoint<Int>.including(5).compare(.excluding(5)), .orderedDescending)

    XCTAssertEqual(ComparableEndpoint<Int>.excluding(5).compare(.including(5)), .orderedAscending)
    XCTAssertEqual(ComparableEndpoint<Int>.excluding(5).compare(.including(4)), .orderedDescending)

    XCTAssertEqual(ComparableEndpoint<Int>.infinity.compare(.infinity), .orderedSame)
    XCTAssertEqual(ComparableEndpoint<Int>.infinity.compare(.including(5)), .orderedDescending)
    XCTAssertEqual(ComparableEndpoint<Int>.including(5).compare(.infinity), .orderedAscending)

    XCTAssertEqual(ComparableEndpoint<Int>.negInfinity.compare(.negInfinity), .orderedSame)
    XCTAssertEqual(ComparableEndpoint<Int>.negInfinity.compare(.including(5)), .orderedAscending)
    XCTAssertEqual(ComparableEndpoint<Int>.including(5).compare(.negInfinity), .orderedDescending)

    XCTAssertEqual(ComparableEndpoint<Int>.infinity.compare(.negInfinity), .orderedDescending)
    XCTAssertEqual(ComparableEndpoint<Int>.negInfinity.compare(.infinity), .orderedAscending)
  }

  func testDetermineRelation() {
    XCTAssertEqual((1 ... 2).relate(to: 3 ... 7), .before)
    XCTAssertEqual((2 ... 3).relate(to: 3 ... 7), .meets)
    XCTAssertEqual((2 ... 4).relate(to: 3 ... 7), .overlaps)
    XCTAssertEqual((2 ... 7).relate(to: 3 ... 7), .finishedBy)
    XCTAssertEqual((2 ... 8).relate(to: 3 ... 7), .contains)
    XCTAssertEqual((3 ... 4).relate(to: 3 ... 7), .starts)
    XCTAssertEqual((3 ... 7).relate(to: 3 ... 7), .equal)
    XCTAssertEqual((3 ... 8).relate(to: 3 ... 7), .startedBy)
    XCTAssertEqual((4 ... 6).relate(to: 3 ... 7), .during)
    XCTAssertEqual((6 ... 7).relate(to: 3 ... 7), .finishes)
    XCTAssertEqual((6 ... 8).relate(to: 3 ... 7), .overlappedBy)
    XCTAssertEqual((7 ... 8).relate(to: 3 ... 7), .metBy)
    XCTAssertEqual((8 ... 9).relate(to: 3 ... 7), .after)
  }

  func testInvertedRelation() {
    XCTAssertEqual(Relation.before.inverted, .after)
    XCTAssertEqual(Relation.meets.inverted, .metBy)
    XCTAssertEqual(Relation.overlaps.inverted, .overlappedBy)
    XCTAssertEqual(Relation.finishedBy.inverted, .finishes)
    XCTAssertEqual(Relation.contains.inverted, .during)
    XCTAssertEqual(Relation.starts.inverted, .startedBy)
    XCTAssertEqual(Relation.equal.inverted, .equal)
    XCTAssertEqual(Relation.startedBy.inverted, .starts)
    XCTAssertEqual(Relation.during.inverted, .contains)
    XCTAssertEqual(Relation.finishes.inverted, .finishedBy)
    XCTAssertEqual(Relation.overlappedBy.inverted, .overlaps)
    XCTAssertEqual(Relation.metBy.inverted, .meets)
    XCTAssertEqual(Relation.after.inverted, .before)
  }
}
