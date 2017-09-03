//
//  DSImageScrollView.h
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/8/15.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSImageScrollItem.h"
#import "CALayer+DSCategory.h"
#import <YYImage/YYAnimatedImageView.h>
#import <YYWebImage/UIImageView+YYWebImage.h>

@interface DSImageScrollView : UIScrollView

//内容视图
@property (nonatomic, strong) UIView *imageContainerView;
//图片视图
@property (nonatomic, strong) YYAnimatedImageView *imageView;
//当前页(预加载时使用)
@property (nonatomic, assign) NSInteger page;
//传入的数据
@property (nonatomic, strong) DSImageScrollItem *item;
//进度条
@property (nonatomic, strong) CAShapeLayer *progressLayer;

- (void)resizeSubviewSize;

@end
