//
//  DTableDelegate.m
//  DTableViewDemo
//
//  Created by 黄铭达 on 2017/4/25.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DTableDelegate.h"
#import "DTableViewData.h"
#import "DTableViewCell.h"
#import "UIView+DSCategory.h"


#define D_SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define SepViewTag 1000

static NSString *DefaultTableCell = @"UITableViewCell";

@interface DTableDelegate ()

@property (nonatomic ,copy) NSArray *(^DDataReceiver)(void);

@end

@implementation DTableDelegate

- (instancetype)initWithTableViewData:(NSArray *(^)(void))data {
    self = [super init];
    if (self) {
        _DDataReceiver = data;
        _defaultSeparatorLeftEdge = SeparatedLineLeft;
    }
    return self;
}

- (NSArray *)data {
    return self.DDataReceiver();
}

#pragma mark - UITabelViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DTableSection *tableSection = self.data[section];
    return tableSection.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTableSection *tableSection = self.data[indexPath.section];
    DTableRow *tableRow = tableSection.rows[indexPath.row];
    NSString *identity = tableRow.cellClassName.length ? tableRow.cellClassName : DefaultTableCell;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        Class class = NSClassFromString(identity);
        cell = [[class alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity];
        //自己实现的下划线,要把系统的隐藏了
        UIView *sep = [[UIView alloc] initWithFrame:CGRectZero];
        sep.tag = SepViewTag;
        sep.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        sep.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:sep];
    }
    if (![cell respondsToSelector:@selector(refreshData:tableView:)]) {
        UITableViewCell *defaultCell = (UITableViewCell *)cell;
        [self refreshData:tableRow cell:defaultCell];
    }else {
        [(id<DTableViewCell>)cell refreshData:tableRow tableView:tableView];
    }
    
    cell.accessoryType = tableRow.showAccessory ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    cell.selectionStyle = tableRow.showSelectedStyle ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
    
    return cell;
}

#pragma mark - UITableViewDelegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTableSection *tableSection = self.data[indexPath.section];
    DTableRow *tableRow = tableSection.rows[indexPath.row];
    return tableRow.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DTableSection *tableSection = self.data[indexPath.section];
    DTableRow *tableRow = tableSection.rows[indexPath.row];
    if (!tableRow.forbidSelected) {
        UIViewController *vc = [tableView viewController];
        NSString *actionName = tableRow.cellActionName;
        if (actionName.length) {
            SEL sel = NSSelectorFromString(actionName);
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            D_SuppressPerformSelectorLeakWarning([vc performSelector:sel withObject:cell]);
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //这里的cell已经有了正确的bounds
    //不在cellForRow的地方设置分割线是因为在ios7下，0.5像素的view利用autoResizeMask调整布局有问题，会导致显示不出来，ios6,ios8均正常。
    DTableSection *tableSection = self.data[indexPath.section];
    DTableRow *tableRow = tableSection.rows[indexPath.row];
    UIView *sep = [cell viewWithTag:SepViewTag];
    sep.backgroundColor = [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:239 / 255.0 alpha:1];
    CGFloat sepHeight = 0.5f;
    CGFloat sepWidth;
    if (tableRow.sepLeftEdge) {
        sepWidth = cell.width - tableRow.sepLeftEdge;
    }else {
        DTableSection *section = self.data[indexPath.section];
        //最后一行不显示
        if (indexPath.row == section.rows.count - 1) {
            sepWidth = 0;
        }else {
            sepWidth = cell.width - self.defaultSeparatorLeftEdge;
        }
    }
    
    sepWidth = sepWidth > 0 ? sepWidth : 0;
    sep.frame = CGRectMake(cell.width - sepWidth, cell.height - sepHeight, sepWidth, sepHeight);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    DTableSection *tableSection = self.data[section];
    return tableSection.headerTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    DTableSection *tableSection = self.data[section];
    if (tableSection.headerTitle.length != 0) {
        return [tableSection.headerTitle sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.f]}].height;
    }else {
        return tableSection.headerHeight;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    DTableSection *tableSection = self.data[section];
    return tableSection.footerTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    DTableSection *tableSection = self.data[section];
    if (tableSection.footerTitle.length != 0) {
        return [tableSection.footerTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]}].height + 25;
    }else {
        return tableSection.footerHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DTableSection *tableSection = self.data[section];
    if (tableSection.headerTitle.length) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    DTableSection *tableSection = self.data[section];
    if (tableSection.footerTitle.length) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

#pragma mark - 默认cell的数据加载
- (void)refreshData:(DTableRow *)rowData cell:(UITableViewCell *)cell {
    cell.textLabel.text = rowData.title;
    cell.detailTextLabel.text = rowData.detailTitle;
    cell.imageView.image = [UIImage imageNamed:rowData.imageName];
}


@end
