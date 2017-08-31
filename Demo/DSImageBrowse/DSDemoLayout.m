//
//  DSDemoLayout.m
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/8/29.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSDemoLayout.h"
#import "NSString+DSCategory.h"

@implementation DSDemoLayout

- (instancetype)initWithDSDemoMode:(DSDemoModel *)model {
    self = [super init];
    if (self) {
        _model = model;
        [self layout];
    }
    return self;
}

- (void)layout {
    
    _imageLayout = [[DSImageLayout alloc] initWithImageData:_model.imageDataArray];
    _imageLayout.leftPadding = 0;
    _imageLayout.rightPadding = 0;
    _imageLayout.imageBrowseWidth = kScreenWidth - 20;
    [_imageLayout layout];
    
    _descHeight = [_model.describe ds_sizeForFont:[UIFont systemFontOfSize:17] size:CGSizeMake(kScreenWidth - 20, HUGE) mode:NSLineBreakByWordWrapping].height;
    
    _cellHeight = _descHeight + _imageLayout.imageBrowseHeight + 12;
}

@end
