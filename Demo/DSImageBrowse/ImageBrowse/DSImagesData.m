//
//  DSImagesData.m
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/7/15.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSImagesData.h"

@implementation DSImageData

- (instancetype)init
{
    self = [super init];
    if (self) {
        _badgeType = DSImageBadgeTypeNone;
    }
    return self;
}


@end

@implementation DSImagesData

- (instancetype)init
{
    self = [super init];
    if (self) {
        _thumbnailImage = [[DSImageData alloc] init];
        _largeImage = [[DSImageData alloc] init];
    }
    return self;
}
@end
