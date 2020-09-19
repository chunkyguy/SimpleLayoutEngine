//
// Created by Sidharth Juyal on 15/09/2020.
// Copyright © 2020 SLE. All rights reserved.
//

#import "ViewController.h"
#import "SLELayout.h"

@interface ViewController () {
  BOOL _isSetUp;
}
@end

@implementation ViewController

- (void)awakeFromNib
{
  [super awakeFromNib];
  _isSetUp = NO;
}

- (void)viewDidLayoutSubviews
{
  if (_isSetUp) {
    return;
  }
  _isSetUp = YES;
  [self setUp];
}

- (UIColor *)randomColor
{
  CGFloat hue = ((CGFloat)arc4random() / UINT32_MAX);
  return [UIColor colorWithHue:hue saturation:.7f brightness:.8f alpha:1.f];
}

- (void)setUp
{
  self.view.backgroundColor = [UIColor whiteColor];

  UIEdgeInsets insets = self.view.safeAreaInsets;
  SLELayout *mainLayout = [SLELayout layoutWithParentBounds:self.view.bounds
                                                  direction:SLELayoutDirectionColumn
                                                  alignment:SLELayoutAlignmentLeading];

  SLELayoutItem *previewLayout = [SLELayoutItem itemWithHeight:self.view.bounds.size.width];
  SLELayoutItem *toolbarLayout = [SLELayoutItem itemWithHeight:44];
  SLELayoutItem *imageContentLayout = [SLELayoutItem itemWithHeight:200.f];

  [mainLayout addItem:[SLELayoutItem itemWithHeight:insets.top]];
  [mainLayout addItem:[SLELayoutItem flexItem]];
  [mainLayout addItem:previewLayout];
  [mainLayout addItem:[SLELayoutItem flexItem]];
  [mainLayout addItem:toolbarLayout];
  [mainLayout addItem:imageContentLayout];
  [mainLayout addItem:[SLELayoutItem itemWithHeight:insets.bottom]];

  CGRect imageContentFrame = [imageContentLayout frame];
  SLELayout *imageLayout = [SLELayout layoutWithParentBounds:imageContentFrame
                                                   direction:SLELayoutDirectionRow
                                                   alignment:SLELayoutAlignmentLeading];
  CGFloat contentImgWidth = (imageContentFrame.size.width / 2.0) - 2.f;
  SLELayoutItem *startImageVwLayout = [SLELayoutItem itemWithWidth:contentImgWidth];
  SLELayoutItem *endImageVwLayout = [SLELayoutItem itemWithWidth:contentImgWidth];
  [imageLayout addItem:[SLELayoutItem flexItem]];
  [imageLayout addItem:startImageVwLayout];
  [imageLayout addItem:[SLELayoutItem flexItem]];
  [imageLayout addItem:endImageVwLayout];
  [imageLayout addItem:[SLELayoutItem flexItem]];

  UIView *previewVw = [[UIView alloc] initWithFrame:[previewLayout frame]];
  UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:[toolbarLayout frame]];
  UIView *imageContentView = [[UIView alloc] initWithFrame:imageContentFrame];
  UIImageView *startImageVw = [[UIImageView alloc] initWithFrame:[startImageVwLayout frame]];
  UIButton *startImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  startImageBtn.frame = startImageVw.frame;
  UIImageView *endImageVw = [[UIImageView alloc] initWithFrame:[endImageVwLayout frame]];
  UIButton *endImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  endImageBtn.frame = endImageVw.frame;

  UIBarButtonItem *playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                              target:self
                                                                              action:nil];
  UIBarButtonItem *pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause
                                                                               target:self
                                                                               action:nil];
  UIBarButtonItem *rewindButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind
                                                                                target:self
                                                                                action:nil];
  UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
                                                                                 target:self
                                                                                 action:nil];
  UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:self
                                                                               action:nil];

  [self.view addSubview:previewVw];
  [self.view addSubview:toolbar];
  [self.view addSubview:imageContentView];
  [toolbar setItems:[NSArray arrayWithObjects:
                               spaceButton, rewindButton,
                             spaceButton, playButton,
                             spaceButton, pauseButton,
                             spaceButton, forwardButton,
                             spaceButton, nil]];
  [imageContentView addSubview:startImageVw];
  [imageContentView addSubview:endImageVw];
  [imageContentView addSubview:startImageBtn];
  [imageContentView addSubview:endImageBtn];

  [previewVw release];
  [toolbar release];
  [imageContentView release];
  [startImageVw release];
  [endImageVw release];
  [playButton release];
  [pauseButton release];
  [rewindButton release];
  [forwardButton release];
  [spaceButton release];

  self.view.backgroundColor = [UIColor whiteColor];
  previewVw.backgroundColor = [UIColor colorWithHue:.4f saturation:.7f brightness:.8f alpha:1.f];
  startImageVw.backgroundColor = [UIColor colorWithHue:.5f saturation:.7f brightness:.8f alpha:1.f];
  endImageVw.backgroundColor = [UIColor colorWithHue:.6f saturation:.7f brightness:.8f alpha:1.f];
}

@end
