//
// Created by Sidharth Juyal on 10/11/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

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

extension UIView  {
  func addSquareImage() {
    let imageView = UIImageView(image: UIImage(named: "square.png"))
    imageView.frame = bounds
    imageView.contentMode = .scaleAspectFill
    addSubview(imageView)
  }
}

class PreviewView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSquareImage()
  }

  required init?(coder: NSCoder) { fatalError("not implemented") }
}

class ThumbnailView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSquareImage()
  }

  required init?(coder: NSCoder) { fatalError("not implemented") }
}

class FooterView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .black

    let direction = bounds.size.direction
    let layout = Layout(parentFrame: bounds, direction: direction, alignment: .trailing)
    do {
      let thumbWidth: CGFloat
      switch direction {
      case .row:
        thumbWidth = min(bounds.size.width/2.0 - 4.0, bounds.size.height)
      case .column:
        thumbWidth =  min(bounds.size.height/2.0 - 4.0, bounds.size.width)
      }
      try layout.add(item: .flexible)
      let leftThumbItem = try layout.add(item: .size(CGSize(value: thumbWidth)))
      try layout.add(item: .flexible)
      let rightThumbItem = try layout.add(item: .size(CGSize(value: thumbWidth)))
      try layout.add(item: .flexible)

      addSubview(ThumbnailView(frame: leftThumbItem.frame!))
      addSubview(ThumbnailView(frame: rightThumbItem.frame!))
    } catch let error {
      assertionFailure(error.localizedDescription)
    }
  }

  required init?(coder: NSCoder) { fatalError("not implemented") }
}

class Toolbar: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor(hue: 0.4, saturation: 0.8, brightness: 0.8, alpha: 1)
  }

  required init?(coder: NSCoder) { fatalError("not implemented") }
}

class ContentView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .lightGray

    let direction = bounds.size.direction
    let layout = Layout(parentFrame: bounds, direction: direction, alignment: .leading)
    do {
      let previewItem = try layout.add(item: .size(CGSize(value: bounds.size.minEdge))) // add square
      let toolbarItem = try layout.add(item: .direction(direction, 44))
      let footerItem = try layout.add(item: .flexible)

      addSubview(PreviewView(frame: previewItem.frame!))
      addSubview(Toolbar(frame: toolbarItem.frame!))
      addSubview(FooterView(frame: footerItem.frame!))
    } catch let error {
      assertionFailure(error.localizedDescription)
    }
  }

  required init?(coder: NSCoder) { fatalError("not implemented") }
}

class ViewController: UIViewController {

  private var isSetup = false

  override func viewDidLayoutSubviews() {
    // the view.safeAreaInsets is not available at viewDidLoad
    if !isSetup {
      setup()
      isSetup = true
    }
  }

  func setup() {
    let layout = Layout(parentFrame: view.bounds, direction: .column, alignment: .leading)
    do {
      try layout.add(item: .height(view.safeAreaInsets.top))
      let contentItem = try layout.add(item: .flexible)
      try layout.add(item: .height(view.safeAreaInsets.bottom))

      let contentView = ContentView(frame: contentItem.frame!)
      view.addSubview(contentView)
    } catch let error {
      assertionFailure(error.localizedDescription)
    }
    view.backgroundColor = .white
  }
}
