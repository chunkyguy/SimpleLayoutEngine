//
// Created by Sidharth Juyal on 15/09/2020.
// Copyright © 2020 SLE. All rights reserved.
//

#import "SLELayoutItem.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SLELayoutDirection) {
  SLELayoutDirectionRow,
  SLELayoutDirectionColumn
};

typedef NS_ENUM(NSUInteger, SLELayoutAlignment) {
  SLELayoutAlignmentStart,
  SLELayoutAlignmentCenter,
  SLELayoutAlignmentEnd
};

@interface SLELayout : NSObject
+ (instancetype)layoutWithParentBounds:(CGRect)bounds
                             direction:(SLELayoutDirection)direction;

- (void)addItem:(SLELayoutItem *)item;
- (CGRect)frameAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
