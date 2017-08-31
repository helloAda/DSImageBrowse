//
//  CALayer+DSCategory.h
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/8/7.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (DSCategory)

@property (nonatomic) CGPoint center;      ///< Shortcut for center.

@property (nonatomic, getter=frameSize, setter=setFrameSize:) CGSize  size; ///< Shortcut for frame.size.

- (void)addFadeAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve;

- (void)removePreviousFadeAnimation;

@property (nonatomic) CGFloat transformScale;        ///< key path "tranform.scale"
@end
