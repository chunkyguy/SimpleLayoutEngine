import CoreGraphics

public enum Direction {
  case row
  case column
}

public enum Alignment {
  case leading
  case center
  case trailing
}

private extension Alignment {
  func align(parent: CGFloat, item: CGFloat) -> CGFloat {
    switch self {
    case .leading: return 0
    case .trailing: return (parent - item)
    case .center: return (parent - item) / 2.0
    }
  }
}

public enum LayoutError: Error {
  case itemOutOfBounds
  case itemIncomplete
  case outOfSpace
}

public class Item {
  public static var flexible: Item {
    return Item(width: nil, height: nil)
  }

  public static func width(_ value: CGFloat) -> Item {
    return Item(width: value, height: nil)
  }

  public static func height(_ value: CGFloat) -> Item {
    return Item(width: nil, height: value)
  }

  public static func dynamic(_ direction: Direction, _ value: CGFloat) -> Item {
    switch direction {
    case .column: return .height(value)
    case .row: return .width(value)
    }
  }

  public static func size(_ value: CGSize) -> Item {
    return Item(width: value.width, height: value.height)
  }

  public func frame() throws -> CGRect {
    guard let originX = originX, let originY = originY, let width = width, let height = height else {
      throw LayoutError.itemIncomplete
    }
    return CGRect(x: originX, y: originY, width: width, height: height)
  }

  internal let originalWidth: CGFloat?
  internal let originalHeight: CGFloat?
  internal var width: CGFloat?
  internal var height: CGFloat?
  private var originX: CGFloat?
  private var originY: CGFloat?

  private init(width: CGFloat?, height: CGFloat?) {
    self.originalWidth = width
    self.originalHeight = height
  }
}

private extension Item {
  func value(in direction: Direction) -> CGFloat? {
    switch direction {
    case .row: return originalWidth
    case .column: return originalHeight
    }
  }

  func updateSize(itemSpace: CGFloat, in direction: Direction, parentSize: CGSize) {

    defer {
      assert(width != nil)
      assert(height != nil)
    }

    switch direction {
    case .row:
      width = originalWidth ?? itemSpace
      height = originalHeight ?? parentSize.height

    case .column:
      width = originalWidth ?? parentSize.width
      height = originalHeight ?? itemSpace
    }
  }

  func updateOrigin(itemOrigin: CGPoint, in direction: Direction, alignment: Alignment, parentFrame: CGRect) -> CGPoint {

    defer {
      assert(originX != nil)
      assert(originY != nil)
    }

    switch direction {
    case .row:
      originX = itemOrigin.x
      originY = parentFrame.origin.y + alignment.align(parent: parentFrame.height, item: height ?? 0)
      return itemOrigin.appendingX(width ?? 0)
    case .column:
      originX = parentFrame.origin.x + alignment.align(parent: parentFrame.width, item: width ?? 0)
      originY = itemOrigin.y
      return itemOrigin.appendingY(height ?? 0)
    }
  }
}

private extension CGPoint {
  func appendingX(_ value: CGFloat) -> CGPoint {
    return CGPoint(x: x + value, y: y)
  }

  func appendingY(_ value: CGFloat) -> CGPoint {
    return CGPoint(x: x, y: y + value)
  }
}

public class Layout {

  private let parentFrame: CGRect
  private let direction: Direction
  private let alignment: Alignment
  private var items: [Item] = []

  public init(parentFrame: CGRect, direction: Direction, alignment: Alignment) {
    self.parentFrame = parentFrame
    self.direction = direction
    self.alignment = alignment
  }

  var totalItems: Int {
    return items.count
  }

  @discardableResult
  public func add(item: Item) throws -> Item {
    items.append(item)
    try updateFrames()
    return item
  }

  public func frame(at index: Int) throws -> CGRect {
    guard index < totalItems else {
      throw LayoutError.itemOutOfBounds
    }
    return try items[index].frame()
  }
}

private extension Layout {

  var maxFlexSpace: CGFloat {
    switch direction {
    case .row: return parentFrame.width
    case .column: return parentFrame.height
    }
  }

  func updateFrames() throws {
    var usedSpace: CGFloat = 0
    var flexItems = 0
    for item in items {
      switch item.value(in: direction) {
      case .some(let space): usedSpace += space
      case .none: flexItems += 1
      }
    }

    let itemSpace = (maxFlexSpace - usedSpace)/CGFloat(max(flexItems, 1))
    guard itemSpace >= 0 else {
      throw LayoutError.outOfSpace
    }

    var itemOrigin = parentFrame.origin
    for item in items {
      item.updateSize(itemSpace: itemSpace, in: direction, parentSize: parentFrame.size)
      itemOrigin = item.updateOrigin(itemOrigin: itemOrigin, in: direction, alignment: alignment, parentFrame: parentFrame)
    }
  }
}
