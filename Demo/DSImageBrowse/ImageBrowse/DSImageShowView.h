//
//  DSImageShowView.h
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/8/4.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSImageScrollView.h"

@interface DSImageShowView : UIView

//数据
@property (nonatomic, readonly) NSArray<DSImageScrollItem *> *items;

//当前页
@property (nonatomic, readonly) NSInteger currentPage;

//是否使用模糊背景 默认NO
@property (nonatomic, assign)   BOOL blurEffectBackground;

//是否裁剪缩略图 默认 YES
@property (nonatomic, assign)   BOOL clipThumbnail;

/**
 初始化方法
 
 @param items item数据
 @return 该实例
 */
- (instancetype)initWithItems:(NSArray <DSImageScrollItem *>*)items;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

// 视图展示
- (void)presentfromImageView:(UIView *)fromView toContainer:(UIView *)toContainer index:(NSInteger)index animated:(BOOL)animated completion:(void (^)(void))completion;

// 视图消失
- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion;

// 会调用 [self dismissAnimated:YES completion:nil];
- (void)dismiss;

// 长按图片回调
@property (nonatomic, copy) void (^longPressBlock)(UIImageView *imageView);

@end
