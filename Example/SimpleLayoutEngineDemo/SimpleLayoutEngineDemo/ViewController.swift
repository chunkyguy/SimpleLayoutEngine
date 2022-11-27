//
// Created by Sidharth Juyal on 10/11/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

import UIKit
import SimpleLayoutEngine

private class FooterView: UIView {

  private var leftThumbView: UIView?
  private var rightThumbView: UIView?
  private let action: TapAction

  init(frame: CGRect, action: @escaping TapAction) {
    self.action = action
    super.init(frame: frame)
    backgroundColor = .white
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
      try layout.add(item: Item.flexible)
      let leftThumbItem = try layout.add(item: Item.size(CGSize(value: thumbWidth)))
      try layout.add(item: Item.flexible)
      let rightThumbItem = try layout.add(item: Item.size(CGSize(value: thumbWidth)))
      try layout.add(item: Item.flexible)

      if let leftThumbView = self.leftThumbView {
        leftThumbView.frame = try leftThumbItem.frame()
      } else {
        leftThumbView = add(subview: ImageView(frame: try leftThumbItem.frame(), action: action))
      }
      if let rightThumbView = self.rightThumbView {
        rightThumbView.frame = try rightThumbItem.frame()
      } else {
        rightThumbView = add(subview: ImageView(frame: try rightThumbItem.frame(), action: action))
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
    backgroundColor = UIColor(hue: 0.4)
  }

  required init?(coder: NSCoder) { fatalError("not implemented") }
}

private class ContentView: UIView {

  private var previewView: ImageView?
  private var toolbar: Toolbar?
  private var footerView: FooterView?
  private let action: TapAction

  init(frame: CGRect, action: @escaping TapAction) {
    self.action = action
    super.init(frame: frame)
    backgroundColor = .lightGray
  }

  required init?(coder: NSCoder) { fatalError("not implemented") }

  override func layoutSubviews() {
    let direction = bounds.size.direction
    let layout = Layout(parentFrame: bounds, direction: direction, alignment: .leading)
    do {
      let previewItem = try layout.add(item: Item.size(CGSize(value: bounds.size.minEdge))) // add square
      let toolbarItem = try layout.add(item: Item.dynamic(direction, 44))
      let footerItem = try layout.add(item: Item.flexible)

      if previewView == nil {
        previewView = add(subview: ImageView(frame: try previewItem.frame(), action: action))
      } else {
        previewView?.frame = try previewItem.frame()
      }

      if toolbar == nil {
        toolbar = add(subview: Toolbar(frame: try toolbarItem.frame()))
      } else {
        toolbar?.frame = try toolbarItem.frame()
      }

      if footerView == nil {
        footerView = add(subview: FooterView(frame: try footerItem.frame(), action: action))
      } else {
        footerView?.frame = try footerItem.frame()
      }

    } catch let error {
      assertionFailure(error.localizedDescription)
    }
  }
}

class ViewController: SLEViewController {

  private var contentView: ContentView?
  private var animationController: UIViewControllerTransitioningDelegate?

  override func addViews(frame: CGRect) {
    let action: TapAction = { fromView in
      let fr = self.view.convert(fromView.bounds, from: fromView)
      self.showDetails(frame: fr)
    }

    contentView = view.add(subview: ContentView(frame: frame, action: action))
  }

  override func updateViews(frame: CGRect) {
    contentView?.frame = frame
  }

  private func showDetails(frame: CGRect) {
    let detailVwCtrl = DetailViewController()
    animationController = TransitionController(frame: frame)
    detailVwCtrl.transitioningDelegate = animationController
    detailVwCtrl.modalPresentationStyle = .fullScreen
    present(detailVwCtrl, animated: true, completion: nil)
  }
}
