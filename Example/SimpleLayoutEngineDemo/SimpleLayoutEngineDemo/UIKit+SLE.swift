//
// Created by Sidharth Juyal on 11/11/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

import UIKit

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
