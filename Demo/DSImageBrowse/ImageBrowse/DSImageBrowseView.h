//
//  DSImageBrowseView.h
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/7/15.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSImageLayout.h"
#import "DSThumbnailView.h"
#import "UIView+DSCategory.h"


@protocol DSImageBrowseDelegate;
@interface DSImageBrowseView : UIView

//存放缩略图
@property (nonatomic, strong) NSArray<DSThumbnailView *> *imageViews;

//代理
@property (nonatomic, weak) id<DSImageBrowseDelegate> delegate;

//布局对象
@property (nonatomic, strong) DSImageLayout *layout;

//长图片标记图片名称
@property (nonatomic, strong) NSString *longImageBadgeName;

//GIF图片标记图片名称
@property (nonatomic, strong) NSString *gifImageBadgeName;

//默认图片名称
@property (nonatomic, strong) NSString *defaultImageName;

@end




@protocol DSImageBrowseDelegate <NSObject>

@optional

//点击图片
- (void)imageBrowse:(DSImageBrowseView *)imageView didSelectImageAtIndex:(NSInteger)index;
//长按图片
- (void)imageBrowse:(DSImageBrowseView *)imageView longPressImageAtIndex:(NSInteger)index;
@end
