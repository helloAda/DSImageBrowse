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
 默认为YES.(聊天模式下才去修改)
 当前图片的缩略图不可见的话，动画效果就会不同。
 */
@property (nonatomic, assign) BOOL isVisibleThumbView;

//默认为NO.(请在网页模式下才设置为YES)
@property (nonatomic, assign) BOOL cancelPan;

//大图尺寸，若无则传0
@property (nonatomic, assign) CGSize largeImageSize;
//大图url
@property (nonatomic, strong) NSURL *largeImageURL;

@end
