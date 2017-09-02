//
//  DSImageDemoCell.h
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/8/9.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSImageBrowseView.h"
#import "DSDemoLayout.h"

@class DSImageDemoCell;

@protocol DSImageBrowseCellDelegate <NSObject>

- (void)didClick:(DSImageBrowseView *)imageView atIndex:(NSInteger)index;
- (void)longPress:(DSImageBrowseView *)imageView atIndex:(NSInteger)index;

@end

@interface DSImageDemoCell : UITableViewCell<DSImageBrowseDelegate>

@property (nonatomic, weak) id<DSImageBrowseCellDelegate> delegate;
@property (nonatomic, strong) DSImageBrowseView *imageBrowseView;
@property (nonatomic, strong) UILabel *describeLabel;

- (void)setLayout:(DSDemoLayout *)layout;

@end
