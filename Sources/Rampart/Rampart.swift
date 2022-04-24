import Foundation

public enum Relation: Equatable {
  case before
  case meets
  case overlaps
  case finishedBy
  case contains
  case starts
  case equal
  case startedBy
  case during
  case finishes
  case overlappedBy
  case metBy
  case after

  public var inverted: Relation {
    switch self {
    case .before: return .after
    case .meets: return .metBy
    case .overlaps: return .overlappedBy
    case .finishedBy: return .finishes
    case .contains: return .during
    case .starts: return .startedBy
    case .equal: return .equal
    case .startedBy: return .starts
    case .during: return .contains
    case .finishes: return .finishedBy
    case .overlappedBy: return .overlaps
    case .metBy: return .meets
    case .after: return .before
    }
  }
}

public enum Endpoint<Element>: Equatable where Element: Equatable {
  case including(Element)
  case excluding(Element)
  case infinite
}

enum ComparableEndpoint<Element> where Element: Comparable {
  case including(Element)
  case excluding(Element)
  case infinity
  case negInfinity

  func compare(_ other: ComparableEndpoint<Element>) -> ComparisonResult {
    switch (self, other) {
    case let (.including(x), .including(y)) where x == y: return .orderedSame
    case let (.including(x), .including(y)) where x < y: return .orderedAscending
    case (.including, .including): return .orderedDescending

    case let (.excluding(x), .excluding(y)) where x == y: return .orderedSame
    case let (.excluding(x), .excluding(y)) where x < y: return .orderedAscending
    case (.excluding, .excluding): return .orderedDescending

    case let (.including(x), .excluding(y)) where x < y: return .orderedAscending
    case (.including, .excluding): return .orderedDescending

    case let (.excluding(x), .including(y)) where x <= y: return .orderedAscending
    case (.excluding, .including): return .orderedDescending

    case (.infinity, .infinity): return .orderedSame
    case (.infinity, _): return .orderedDescending
    case (_, .infinity): return .orderedAscending

    case (.negInfinity, .negInfinity): return .orderedSame
    case (.negInfinity, _): return .orderedAscending
    case (_, .negInfinity): return .orderedDescending
    }
  }
}

public protocol Interval {
  associatedtype Element: Comparable

  var lowerEndpoint: Endpoint<Element> { get }
  var upperEndpoint: Endpoint<Element> { get }

  func relate<I>(to other: I) -> Relation where I: Interval, I.Element == Element
}

extension Interval {
  var lowerComparableEndpoint: ComparableEndpoint<Element> {
    switch lowerEndpoint {
    case let .including(x): return .including(x)
    case let .excluding(x): return .excluding(x)
    case .infinite: return .negInfinity
    }
  }

  var upperComparableEndpoint: ComparableEndpoint<Element> {
    switch upperEndpoint {
    case let .including(x): return .including(x)
    case let .excluding(x): return .excluding(x)
    case .infinite: return .infinity
    }
  }
}

public extension Interval {
  func relate<I>(to other: I) -> Relation where I: Interval, I.Element == Element {
    switch (
      lowerComparableEndpoint.compare(other.lowerComparableEndpoint),
      lowerComparableEndpoint.compare(other.upperComparableEndpoint),
      upperComparableEndpoint.compare(other.lowerComparableEndpoint),
      upperComparableEndpoint.compare(other.upperComparableEndpoint)
    ) {
    case (.orderedSame, _, _, .orderedSame): return .equal
    case (_, _, .orderedAscending, _): return .before
    case (.orderedAscending, _, .orderedSame, .orderedAscending): return .meets
    case (_, _, .orderedSame, _): return .overlaps
    case (.orderedDescending, .orderedSame, _, .orderedDescending): return .metBy
    case (_, .orderedSame, _, _): return .overlappedBy
    case (_, .orderedDescending, _, _): return .after
    case (.orderedAscending, _, _, .orderedAscending): return .overlaps
    case (.orderedAscending, _, _, .orderedSame): return .finishedBy
    case (.orderedAscending, _, _, .orderedDescending): return .contains
    case (.orderedSame, _, _, .orderedAscending): return .starts
    case (.orderedSame, _, _, .orderedDescending): return .startedBy
    case (.orderedDescending, _, _, .orderedAscending): return .during
    case (.orderedDescending, _, _, .orderedSame): return .finishes
    case (.orderedDescending, _, _, .orderedDescending): return .overlappedBy
    }
  }
}

extension Range: Interval {
  public var lowerEndpoint: Endpoint<Bound> { .including(lowerBound) }
  public var upperEndpoint: Endpoint<Bound> { .excluding(upperBound) }
}

extension ClosedRange: Interval {
  public var lowerEndpoint: Endpoint<Bound> { .including(lowerBound) }
  public var upperEndpoint: Endpoint<Bound> { .including(upperBound) }
}

extension PartialRangeFrom: Interval {
  public var lowerEndpoint: Endpoint<Bound> { .including(lowerBound) }
  public var upperEndpoint: Endpoint<Bound> { .infinite }
}

extension PartialRangeUpTo: Interval {
  public var lowerEndpoint: Endpoint<Bound> { .infinite }
  public var upperEndpoint: Endpoint<Bound> { .excluding(upperBound) }
}

extension PartialRangeThrough: Interval {
  public var lowerEndpoint: Endpoint<Bound> { .infinite }
  public var upperEndpoint: Endpoint<Bound> { .including(upperBound) }
}
