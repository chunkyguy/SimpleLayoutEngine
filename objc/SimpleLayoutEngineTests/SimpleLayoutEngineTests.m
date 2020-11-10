//
// Created by Sidharth Juyal on 15/09/2020.
// Copyright © 2020 SLE. All rights reserved.
//

#import "SLELayout.h"
#import <FBSnapshotTestCase/FBSnapshotTestCase.h>
#import <XCTest/XCTest.h>

// All the tests are recorded using iPhone 11 Pro Max

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
  SLELayout *layout = [SLELayout layoutWithParentFrame:_rootFrame
                                             direction:SLELayoutDirectionColumn
                                             alignment:SLELayoutAlignmentLeading];
  SLELayoutItem *mainItem = [SLELayoutItem flexItem];
  [layout addItem:mainItem];

  UIView *redView = SLECreateView(mainItem.frame, [UIColor redColor]);
  [_rootView addSubview:redView];

  FBSnapshotVerifyView(_rootView, nil);
  FBSnapshotVerifyLayer(_rootView.layer, nil);
}

- (void)testBottomFixLayout
{
  SLELayout *layout = [SLELayout layoutWithParentFrame:_rootFrame
                                             direction:SLELayoutDirectionColumn
                                             alignment:SLELayoutAlignmentLeading];
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
  SLELayout *mainLayout = [SLELayout layoutWithParentFrame:_rootFrame
                                                 direction:SLELayoutDirectionColumn
                                                 alignment:SLELayoutAlignmentLeading];
  [mainLayout addItem:[SLELayoutItem flexItem]];
  [mainLayout addItem:[SLELayoutItem itemWithHeight:44]];
  [mainLayout addItem:[SLELayoutItem itemWithHeight:contentHeight]];

  CGRect headerFrame = [mainLayout frameAtIndex:0];
  CGRect toolbarFrame = [mainLayout frameAtIndex:1];
  CGRect contentFrame = [mainLayout frameAtIndex:2];

  // since the child views are added to subview, we use local bounds of contentFrame
  SLELayout *contentLayout = [SLELayout layoutWithParentFrame:(CGRect) { .origin = CGPointZero, .size = contentFrame.size }
                                                    direction:SLELayoutDirectionRow
                                                    alignment:SLELayoutAlignmentLeading];
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

- (void)testColumnStartAlignment
{
  SLELayout *mainLayout = [SLELayout layoutWithParentFrame:_rootFrame
                                                 direction:SLELayoutDirectionColumn
                                                 alignment:SLELayoutAlignmentLeading];
  SLELayoutItem *startItem = [SLELayoutItem itemWithSize:CGSizeMake(100.f, 100.f)];
  SLELayoutItem *centerItem = [SLELayoutItem itemWithSize:CGSizeMake(100.f, 100.f)];
  SLELayoutItem *endItem = [SLELayoutItem itemWithSize:CGSizeMake(100.f, 100.f)];
  [mainLayout addItem:[SLELayoutItem flexItem]];
  [mainLayout addItem:startItem];
  [mainLayout addItem:centerItem];
  [mainLayout addItem:endItem];
  [mainLayout addItem:[SLELayoutItem flexItem]];

  [_rootView addSubview:SLECreateView([startItem frame], [UIColor lightGrayColor])];
  [_rootView addSubview:SLECreateView([centerItem frame], [UIColor grayColor])];
  [_rootView addSubview:SLECreateView([endItem frame], [UIColor darkGrayColor])];

  FBSnapshotVerifyView(_rootView, nil);
  FBSnapshotVerifyLayer(_rootView.layer, nil);
}

- (void)testColumnCenterAlignment
{
  SLELayout *mainLayout = [SLELayout layoutWithParentFrame:_rootFrame
                                                 direction:SLELayoutDirectionColumn
                                                 alignment:SLELayoutAlignmentCenter];
  SLELayoutItem *startItem = [SLELayoutItem itemWithSize:CGSizeMake(100.f, 100.f)];
  SLELayoutItem *centerItem = [SLELayoutItem itemWithSize:CGSizeMake(100.f, 100.f)];
  SLELayoutItem *endItem = [SLELayoutItem itemWithSize:CGSizeMake(100.f, 100.f)];
  [mainLayout addItem:[SLELayoutItem flexItem]];
  [mainLayout addItem:startItem];
  [mainLayout addItem:centerItem];
  [mainLayout addItem:endItem];
  [mainLayout addItem:[SLELayoutItem flexItem]];

  [_rootView addSubview:SLECreateView([startItem frame], [UIColor lightGrayColor])];
  [_rootView addSubview:SLECreateView([centerItem frame], [UIColor grayColor])];
  [_rootView addSubview:SLECreateView([endItem frame], [UIColor darkGrayColor])];

  FBSnapshotVerifyView(_rootView, nil);
  FBSnapshotVerifyLayer(_rootView.layer, nil);
}

- (void)testColumnEndAlignment
{
  SLELayout *mainLayout = [SLELayout layoutWithParentFrame:_rootFrame
                                                 direction:SLELayoutDirectionColumn
                                                 alignment:SLELayoutAlignmentTrailing];
  SLELayoutItem *startItem = [SLELayoutItem itemWithSize:CGSizeMake(100.f, 100.f)];
  SLELayoutItem *centerItem = [SLELayoutItem itemWithSize:CGSizeMake(100.f, 100.f)];
  SLELayoutItem *endItem = [SLELayoutItem itemWithSize:CGSizeMake(100.f, 100.f)];
  [mainLayout addItem:[SLELayoutItem flexItem]];
  [mainLayout addItem:startItem];
  [mainLayout addItem:centerItem];
  [mainLayout addItem:endItem];
  [mainLayout addItem:[SLELayoutItem flexItem]];

  [_rootView addSubview:SLECreateView([startItem frame], [UIColor lightGrayColor])];
  [_rootView addSubview:SLECreateView([centerItem frame], [UIColor grayColor])];
  [_rootView addSubview:SLECreateView([endItem frame], [UIColor darkGrayColor])];

  FBSnapshotVerifyView(_rootView, nil);
  FBSnapshotVerifyLayer(_rootView.layer, nil);
}

- (void)testRowStartAlignment
{
  SLELayout *mainLayout = [SLELayout layoutWithParentFrame:_rootFrame
                                                 direction:SLELayoutDirectionRow
                                                 alignment:SLELayoutAlignmentLeading];
  SLELayoutItem *startItem = [SLELayoutItem itemWithSize:CGSizeMake(100.f, 100.f)];
  SLELayoutItem *centerItem = [SLELayoutItem itemWithSize:CGSizeMake(100.f, 100.f)];
  SLELayoutItem *endItem = [SLELayoutItem itemWithSize:CGSizeMake(100.f, 100.f)];
  [mainLayout addItem:[SLELayoutItem flexItem]];
  [mainLayout addItem:startItem];
  [mainLayout addItem:centerItem];
  [mainLayout addItem:endItem];
  [mainLayout addItem:[SLELayoutItem flexItem]];

  [_rootView addSubview:SLECreateView([startItem frame], [UIColor lightGrayColor])];
  [_rootView addSubview:SLECreateView([centerItem frame], [UIColor grayColor])];
  [_rootView addSubview:SLECreateView([endItem frame], [UIColor darkGrayColor])];

  FBSnapshotVerifyView(_rootView, nil);
  FBSnapshotVerifyLayer(_rootView.layer, nil);
}

- (void)testRowCenterAlignment
{
  SLELayout *mainLayout = [SLELayout layoutWithParentFrame:_rootFrame
                                                 direction:SLELayoutDirectionRow
                                                 alignment:SLELayoutAlignmentCenter];
  SLELayoutItem *startItem = [SLELayoutItem itemWithSize:CGSizeMake(100.f, 100.f)];
  SLELayoutItem *centerItem = [SLELayoutItem itemWithSize:CGSizeMake(100.f, 100.f)];
  SLELayoutItem *endItem = [SLELayoutItem itemWithSize:CGSizeMake(100.f, 100.f)];
  [mainLayout addItem:[SLELayoutItem flexItem]];
  [mainLayout addItem:startItem];
  [mainLayout addItem:centerItem];
  [mainLayout addItem:endItem];
  [mainLayout addItem:[SLELayoutItem flexItem]];

  [_rootView addSubview:SLECreateView([startItem frame], [UIColor lightGrayColor])];
  [_rootView addSubview:SLECreateView([centerItem frame], [UIColor grayColor])];
  [_rootView addSubview:SLECreateView([endItem frame], [UIColor darkGrayColor])];

  FBSnapshotVerifyView(_rootView, nil);
  FBSnapshotVerifyLayer(_rootView.layer, nil);
}

- (void)testRowEndAlignment
{
  SLELayout *mainLayout = [SLELayout layoutWithParentFrame:_rootFrame
                                                 direction:SLELayoutDirectionRow
                                                 alignment:SLELayoutAlignmentTrailing];
  SLELayoutItem *startItem = [SLELayoutItem itemWithSize:CGSizeMake(100.f, 100.f)];
  SLELayoutItem *centerItem = [SLELayoutItem itemWithSize:CGSizeMake(100.f, 100.f)];
  SLELayoutItem *endItem = [SLELayoutItem itemWithSize:CGSizeMake(100.f, 100.f)];
  [mainLayout addItem:[SLELayoutItem flexItem]];
  [mainLayout addItem:startItem];
  [mainLayout addItem:centerItem];
  [mainLayout addItem:endItem];
  [mainLayout addItem:[SLELayoutItem flexItem]];

  [_rootView addSubview:SLECreateView([startItem frame], [UIColor lightGrayColor])];
  [_rootView addSubview:SLECreateView([centerItem frame], [UIColor grayColor])];
  [_rootView addSubview:SLECreateView([endItem frame], [UIColor darkGrayColor])];

  FBSnapshotVerifyView(_rootView, nil);
  FBSnapshotVerifyLayer(_rootView.layer, nil);
}

@end
