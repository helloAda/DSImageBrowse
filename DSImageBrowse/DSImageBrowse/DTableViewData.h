//
//  DTableViewData.h
//  DTableViewDemo
//
//  Created by 黄铭达 on 2017/4/25.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define  SeparatedLineLeft  15//分割线距左边的距离

/**
 section key
 */

#define HeaderTitle  @"headerTitle"
#define FooterTitle  @"footerTitle"
#define HeaderHeight @"headerHeight"
#define FooterHeight @"footerHeight"
#define RowData      @"rows"


/**
 row key
 */

#define Title             @"title"
#define DetaillTitle       @"detailTitle"
#define ImageName         @"imageName"
#define CellClass         @"cellClass"
#define CellAction        @"cellAction"
#define Data              @"data"
#define RowHeight         @"rowHeight"
#define SeparatedLeftEdge @"separatedLeftEdge"


/**
 other key
 */

#define Disable           @"disable"       //cell不可见
#define isShowAccessory   @"accessory"     //cell显示 '>'
#define ForbidSelect      @"forbidSelect"  //cell禁止点击
#define ShowSelectedStyle @"selectedStyle" //选中样式

@interface DTableSection : NSObject

//section 头部标题
@property (nonatomic, copy) NSString *headerTitle;

//section 尾部标题
@property (nonatomic, copy) NSString *footerTitle;

//section 头部高度
@property (nonatomic, assign) CGFloat headerHeight;

//section 尾部标题
@property (nonatomic, assign) CGFloat footerHeight;

//section
@property (nonatomic, strong) NSArray *rows;


- (instancetype)initWithDic:(NSDictionary *)dic;

+ (NSArray *)sectionsWithData:(NSArray *)data;


@end

@interface DTableRow : NSObject

//图片名称
@property (nonatomic, copy) NSString *imageName;

//标题
@property (nonatomic, strong) NSString *title;

//详细  这三个只有在使用系统的cell下生效
@property (nonatomic, copy) NSString *detailTitle;

//自定义cell名称
@property (nonatomic, copy) NSString *cellClassName;

//cell的点击事件名
@property (nonatomic, copy) NSString *cellActionName;

//cell行高
@property (nonatomic, assign) CGFloat rowHeight;

//分隔线距离左边的距离
@property (nonatomic, assign) CGFloat sepLeftEdge;

//是否显示 '>'箭头
@property (nonatomic, assign) BOOL showAccessory;

//是否能被选中
@property (nonatomic, assign) BOOL forbidSelected;

//选中时的样式
@property (nonatomic, assign) BOOL showSelectedStyle;

//数据
@property (nonatomic, strong) id data;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSArray *)rowsWithData:(NSArray *)data;

@end
