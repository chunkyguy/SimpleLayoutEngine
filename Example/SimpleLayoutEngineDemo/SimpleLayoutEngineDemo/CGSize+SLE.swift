//
// Created by Sidharth Juyal on 11/11/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

import CoreGraphics

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
