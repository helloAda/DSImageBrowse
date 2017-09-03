//
//  UIScrollView+DSCategory.h
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/8/7.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (DSCategory)

/**
 Scroll content to top.
 
 @param animated  Use animation.
 */
- (void)scrollToTopAnimated:(BOOL)animated;

@end
