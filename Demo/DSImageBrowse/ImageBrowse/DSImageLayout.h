//
//  DSImageLayout.h
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/7/15.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DSImageMacro.h"
#import "DSImagesData.h"

/**
 排版布局，在后台线程操作以提高性能
 */
@interface DSImageLayout : NSObject

/**
 排版布局对象
 @param imagedata 图片数据
 */
- (instancetype)initWithImageData:(NSArray <DSImagesData *>*)imagedata;

/**
 初始化后，一定要调用该方法进行排版
 如果需要修改默认参数，请初始化完修改参数，再调用该方法，否则还是使用默认数据。
 */
- (void)layout;

//所有图片数据
@property (nonatomic, strong) NSArray<DSImagesData *> *imagesData;

//计算后单张图片的大小 (除了单张图片并且有缩略图宽高数据，其余情况下均为正方形)
@property (nonatomic, assign, readonly) CGSize imageSize;

//计算后整个View的高度
@property (nonatomic, assign, readonly) CGFloat imageBrowseHeight;

//整个View宽度 默认 屏幕宽度
@property (nonatomic, assign) CGFloat imageBrowseWidth;

//每张图片的中间的间隔  默认 4
@property (nonatomic, assign) CGFloat imagePadding;

//距离顶部距离  默认 12
@property (nonatomic, assign) CGFloat topPadding;

//距离底部距离  默认 12
@property (nonatomic, assign) CGFloat bottomPadding;

//距离左边距离  默认 12
@property (nonatomic, assign) CGFloat leftPadding;

//距离右边距离  默认 12
@property (nonatomic, assign) CGFloat rightPadding;

//图片角标宽度  默认 28
@property (nonatomic, assign) CGFloat imageBadgeWidth;

//图片角标高度  默认 18
@property (nonatomic, assign) CGFloat imageBadgeHeight;

@end
