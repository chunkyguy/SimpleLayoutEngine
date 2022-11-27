//
// Created by Sidharth Juyal on 11/11/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

import UIKit
import SimpleLayoutEngine

extension UIView {
  @discardableResult func add<T: UIView>(subview: T) -> T {
    addSubview(subview)
    return subview
  }
}

extension UIColor {
  convenience init(hue: CGFloat) {
    self.init(hue: hue, saturation: 0.8, brightness: 0.8, alpha: 1)
  }
}

extension CGSize {
  init(value: CGFloat) {
    self.init(width: value, height: value)
  }

  var minEdge: CGFloat {
    return min(width, height)
  }

  var direction: Direction {
    if width > height {
      return .row
    } else {
      return .column
    }
  }
}
