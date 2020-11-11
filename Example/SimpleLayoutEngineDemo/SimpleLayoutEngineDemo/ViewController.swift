//
// Created by Sidharth Juyal on 10/11/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

import UIKit

private extension UIView  {
  func addSquareImage() {
    let imageView = UIImageView(image: UIImage(named: "square.png"))
    imageView.frame = bounds
    imageView.contentMode = .scaleAspectFill
    addSubview(imageView)
  }
}

private class PreviewView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSquareImage()
  }

  required init?(coder: NSCoder) { fatalError("not implemented") }
}

private class ThumbnailView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSquareImage()
  }

  required init?(coder: NSCoder) { fatalError("not implemented") }
}

private class FooterView: UIView {

  private var leftThumbView: UIView?
  private var rightThumbView: UIView?

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .black
  }

  override func layoutSubviews() {
    let direction = bounds.size.direction
    let thumbWidth: CGFloat
    switch direction {
    case .row:
      thumbWidth = min(bounds.size.width/2.0 - 4.0, bounds.size.height)
    case .column:
      thumbWidth =  min(bounds.size.height/2.0 - 4.0, bounds.size.width)
    }

    let layout = Layout(parentFrame: bounds, direction: direction, alignment: .trailing)
    do {
      try layout.add(item: .flexible)
      let leftThumbItem = try layout.add(item: .size(CGSize(value: thumbWidth)))
      try layout.add(item: .flexible)
      let rightThumbItem = try layout.add(item: .size(CGSize(value: thumbWidth)))
      try layout.add(item: .flexible)

      if let leftThumbView = self.leftThumbView {
        leftThumbView.frame = try leftThumbItem.frame()
      } else {
        leftThumbView = add(subview: ThumbnailView(frame: try leftThumbItem.frame()))
      }
      if let rightThumbView = self.rightThumbView {
        rightThumbView.frame = try rightThumbItem.frame()
      } else {
        rightThumbView = add(subview: ThumbnailView(frame: try rightThumbItem.frame()))
      }
    } catch let error {
      assertionFailure(error.localizedDescription)
    }
  }

  required init?(coder: NSCoder) { fatalError("not implemented") }
}

private class Toolbar: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor(hue: 0.4, saturation: 0.8, brightness: 0.8, alpha: 1)
  }

  required init?(coder: NSCoder) { fatalError("not implemented") }
}

private class ContentView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .lightGray
  }

  required init?(coder: NSCoder) { fatalError("not implemented") }

  override func layoutSubviews() {
    let direction = bounds.size.direction
    let layout = Layout(parentFrame: bounds, direction: direction, alignment: .leading)
    do {
      let previewItem = try layout.add(item: .size(CGSize(value: bounds.size.minEdge))) // add square
      let toolbarItem = try layout.add(item: .dynamic(direction, 44))
      let footerItem = try layout.add(item: .flexible)
      addOrUpdateSubview(type: PreviewView.self, frame: try previewItem.frame())
      addOrUpdateSubview(type: Toolbar.self, frame: try toolbarItem.frame())
      addOrUpdateSubview(type: FooterView.self, frame: try footerItem.frame())
    } catch let error {
      assertionFailure(error.localizedDescription)
    }
  }
}

class ViewController: BaseViewController {

  private var contentView: UIView?

  override func addViews(frame: CGRect) {
    contentView = view.add(subview: ContentView(frame: frame))
  }

  override func updateViews(frame: CGRect) {
    contentView?.frame = frame
  }
}
