//
//  DSForceTouchController
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/8/14.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSImageBrowse.h"

@interface DSForceTouchController : UIViewController

//预览图片视图
@property (nonatomic, strong) YYAnimatedImageView *imageView;
//预览图片数据
@property (nonatomic, strong) DSImageScrollItem *item;
//预览图片Rect
@property (nonatomic, assign) CGRect imageRect;
//action 例如@[@"收藏",@"保存"] 不大于4
@property (nonatomic, strong) NSMutableArray *actionTitles;
//action回调
@property (nonatomic, copy) void (^actionBlock)(NSInteger index);

@end
