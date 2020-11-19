//
// Created by Sidharth Juyal on 15/11/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

import Foundation
import UIKit

class TransitionController: NSObject {
  let frame: CGRect

  init(frame: CGRect) {
    self.frame = frame
    super.init()
  }
}

extension TransitionController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return PresentAnimationController(startFrame: frame)
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return DismissAnimationController(startFrame: frame)
  }
}

class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  private let originalFrame: CGRect

  init(startFrame: CGRect) {
    self.originalFrame = startFrame
    super.init()
  }

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard
      let endVwCtrl = transitionContext.viewController(forKey: .to)
      else {
      return
    }

    let containerVw = transitionContext.containerView

    let finalFrame: CGRect = transitionContext.finalFrame(for: endVwCtrl)

    let safeAreaInset: CGFloat = 44.0
    let insets = UIEdgeInsets(top: safeAreaInset, left: 0, bottom: safeAreaInset, right: 0)
    let detailLayout = DetailViewLayout(frame: finalFrame.inset(by: insets))
    let endFrame = detailLayout.imageFrame
    let startFrame = originalFrame

    let bgVw = UIView(frame: finalFrame)
    bgVw.backgroundColor = .white
    containerVw.add(subview: bgVw)

    let imgVw = UIImageView(image: UIImage(named: "square.png"))
    imgVw.backgroundColor = UIColor(hue: 0.2)
    containerVw.addSubview(imgVw)

    animate(imageView: imgVw, startFrame: startFrame, endFrame: endFrame) { isPresenting in
      imgVw.removeFromSuperview()
      if isPresenting {
        containerVw.addSubview(endVwCtrl.view)
      }
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }

  func animate(imageView: UIImageView, startFrame: CGRect, endFrame: CGRect, completion: @escaping (Bool) -> Void) {}
}

class PresentAnimationController: AnimationController {
  override func animate(imageView: UIImageView, startFrame: CGRect, endFrame: CGRect, completion: @escaping (Bool) -> Void) {
    imageView.frame = startFrame
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
      imageView.frame = endFrame
    }, completion: { _ in
      completion(true)
    })
  }
}

class DismissAnimationController: AnimationController {
  override func animate(imageView: UIImageView, startFrame: CGRect, endFrame: CGRect, completion: @escaping (Bool) -> Void) {
    imageView.frame = endFrame
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
      imageView.frame = startFrame
    }, completion: { _ in
      completion(false)
    })
  }
}
