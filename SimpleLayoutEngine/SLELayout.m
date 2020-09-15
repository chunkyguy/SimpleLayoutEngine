//
// Created by Sidharth Juyal on 15/09/2020.
// Copyright © 2020 SLE. All rights reserved.
//

#import "SLELayout.h"
#import "SLELayoutItem+Internal.h"

@interface SLELayout () {
  CGSize _parentSize;
  NSMutableArray *_items;
  SLELayoutDirection _direction;
  SLELayoutAlignment _alignment;
}
@end

@implementation SLELayout
+ (instancetype)layoutWithParentBounds:(CGRect)bounds
                             direction:(SLELayoutDirection)direction;
{
  return [[[self class] alloc] initWithParentBounds:bounds direction:direction];
}

- (instancetype)initWithParentBounds:(CGRect)bounds
                           direction:(SLELayoutDirection)direction
{
  self = [super init];
  if (self) {
    _parentSize = bounds.size;
    _direction = direction;
    _items = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc
{
  [_items release];
  [super dealloc];
}

- (void)updateFrames
{
  CGFloat usedSpace = 0;
  NSInteger flexItems = 0;
  for (SLELayoutItem *item in _items) {
    CGRect itemFrame = item.originalFrame;
    CGFloat itemSpace = (_direction == SLELayoutDirectionColumn) ? itemFrame.size.height : itemFrame.size.width;
    if (itemSpace == kSLELayoutValueUndefined) {
      flexItems += 1;
    } else {
      usedSpace += itemSpace;
    }
  }

  CGFloat parentWidth = _parentSize.width;
  CGFloat parentHeight = _parentSize.height;
  CGFloat maxFlexSpace = _direction == SLELayoutDirectionColumn ? parentHeight : parentWidth;
  CGFloat maxFixSpace = _direction == SLELayoutDirectionColumn ? parentWidth : parentHeight;
  CGFloat remainingSpace = maxFlexSpace - usedSpace;
  CGFloat remaingPerItemSpace = remainingSpace / (CGFloat)flexItems;

  CGPoint offset = CGPointZero;
  for (SLELayoutItem *item in _items) {
    CGSize itemSize = item.originalFrame.size;
    if (_direction == SLELayoutDirectionColumn) {
      CGFloat itemHeight = itemSize.height == kSLELayoutValueUndefined ? remaingPerItemSpace : itemSize.height;
      itemSize = (CGSize) { .width = maxFixSpace, .height = itemHeight };
    } else {
      CGFloat itemWidth = itemSize.width == kSLELayoutValueUndefined ? remaingPerItemSpace : itemSize.width;
      itemSize = (CGSize) { .width = itemWidth, .height = maxFixSpace };
    }

    [item setOrigin:offset];
    [item setSize:itemSize];

    if (_direction == SLELayoutDirectionColumn) {
      offset.y += itemSize.height;
    } else {
      offset.x += itemSize.width;
    }
  }
}

- (void)addItem:(SLELayoutItem *)item
{
  [_items addObject:item];
  [self updateFrames];
}

- (CGRect)frameAtIndex:(NSInteger)index;
{
  SLELayoutItem *item = [_items objectAtIndex:index];
  return item.frame;
}

@end
