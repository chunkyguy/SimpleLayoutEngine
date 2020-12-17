//
// Created by Sidharth Juyal on 15/09/2020.
// Copyright © 2020 SLE. All rights reserved.
//

#import "SLELayout.h"
#import "SLELayoutItem+Internal.h"

#define kSLEAssignIfUndefined(lhs, rhs) lhs = (lhs == kSLELayoutValueUndefined) ? rhs : lhs
#define kSLEDivide(x, y) ((y == 0) ? 0 : (x) / y)

@interface SLELayout () {
  CGRect _parentFrame;
  NSMutableArray *_items;
  SLELayoutDirection _direction;
  SLELayoutAlignment _alignment;
}
@end

@implementation SLELayout
+ (instancetype)layoutWithParentFrame:(CGRect)frame
                             direction:(SLELayoutDirection)direction
                             alignment:(SLELayoutAlignment)alignment;
{
  return [[[[self class] alloc] initWithParentFrame:frame direction:direction alignment:alignment]autorelease];
}

- (instancetype)initWithParentFrame:(CGRect)frame
                           direction:(SLELayoutDirection)direction
                           alignment:(SLELayoutAlignment)alignment
{
  self = [super init];
  if (self) {
    _parentFrame = frame;
    _direction = direction;
    _alignment = alignment;
    _items = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc
{
  [_items release];
  [super dealloc];
}

- (void)updateSizeForItem:(SLELayoutItem *)item itemSpace:(CGFloat)itemSpace
{
  CGSize itemSize = item.originalSize;
  switch (_direction) {
  case SLELayoutDirectionColumn:
    kSLEAssignIfUndefined(itemSize.width, CGRectGetWidth(_parentFrame));
    kSLEAssignIfUndefined(itemSize.height, itemSpace);
    break;
  case SLELayoutDirectionRow:
    kSLEAssignIfUndefined(itemSize.width, itemSpace);
    kSLEAssignIfUndefined(itemSize.height, CGRectGetHeight(_parentFrame));
    break;
  }
  [item setSize:itemSize];
}

- (CGPoint)updateOriginForItem:(SLELayoutItem *)item lastItemOrigin:(CGPoint)itemOrigin
{
  CGFloat offsetFactor = 1.f;
  switch (_alignment) {
    case SLELayoutAlignmentLeading: offsetFactor = 0.f; break;
    case SLELayoutAlignmentCenter: offsetFactor = 2.f; break;
    case SLELayoutAlignmentTrailing: offsetFactor = 1.f; break;
  }

  switch (_direction) {
    case SLELayoutDirectionColumn:
      itemOrigin.x = _parentFrame.origin.x + kSLEDivide(CGRectGetWidth(_parentFrame) - CGRectGetWidth([item frame]), offsetFactor);
      break;
    case SLELayoutDirectionRow:
      itemOrigin.y = _parentFrame.origin.y + kSLEDivide(CGRectGetHeight(_parentFrame) - CGRectGetHeight([item frame]), offsetFactor);
      break;
  }

  [item setOrigin:itemOrigin];

  switch (_direction) {
  case SLELayoutDirectionColumn:
    itemOrigin.y += CGRectGetHeight([item frame]);
    break;
  case SLELayoutDirectionRow:
    itemOrigin.x += CGRectGetWidth([item frame]);
    break;
  }

  return itemOrigin;
}

- (void)updateFrames
{
  CGFloat totalFlexSpace = _direction == SLELayoutDirectionColumn ? CGRectGetHeight(_parentFrame) : CGRectGetWidth(_parentFrame);
  NSInteger flexItems = 0;

  // calculate flex space
  for (SLELayoutItem *item in _items) {
    CGFloat itemSpace = (_direction == SLELayoutDirectionColumn) ? item.originalSize.height : item.originalSize.width;
    if (itemSpace == kSLELayoutValueUndefined) {
      flexItems += 1;
    } else {
      totalFlexSpace -= itemSpace;
    }
  }

  // update item frame
  CGFloat itemSpace = (totalFlexSpace) / (CGFloat)(MAX(flexItems, 1));
  NSAssert(itemSpace >= 0, @"Not sufficient space");
  CGPoint itemOrigin = _parentFrame.origin;
  for (SLELayoutItem *item in _items) {
    [self updateSizeForItem:item itemSpace:itemSpace];
    itemOrigin = [self updateOriginForItem:item lastItemOrigin:itemOrigin];
  }
}

- (void)addItem:(SLELayoutItem *)item
{
  [_items addObject:item];
  [self updateFrames];
}

- (CGRect)frameAtIndex:(NSInteger)index;
{
  return [[_items objectAtIndex:index] frame];
}

- (NSInteger)totalItems
{
  return [_items count];
}
@end
