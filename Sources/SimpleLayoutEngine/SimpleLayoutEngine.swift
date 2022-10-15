import CoreGraphics

public enum SLEDirection {
  case row
  case column
}

public enum SLEAlignment {
  case leading
  case center
  case trailing
}

private extension SLEAlignment {
  func align(parent: CGFloat, item: CGFloat) -> CGFloat {
    switch self {
    case .leading: return 0
    case .trailing: return (parent - item)
    case .center: return (parent - item) / 2.0
    }
  }
}

public enum SLELayoutError: Error {
  case itemOutOfBounds
  case itemIncomplete
  case outOfSpace
}

private extension CGPoint {
  func appendingX(_ value: CGFloat) -> CGPoint {
    return CGPoint(x: x + value, y: y)
  }

  func appendingY(_ value: CGFloat) -> CGPoint {
    return CGPoint(x: x, y: y + value)
  }
}

private class SLERect {
  internal private(set) var width: CGFloat?
  internal private(set) var height: CGFloat?
  private var x: CGFloat?
  private var y: CGFloat?

  func frame() throws -> CGRect {
    guard let originX = x, let originY = y, let width = width, let height = height else {
      throw SLELayoutError.itemIncomplete
    }
    return CGRect(x: originX, y: originY, width: width, height: height)
  }

  func set(origin: CGPoint) {
    x = origin.x
    y = origin.y

    assert(x != nil)
    assert(y != nil)
  }

  func set(size: CGSize) {
    width = size.width
    height = size.height

    assert(width != nil)
    assert(height != nil)
  }
}

public class SLEItem {
  public static var flexible: SLEItem {
    return SLEItem(width: nil, height: nil)
  }

  public static func width(_ value: CGFloat) -> SLEItem {
    return SLEItem(width: value, height: nil)
  }

  public static func height(_ value: CGFloat) -> SLEItem {
    return SLEItem(width: nil, height: value)
  }

  public static func dynamic(_ direction: SLEDirection, _ value: CGFloat) -> SLEItem {
    switch direction {
    case .column: return .height(value)
    case .row: return .width(value)
    }
  }

  public static func size(_ value: CGSize) -> SLEItem {
    return SLEItem(width: value.width, height: value.height)
  }

  public func frame() throws -> CGRect {
    return try rect.frame()
  }

  internal let originalWidth: CGFloat?
  internal let originalHeight: CGFloat?
  private let rect = SLERect()

  private init(width: CGFloat?, height: CGFloat?) {
    originalWidth = width
    originalHeight = height
  }
}

private extension SLEItem {
  func value(in direction: SLEDirection) -> CGFloat? {
    switch direction {
    case .row: return originalWidth
    case .column: return originalHeight
    }
  }

  func updateSize(value: CGFloat, in direction: SLEDirection, parentSize: CGSize) {
    switch direction {
    case .row:
      rect.set(size: CGSize(width: originalWidth ?? value, height: originalHeight ?? parentSize.height))

    case .column:
      rect.set(size: CGSize(width: originalWidth ?? parentSize.width, height: originalHeight ?? value))
    }
  }

  func updateOrigin(itemOrigin: CGPoint, in direction: SLEDirection, alignment: SLEAlignment, parentFrame: CGRect) -> CGPoint {
    switch direction {
    case .row:
      rect.set(origin: CGPoint(x: itemOrigin.x, y: parentFrame.origin.y + alignment.align(parent: parentFrame.height, item: rect.height ?? 0)))
      return itemOrigin.appendingX(rect.width ?? 0)
    case .column:
      rect.set(origin: CGPoint(x: parentFrame.origin.x + alignment.align(parent: parentFrame.width, item: rect.width ?? 0), y: itemOrigin.y))
      return itemOrigin.appendingY(rect.height ?? 0)
    }
  }
}

public class SLELayout {

  private let parentFrame: CGRect
  private let direction: SLEDirection
  private let alignment: SLEAlignment
  private var items: [SLEItem] = []

  public init(parentFrame: CGRect, direction: SLEDirection, alignment: SLEAlignment) {
    self.parentFrame = parentFrame
    self.direction = direction
    self.alignment = alignment
  }

  var totalItems: Int {
    return items.count
  }

  @discardableResult
  public func add(items: [SLEItem]) throws -> [SLEItem] {
    self.items.append(contentsOf: items)
    try updateFrames()
    return items
  }

  @discardableResult
  public func add(item: SLEItem) throws -> SLEItem {
    items.append(item)
    try updateFrames()
    return item
  }

  public func frame(at index: Int) throws -> CGRect {
    guard index < totalItems else {
      throw SLELayoutError.itemOutOfBounds
    }
    return try items[index].frame()
  }
}

private extension SLELayout {
  func updateFrames() throws {
    var totalFlexSpace: CGFloat = {
      switch direction {
      case .row: return parentFrame.width
      case .column: return parentFrame.height
      }
    }()

    var flexItems = 0
    for item in items {
      switch item.value(in: direction) {
      case .some(let space): totalFlexSpace -= space
      case .none: flexItems += 1
      }
    }

    let itemSpace = totalFlexSpace/CGFloat(max(flexItems, 1))
    guard itemSpace >= 0 else {
      throw SLELayoutError.outOfSpace
    }

    var itemOrigin = parentFrame.origin
    for item in items {
      item.updateSize(value: itemSpace, in: direction, parentSize: parentFrame.size)
      itemOrigin = item.updateOrigin(itemOrigin: itemOrigin, in: direction, alignment: alignment, parentFrame: parentFrame)
    }
  }
}
