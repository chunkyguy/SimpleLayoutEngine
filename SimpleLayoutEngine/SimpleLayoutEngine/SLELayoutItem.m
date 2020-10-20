//
// Created by Sidharth Juyal on 15/09/2020.
// Copyright © 2020 SLE. All rights reserved.
//

#import "SLELayoutItem.h"
#import "SLELayoutItem+Internal.h"

const CGFloat kSLELayoutValueUndefined = -1.f;

@interface SLELayoutItem () {
  CGSize _originalSize;
  CGRect _finalFrame;
}
@end

@implementation SLELayoutItem
+ (instancetype)flexItem
{
  return [[[[self class] alloc] initWithSize:CGSizeMake(kSLELayoutValueUndefined, kSLELayoutValueUndefined)] autorelease];
}

+ (instancetype)itemWithWidth:(CGFloat)width;
{
  return [[[[self class] alloc] initWithSize:CGSizeMake(width, kSLELayoutValueUndefined)] autorelease];
}

+ (instancetype)itemWithHeight:(CGFloat)height;
{
  return [[[[self class] alloc] initWithSize:CGSizeMake(kSLELayoutValueUndefined, height)] autorelease];
}

+ (instancetype)itemWithSize:(CGSize)size
{

  return [[[[self class] alloc] initWithSize:size] autorelease];
}

- (instancetype)initWithSize:(CGSize)size
{
  self = [super init];
  if (self) {
    _originalSize = size;
    _finalFrame = CGRectZero;
  }
  return self;
}

- (void)setOrigin:(CGPoint)origin
{
  _finalFrame.origin = origin;
}

- (void)setSize:(CGSize)size
{
  _finalFrame.size = size;
}

- (CGSize)originalSize
{
  return _originalSize;
}

- (CGRect)frame
{
  return _finalFrame;
}

@end
