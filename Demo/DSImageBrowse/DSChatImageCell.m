//
//  DSChatImageCell.m
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/9/2.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSChatImageCell.h"

@implementation DSChatImageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageBrowseView = [[DSImageBrowseView alloc] init];
        _imageBrowseView.delegate = self;
        [self addSubview:_imageBrowseView];
        self.backgroundColor = RGB(240, 240, 240);
    }
    return self;
}

- (void)setLayout:(DSImageLayout *)layout {
    
    self.height = layout.imageBrowseHeight;
    _imageBrowseView.layout = layout;
}

- (void)imageBrowse:(DSImageBrowseView *)imageView didSelectImageAtIndex:(NSInteger)index {
    
    if ([self.delegate respondsToSelector:@selector(didClick:atIndex:)]) {
        [self.delegate didClick:imageView atIndex:index];
    }
    
}

- (void)imageBrowse:(DSImageBrowseView *)imageView longPressImageAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(longPress:atIndex:)]) {
        [self.delegate longPress:imageView atIndex:index];
    }
}

@end
