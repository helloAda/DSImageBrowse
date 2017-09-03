//
//  UIImage+DSCategory.m
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/8/5.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "UIImage+DSCategory.h"

@implementation UIImage (DSCategory)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (UIImage *)ds_thumbnailWithImage:(UIImage *)image size:(CGSize)size {
    if (!image) return nil;
    UIImage *thumbnailImage;
    CGRect rect;
    if (size.width / size.height > image.size.width / image.size.height) {
        rect.size.width = size.height * image.size.width / image.size.height;
        rect.size.height = size.height;
        rect.origin.x = (size.width - rect.size.width) / 2;
        rect.origin.y = 0;
    } else {
        rect.size.width = size.width;
        rect.size.height = size.width * image.size.height / image.size.width;
        rect.origin.x = 0;
        rect.origin.y = (size.height - rect.size.height) / 2;
    }
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    [image drawInRect:rect];
    thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbnailImage;
    
}


@end
