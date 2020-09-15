//
// Created by Sidharth Juyal on 15/09/2020.
// Copyright © 2020 SLE. All rights reserved.
//

#import "SLELayoutItem.h"

NS_ASSUME_NONNULL_BEGIN

extern const CGFloat kSLELayoutValueUndefined;

@interface SLELayoutItem ()

- (void)setOrigin:(CGPoint)origin;
- (void)setSize:(CGSize)size;

@property (nonatomic, readonly) CGRect originalFrame;

@end

NS_ASSUME_NONNULL_END
