//
// Created by Sidharth Juyal on 15/09/2020.
// Copyright © 2020 SLE. All rights reserved.
//

#import "SLELayout.h"
#import <FBSnapshotTestCase/FBSnapshotTestCase.h>
#import <XCTest/XCTest.h>

UIView *SLECreateView(CGRect frame, UIColor *color)
{
  UIView *view = [[UIView alloc] initWithFrame:frame];
  view.backgroundColor = color;
  return [view autorelease];
}

@interface SimpleLayoutEngineTests : FBSnapshotTestCase {
  CGRect _rootFrame;
  UIView *_rootView;
}
@end

@implementation SimpleLayoutEngineTests

- (void)setUp
{
  [super setUp];
  _rootFrame = (CGRect) {
    .origin = { .x = .0f, .y = .0f },
    .size = { .width = 414.f, 896.f }
  };
  _rootView = SLECreateView(_rootFrame, [UIColor greenColor]);
  self.recordMode = NO;
}

- (void)testFullScreenLayout
{
  SLELayout *layout = [SLELayout layoutWithParentBounds:_rootFrame
                                              direction:SLELayoutDirectionColumn];
  SLELayoutItem *mainItem = [SLELayoutItem flexItem];
  [layout addItem:mainItem];

  UIView *redView = SLECreateView(mainItem.frame, [UIColor redColor]);
  [_rootView addSubview:redView];

  FBSnapshotVerifyView(_rootView, nil);
  FBSnapshotVerifyLayer(_rootView.layer, nil);
}

- (void)testBottomFixLayout
{
  SLELayout *layout = [SLELayout layoutWithParentBounds:_rootFrame
                                              direction:SLELayoutDirectionColumn];
  [layout addItem:[SLELayoutItem flexItem]];
  [layout addItem:[SLELayoutItem itemWithHeight:200.f]];

  CGRect topFrame = [layout frameAtIndex:0];
  CGRect bottomFrame = [layout frameAtIndex:1];

  [_rootView addSubview:SLECreateView(topFrame, [UIColor redColor])];
  [_rootView addSubview:SLECreateView(bottomFrame, [UIColor blueColor])];

  FBSnapshotVerifyView(_rootView, nil);
  FBSnapshotVerifyLayer(_rootView.layer, nil);
}

- (void)testInnerViewLayout
{
  CGFloat contentHeight = 200.f;
  SLELayout *mainLayout = [SLELayout layoutWithParentBounds:_rootFrame
                                                  direction:SLELayoutDirectionColumn];
  [mainLayout addItem:[SLELayoutItem flexItem]];
  [mainLayout addItem:[SLELayoutItem itemWithHeight:44]];
  [mainLayout addItem:[SLELayoutItem itemWithHeight:contentHeight]];

  CGRect headerFrame = [mainLayout frameAtIndex:0];
  CGRect toolbarFrame = [mainLayout frameAtIndex:1];
  CGRect contentFrame = [mainLayout frameAtIndex:2];

  SLELayout *contentLayout = [SLELayout layoutWithParentBounds:contentFrame
                                                     direction:SLELayoutDirectionRow];
  [contentLayout addItem:[SLELayoutItem flexItem]];
  [contentLayout addItem:[SLELayoutItem itemWithWidth:contentHeight]];
  [contentLayout addItem:[SLELayoutItem flexItem]];
  [contentLayout addItem:[SLELayoutItem itemWithWidth:contentHeight]];
  [contentLayout addItem:[SLELayoutItem flexItem]];

  CGRect content1Frame = [contentLayout frameAtIndex:1];
  CGRect content2Frame = [contentLayout frameAtIndex:3];

  [_rootView addSubview:SLECreateView(headerFrame, [UIColor redColor])];
  [_rootView addSubview:SLECreateView(toolbarFrame, [UIColor blueColor])];
  UIView *contentView = SLECreateView(contentFrame, [UIColor yellowColor]);
  [_rootView addSubview:contentView];

  [contentView addSubview:SLECreateView(content1Frame, [UIColor cyanColor])];
  [contentView addSubview:SLECreateView(content2Frame, [UIColor magentaColor])];

  FBSnapshotVerifyView(_rootView, nil);
  FBSnapshotVerifyLayer(_rootView.layer, nil);
}

@end
