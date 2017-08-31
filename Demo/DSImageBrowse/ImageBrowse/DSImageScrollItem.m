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

- (UIImage *)thumbImage {

    if ([_thumbView respondsToSelector:@selector(image)]) {
        return ((UIImageView *)_thumbView).image;
    }
    return nil;
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
