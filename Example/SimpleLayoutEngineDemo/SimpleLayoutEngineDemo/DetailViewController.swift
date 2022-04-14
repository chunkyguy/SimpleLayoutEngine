//
// Created by Sidharth Juyal on 11/11/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

import Foundation
import UIKit

struct DetailViewLayout {
  private let frame: CGRect
  init(frame: CGRect) {
    self.frame = frame
  }

  var imageFrame: CGRect {
    do {
      let layout = Layout(parentFrame: frame, direction: .column, alignment: .center)
      try layout.add(item: .flexible)
      let imageItem = try layout.add(item: .size(CGSize(value: frame.size.minEdge)))
      try layout.add(item: .flexible)
      return try imageItem.frame()
    } catch let error {
      assertionFailure(error.localizedDescription)
      return .zero
    }
  }
}

private class ContentView: UIView {

  init(frame: CGRect, action: @escaping TapAction) {
    super.init(frame: frame)
    backgroundColor = .white
    let imageFrame = DetailViewLayout(frame: bounds).imageFrame
    add(subview: ImageView(frame: imageFrame, action: action))
  }

  required init?(coder: NSCoder) { fatalError("not implemented") }
}

class DetailViewController: SLEViewController {

  private var contentView: UIView?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
  }

  override func addViews(frame: CGRect) {
    let action: TapAction = { _ in
      self.dismiss(animated: true, completion: nil)
    }
    contentView = view.add(subview: ContentView(frame: frame, action: action))
  }

  override func updateViews(frame: CGRect) {
    contentView?.frame = frame
  }

//  override var preferredStatusBarStyle: UIStatusBarStyle {
//    .lightContent
//  }
}
