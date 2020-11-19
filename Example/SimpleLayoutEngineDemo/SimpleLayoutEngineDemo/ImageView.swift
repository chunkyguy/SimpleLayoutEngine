//
// Created by Sidharth Juyal on 15/11/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

import Foundation
import UIKit

typealias TapAction = (UIView) -> Void

class ImageView: UIView {
  private let action: TapAction

  init(frame: CGRect, action: @escaping TapAction) {
    self.action = action
    super.init(frame: frame)

    let imageView = UIImageView(image: UIImage(named: "square.png"))
    imageView.frame = bounds
    imageView.contentMode = .scaleAspectFill
    addSubview(imageView)

    let button = UIButton(frame: bounds)
    addSubview(button)
    button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
  }

  @objc private func onTap() {
    action(self)
  }

  required init?(coder: NSCoder) { fatalError("not implemented") }
}

