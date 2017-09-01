//
//  DSImageDemoCell.m
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/8/9.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSImageDemoCell.h"

@implementation DSImageDemoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageBrowseView = [[DSImageBrowseView alloc] init];
        _imageBrowseView.delegate = self;
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.font = [UIFont systemFontOfSize:17];
        _describeLabel.numberOfLines = 0;
        [self addSubview:_describeLabel];
        [self addSubview:_imageBrowseView];
        self.backgroundColor = RGB(240, 240, 240);
    }
    return self;
}

- (void)setLayout:(DSDemoLayout *)layout {

    self.height = layout.cellHeight;
    _describeLabel.text = layout.model.describe;
    _describeLabel.frame = CGRectMake(10, 12, kScreenWidth - 20, layout.descHeight);
    _imageBrowseView.frame = CGRectMake(10, 12 + layout.descHeight, 0, 0);
    _imageBrowseView.layout = layout.imageLayout;
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
