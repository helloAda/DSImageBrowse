//
//  DSImageShowView.h
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/8/4.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSImageScrollView.h"

typedef NS_ENUM(NSInteger, DSImageShowType) {
    DSImageShowTypeDefault,     ///  默认带page，最多9张。
    DSImageShowTypeChat,        ///  默认不带page，可以多张，用于聊天内容图片显示
    DSImageShowtypeWebImage     ///  用于显示网页中的图片
};


@interface DSImageShowView : UIView

//数据
@property (nonatomic, readonly) NSArray<DSImageScrollItem *> *items;

//当前页
@property (nonatomic, readonly) NSInteger currentPage;

//是否使用模糊背景 默认NO
@property (nonatomic, assign)   BOOL blurEffectBackground;

/**
 没有拿到图片坐标时，动画开始的位置和开始大小。
 默认((self.width - 100) / 2,self.height - 100) / 2,100,100);
 */
@property (nonatomic, assign)   CGRect fromRect;

// 长按图片回调
@property (nonatomic, copy) void (^longPressBlock)(UIImageView *imageView);
/**
 初始化方法

 @param items item数据
 @param type 显示类型
 @return DSImageShowView实例
 */
- (instancetype)initWithItems:(NSArray <DSImageScrollItem *>*)items type:(DSImageShowType)type;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

// 视图展示
- (void)presentfromImageView:(UIView *)fromView toContainer:(UIView *)toContainer index:(NSInteger)index animated:(BOOL)animated completion:(void (^)(void))completion;

// 视图消失
- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion;

// 会调用 [self dismissAnimated:YES completion:nil];
- (void)dismiss;

// 只有在type == DSImageShowtypeWebImage 情况下才调用，否则无效。
- (void)showWebImageIndex:(NSInteger)index;

@end
