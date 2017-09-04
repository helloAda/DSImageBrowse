//
//  DSChatImageCell.h
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/9/2.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSImageBrowseView.h"
#import "DSImageLayout.h"

#import "DSImageDemoCell.h"

@class DSChatImageCell;

@interface DSChatImageCell : UITableViewCell <DSImageBrowseDelegate>

@property (nonatomic, weak) id<DSImageBrowseCellDelegate> delegate;
//这里就直接使用这个视图，只显示单张也是可以满足需求。 实际使用中可以使用自己的。
@property (nonatomic, strong) DSImageBrowseView *imageBrowseView;

- (void)setLayout:(DSImageLayout *)layout;
@end
