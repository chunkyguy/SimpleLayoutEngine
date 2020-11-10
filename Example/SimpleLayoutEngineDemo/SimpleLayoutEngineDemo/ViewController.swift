//
// Created by Sidharth Juyal on 10/11/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

import UIKit

extension UIColor {
  static var random: UIColor {
    return UIColor(hue: .random(in: 0...1), saturation: 0.8, brightness: 0.8, alpha: 1)
  }
}

extension CGSize {
  init(value: CGFloat) {
    self.init(width: value, height: value)
  }
}

class PreviewView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .random
  }

  required init?(coder: NSCoder) { fatalError("not implemented") }
}

class ThumbnailView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .random
  }

  required init?(coder: NSCoder) { fatalError("not implemented") }
}

class FooterView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .random

    let layout = Layout(parentFrame: bounds, direction: .row, alignment: .trailing)
    let thumbWidth = (bounds.width / 2.0) - 4
    try! layout.add(item: .flexible)
    let leftThumbItem = try! layout.add(item: .size(CGSize(value: thumbWidth)))
    try! layout.add(item: .flexible)
    let rightThumbItem = try! layout.add(item: .size(CGSize(value: thumbWidth)))
    try! layout.add(item: .flexible)

    addSubview(ThumbnailView(frame: leftThumbItem.frame!))
    addSubview(ThumbnailView(frame: rightThumbItem.frame!))
  }

  required init?(coder: NSCoder) { fatalError("not implemented") }
}

class Toolbar: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    let toolbar = UIToolbar(frame: bounds)
    addSubview(toolbar)
    toolbar.items = [
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      UIBarButtonItem(barButtonSystemItem: .rewind, target: nil, action: nil),
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      UIBarButtonItem(barButtonSystemItem: .play, target: nil, action: nil),
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      UIBarButtonItem(barButtonSystemItem: .pause, target: nil, action: nil),
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      UIBarButtonItem(barButtonSystemItem: .fastForward, target: nil, action: nil),
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
    ]
  }

  required init?(coder: NSCoder) { fatalError("not implemented") }
}

class ContentView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .lightGray

    let layout = Layout(parentFrame: bounds, direction: .column, alignment: .leading)
    let previewItem = try! layout.add(item: .size(CGSize(value: bounds.width))) // add square
    let toolbarItem = try! layout.add(item: .height(44))
    let footerItem = try! layout.add(item: .flexible)

    addSubview(PreviewView(frame: previewItem.frame!))
    addSubview(Toolbar(frame: toolbarItem.frame!))
    addSubview(FooterView(frame: footerItem.frame!))
  }

  required init?(coder: NSCoder) { fatalError("not implemented") }
}

class ViewController: UIViewController {

  private var isSetup = false

  override func viewDidLayoutSubviews() {
    // the view.safeAreaInsets is not at viewDidLoad
    if !isSetup {
      setup()
      isSetup = true
    }
  }

  func setup() {
    let layout = Layout(parentFrame: view.bounds, direction: .column, alignment: .leading)
    try! layout.add(item: .height(view.safeAreaInsets.top))
    let contentItem = try! layout.add(item: .flexible)
    try! layout.add(item: .height(view.safeAreaInsets.bottom))

    let contentView = ContentView(frame: contentItem.frame!)
    view.addSubview(contentView)
    view.backgroundColor = .white
  }
}

