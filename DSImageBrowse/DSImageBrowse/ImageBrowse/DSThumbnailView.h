//
//  DSThumbnailView.h
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/7/20.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 缩略图视图
 */
@interface DSThumbnailView : UIView

//缩略图
@property (nonatomic, strong) UIImage *image;

//单击回调
@property (nonatomic, copy) void (^touchBlock)(DSThumbnailView *view, CGPoint point);
//长按回调
@property (nonatomic, copy) void (^longPressBlock)(DSThumbnailView *view, CGPoint point);


@end
