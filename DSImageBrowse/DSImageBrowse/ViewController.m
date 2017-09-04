//
//  ViewController.m
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/7/15.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "ViewController.h"

#import "DTableDelegate.h"
#import "DTableViewData.h"
#import "DSDefaultViewController.h"
#import "DSChatViewController.h"
#import "DSWebImageViewController.h"
@interface ViewController ()

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) DTableDelegate *delegator;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    self.title = @"图片浏览Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];

    __weak typeof(self) wself = self;
    self.delegator = [[DTableDelegate alloc] initWithTableViewData:^NSArray *{
        return wself.data;
    }];
    self.tableView.delegate = self.delegator;
    self.tableView.dataSource = self.delegator;
}

- (void)initData {
    NSArray *data = @[
                      @{
                          RowData : @[
                                  @{
                                      Title : @"九宫格模式",
                                      CellAction : @"onClick",
                                      isShowAccessory : @(YES),
                                      },
                                  @{
                                      Title : @"聊天浏览模式",
                                      CellAction : @"onChatClick",
                                      isShowAccessory : @(YES),
                                      },
                                  @{
                                      Title : @"网页模式",
                                      CellAction : @"onWebClick",
                                      isShowAccessory : @(YES),
                                      }
                                  ],
                          }
                      ];
    self.data = [DTableSection sectionsWithData:data];
}


- (void)onClick {
    
    DSDefaultViewController *vc = [[DSDefaultViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onChatClick {
    
    DSChatViewController *vc = [[DSChatViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)onWebClick {
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        int Width = arc4random() % 114 + 1000;
        int Heigth = arc4random() % 114 + 1000;
        NSString *url = [NSString stringWithFormat:@"https://unsplash.it/%d/%d?image=%d",Width,Heigth,arc4random() % 100];
        [images addObject:url];
    }
    DSWebImageViewController *vc = [[DSWebImageViewController alloc] initWithImages:images currentImage:images[arc4random() % 20]];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
