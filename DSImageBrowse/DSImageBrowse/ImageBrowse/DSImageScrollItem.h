//
//  DSImageScrollItem.h
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/8/4.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "UIImage+DSCategory.h"
#import "UIView+DSCategory.h"
#import "DSImageLayout.h"

@interface DSImageScrollItem : NSObject
//缩略图
@property (nonatomic, readonly) UIImage *thumbImage;
//高图的时候裁剪保留顶部
@property (nonatomic, readonly) BOOL thumbClippedToTop;

//缩略图View
@property (nonatomic, strong) UIView *thumbView;

/**
 默认为YES。(聊天模式下才去修改)
 如果只有单纯的数据，而没有保存缩略图View的Rect，动画效果就会不同。
 */
@property (nonatomic, assign) BOOL isOriginalThumbView;

//大图尺寸，若无则传0
@property (nonatomic, assign) CGSize largeImageSize;
//大图url
@property (nonatomic, strong) NSURL *largeImageURL;

@end
