//
//  DSImageScrollItem.m
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/8/4.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSImageScrollItem.h"

@interface DSImageScrollItem () <NSCopying>

@end
@implementation DSImageScrollItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isVisibleThumbView = YES;
    }
    return self;
}


- (UIImage *)thumbImage {
    if ([_thumbView respondsToSelector:@selector(image)]) {
        return ((UIImageView *)_thumbView).image;
    }
    //在聊天模式下，由于item.thumbView只有当cell可见时才有赋值缩略图，其它的在还没有加载过大图的时候会出现灰色的一块。
    return [UIImage imageNamed:@"default"];
}

- (BOOL)thumbClippedToTop {
    if (_thumbView) {
        if (_thumbView.layer.contentsRect.size.height < 1) {
            return YES;
        }
    }
    return NO;
}

- (id)copyWithZone:(NSZone *)zone {
    DSImageScrollItem *item = [[self.class alloc] init];
    return item;
}
@end
