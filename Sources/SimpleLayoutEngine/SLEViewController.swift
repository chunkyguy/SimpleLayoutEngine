//
// Created by Sidharth Juyal on 10/04/2022.
// Copyright © 2022 whackylabs. All rights reserved.
// 

import Foundation
import UIKit

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

class SLEViewController: UIViewController {

  private var isSetup = false

  private var rootView: UIView? {
    didSet {
      oldValue?.removeFromSuperview()
      if let newValue = rootView {
        view.addSubview(newValue)
      }
    }
  }

  override func viewDidLayoutSubviews() {
    // the view.safeAreaInsets is not available at viewDidLoad
    if !isSetup {
      layout(frame: view.bounds, update: addViews)
      isSetup = true
    }
    updateViews(frame: view.bounds)
  }

  private func layout(frame: CGRect, update: (CGRect) -> Void) {
    let direction = frame.size.direction
    let layout = Layout(parentFrame: frame, direction: direction, alignment: .leading)
    do {
      let leading: CGFloat
      let trailing: CGFloat
      switch direction {
      case .column:
        leading = view.safeAreaInsets.top
        trailing = view.safeAreaInsets.bottom
      case .row:
        leading = view.safeAreaInsets.left
        trailing = view.safeAreaInsets.right
      }

      try layout.add(item: .dynamic(direction, leading))
      let contentItem = try layout.add(item: .flexible)
      try layout.add(item: .dynamic(direction, trailing))
      update(try contentItem.frame())
    } catch let error {
      assertionFailure(error.localizedDescription)
    }
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    layout(frame: CGRect(origin: .zero, size: size), update: updateViews)
  }

  // - Need to be subclassed -
  func addViews(frame: CGRect) {}
  func updateViews(frame: CGRect) {}
}
