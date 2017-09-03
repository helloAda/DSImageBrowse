//
//  DSImagesData.h
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/7/15.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DSImageBadgeType) {
    DSImageBadgeTypeNone = 0,     //    正常图片
    DSImageBadgeTypeLong,         //    长图
    DSImageBadgeTypeGIF,          //    GIF
};


/**
 图片数据
 */
@interface DSImageData : NSObject

@property (nonatomic, strong) NSURL *url;                 //图片URL
@property (nonatomic, assign) int width;                  //图片宽度
@property (nonatomic, assign) int height;                 //图片高度
@property (nonatomic, assign) DSImageBadgeType badgeType; //图片类型 默认None

@end

/**
 包含图片缩略图、大图等所有图片的数据
 */
@interface DSImagesData : NSObject
//缩略图数据
@property (nonatomic, strong) DSImageData *thumbnailImage;
//大图数据  (这个必须要有)
@property (nonatomic, strong) DSImageData *largeImage;

@end
