//
//  DTableViewData.m
//  DTableViewDemo
//
//  Created by 黄铭达 on 2017/4/25.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DTableViewData.h"


#define DefaultRowHeight     44.f
#define DefaultHeaderHeight  20.f
#define DefaultFooterHeight  5.f

@implementation DTableSection

- (instancetype)initWithDic:(NSDictionary *)dic {
    if ([dic[Disable] boolValue]) {
        return nil;
    }
    self = [super init];
    if (self) {
        _headerTitle  = dic[HeaderTitle];
        _footerTitle  = dic[FooterTitle];
        _headerHeight = [dic[HeaderHeight] floatValue] ? [dic[HeaderHeight] floatValue] : DefaultHeaderHeight;
        _footerHeight = [dic[FooterHeight] floatValue] ? [dic[FooterHeight] floatValue] : DefaultFooterHeight;
        _rows         = [DTableRow rowsWithData:dic[RowData]];
        
    }
    return self;
}

+ (NSArray *)sectionsWithData:(NSArray *)data {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:data.count];
    for (NSDictionary *dic in data) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            DTableSection *section = [[DTableSection alloc] initWithDic:dic];
            if (section) {
                [array addObject:section];
            }
        }
    }
    return array;
}

@end


@implementation DTableRow

- (instancetype)initWithDict:(NSDictionary *)dict {
    if ([dict[Disable] boolValue]) {
        return nil;
    }
    self = [super init];
    if (self) {
        _imageName         = dict[ImageName];
        _title             = dict[Title];
        _detailTitle       = dict[DetaillTitle];
        _cellClassName     = dict[CellClass];
        _cellActionName    = dict[CellAction];
        _rowHeight         = [dict[RowHeight] floatValue]? [dict[RowHeight] floatValue] : DefaultRowHeight;
        _data              = dict[Data];
        _sepLeftEdge       = [dict[SeparatedLeftEdge] floatValue];
        _showAccessory     = [dict[ShowSelectedStyle] boolValue];
        _forbidSelected    = [dict[ForbidSelect] boolValue];
        _showSelectedStyle = [dict[ShowSelectedStyle] boolValue];
    }
    return self;
}

+ (NSArray *)rowsWithData:(NSArray *)data {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:data.count];
    for (NSDictionary *dic in data) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            DTableRow *row = [[DTableRow alloc] initWithDict:dic];
            if (row) {
                [array addObject:row];
            }
        }
    }
    return array;
}

@end
