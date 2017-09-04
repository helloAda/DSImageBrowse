//
//  DSWebImageViewController.h
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/9/4.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSWebImageViewController : UIViewController

/**
 直接调用这个方法进行初始化即可

 @param images 图片的url数组 传NSString类型
 @param currentImage 当前图片的url
 @return 控制器实例
 */
- (instancetype)initWithImages:(NSArray <NSString *>*)images currentImage:(NSString *)currentImage;

@end
