//
// Created by Sidharth Juyal on 11/11/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

import Foundation
import UIKit

private class ContentView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor(hue: 0.3)
  }

  required init?(coder: NSCoder) { fatalError("not implemented") }
}

class DetailViewController: BaseViewController {

  private var contentView: UIView?

  override func addViews(frame: CGRect) {
    contentView = view.add(subview: ContentView(frame: frame))
  }

  override func updateViews(frame: CGRect) {
    contentView?.frame = frame
  }
}
