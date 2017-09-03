//
//  DTableDelegate.h
//  DTableViewDemo
//
//  Created by 黄铭达 on 2017/4/25.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DTableDelegate : NSObject<UITableViewDataSource,UITableViewDelegate>

- (instancetype)initWithTableViewData:(NSArray *(^)(void))data;

@property (nonatomic, assign) CGFloat defaultSeparatorLeftEdge;

@end
