//
//  DSDemoLayout.h
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/8/29.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSDemoModel.h"
#import "DSImageLayout.h"

@interface DSDemoLayout : NSObject

- (instancetype)initWithDSDemoMode:(DSDemoModel *)model;

@property (nonatomic, strong) DSDemoModel *model;
@property (nonatomic, strong) DSImageLayout *imageLayout;
@property (nonatomic, assign) CGFloat descHeight;
@property (nonatomic, assign) CGFloat cellHeight;
@end
