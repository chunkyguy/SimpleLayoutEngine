//
// Created by Sidharth Juyal on 11/11/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

import UIKit

extension UIView {
  func addOrUpdateSubview<T: UIView>(type: T.Type, frame: CGRect) {
    if let subview = subviews.first (where: { $0 is T }) {
      subview.frame = frame
    } else {
      addSubview(T(frame: frame))
    }
  }

  func addOrUpdateSubview<T: UIView>(type: T.Type, frame: CGRect, tag: Int) {
    if let subview = viewWithTag(tag) {
      subview.frame = frame
    } else {
      add(subview: T(frame: frame)).tag = tag
    }
  }

  func add(subview: UIView) -> UIView {
    addSubview(subview)
    return subview
  }
}

extension UIColor {
  convenience init(hue: CGFloat) {
    self.init(hue: hue, saturation: 0.8, brightness: 0.8, alpha: 1)
  }
}
