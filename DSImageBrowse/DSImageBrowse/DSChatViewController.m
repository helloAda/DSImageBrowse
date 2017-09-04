//
//  DSChatViewController.m
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/9/2.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSChatViewController.h"

#import "DSImageBrowse.h"
#import "DSImageDemoCell.h"
#import <YYWebImageManager.h>
#import "YYImageCoder.h"
#import "DSChatImageCell.h"

@interface DSChatViewController ()<UITableViewDelegate,UITableViewDataSource,DSImageBrowseCellDelegate,UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *layouts;


@property (nonatomic, assign) BOOL supportsForceTouch;
@property (nonatomic, strong) NSMutableDictionary *previews;

@end

@implementation DSChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.supportsForceTouch = [self.traitCollection respondsToSelector:@selector(forceTouchCapability)] && self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    
    _layouts = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    self.navigationController.view.userInteractionEnabled = NO;
    
    [self initDSImageBrowseView];
}

- (void)initDSImageBrowseView {
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.size = CGSizeMake(80, 80);
    indicator.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    indicator.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.670];
    indicator.clipsToBounds = YES;
    indicator.layer.cornerRadius = 6;
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 100; i ++) {
            NSMutableArray *dataArray = [NSMutableArray array];
            int thumbnailWidth = arc4random() % 114 + 100;
            int thumbnailHeigth = arc4random() % 114 + 100;
            //                int thumbnailWidth = 100;
            //                int thumbnailHeigth = 300;
            int random = arc4random() % 5 + 1;
            //                int random = 3;
            int largeWidth = thumbnailWidth * random;
            int largeHeight = thumbnailHeigth * random;
            int imageNum = arc4random() % 100;
            NSString *thumbnail = [NSString stringWithFormat:@"https://unsplash.it/%d/%d?image=%d",thumbnailWidth,thumbnailHeigth,imageNum];
            NSString *large = [NSString stringWithFormat:@"https://unsplash.it/%d/%d?image=%d",largeWidth,largeHeight,imageNum];
            
            DSImagesData *imagesData =[[DSImagesData alloc] init];
            imagesData.thumbnailImage.width = thumbnailWidth;
            imagesData.thumbnailImage.height = thumbnailHeigth;
            imagesData.thumbnailImage.url = [NSURL URLWithString:thumbnail];
            imagesData.largeImage.width = largeWidth;
            imagesData.largeImage.height = largeHeight;
            imagesData.largeImage.url = [NSURL URLWithString:large];
            [dataArray addObject:imagesData];
            DSImageLayout *layout = [[DSImageLayout alloc] initWithImageData:dataArray];
            [layout layout];
            [_layouts addObject:layout];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator removeFromSuperview];
            self.title = @"聊天浏览方式";
            self.navigationController.view.userInteractionEnabled = YES;
            [_tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:
             [NSIndexPath indexPathForRow:_layouts.count - 1 inSection:0]
                                  atScrollPosition: UITableViewScrollPositionBottom
                                          animated:NO];
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _layouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cell";
    DSChatImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[DSChatImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    [cell setLayout:_layouts[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableview heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return ((DSImageLayout *)_layouts[indexPath.row]).imageBrowseHeight;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)didClick:(DSImageBrowseView *)imageView atIndex:(NSInteger)index {
    [self present:imageView];
}

//缩略图的时候长按
- (void)longPress:(DSImageBrowseView *)imageView atIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(DSChatImageCell *)imageView.superview];
    NSInteger currentIndex = indexPath.row;
    NSLog(@"长按第%ld图片",currentIndex);
    
}


- (void)present:(DSImageBrowseView *)imageView{
    //这里应该根据你项目中实际情况的点击来处理，我这个方法传过来的值基本都用不上，这里只给出较无脑的处理方式。。。
    NSMutableArray *items = [NSMutableArray array];
    //获取当前可见的cell的indexPath 动画效果需要使用到缩略图。若只需要默认动画效果，这一步可以忽略。请参考下面注释
    NSArray *visibleCells = [self.tableView indexPathsForVisibleRows];
    
    //这里因为每个cell都是相当于图片cell,所以总共的cell就是_layouts的count.如果是实际中，应该判断一下cell中的消息类型
    for (NSInteger i = 0,max = _layouts.count; i < max; i++) {
        DSImageLayout *imageLayout = _layouts[i];
        DSImagesData * imageData = imageLayout.imagesData[0];
        DSImageScrollItem * item = [[DSImageScrollItem alloc] init];
        item.isVisibleThumbView = NO;
        item.largeImageURL = imageData.largeImage.url;
        item.largeImageSize = CGSizeMake(imageData.largeImage.width, imageData.largeImage.height);
        for (NSIndexPath *indexPath in visibleCells) {
            if (indexPath.row == i) {
                DSChatImageCell *cell = (DSChatImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                DSThumbnailView *thumbnail = ((DSImageBrowseView *)cell.subviews[1]).imageViews[0];
                item.thumbView = thumbnail;
                item.isVisibleThumbView = YES;
            }
        }
        [items addObject:item];
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(DSChatImageCell *)imageView.superview];
    NSInteger currentIndex = indexPath.row;
    UIView *fromView = ((DSImageScrollItem *)items[currentIndex]).thumbView;
    DSImageShowView *scrollView = [[DSImageShowView alloc] initWithItems:items type:DSImageShowTypeChat];
    [scrollView presentfromImageView:fromView toContainer:self.navigationController.view index:currentIndex animated:YES completion:nil];
    //长按
    scrollView.longPressBlock = ^(UIImageView *imageView) {
        //todo
        NSLog(@"长按%ld",currentIndex);
    };
}


/**
 如果要支持3DTouch 请在自己项目中对应实现以下方法
 */

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.supportsForceTouch) {
        for (UIView *view in cell.subviews) {
            if ([view isKindOfClass:[DSImageBrowseView class]]) {
                id<UIViewControllerPreviewing> preview = [self registerForPreviewingWithDelegate:self sourceView:view];
                [self.previews setObject:preview forKey:@(indexPath.row)];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.supportsForceTouch) {
        id<UIViewControllerPreviewing> preview = [self.previews objectForKey:@(indexPath.row)];
        [self unregisterForPreviewingWithContext:preview];
        [self.previews removeObjectForKey:@(indexPath.row)];
    }
}



//预览界面
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    DSImageBrowseView *sourceView = (DSImageBrowseView *)[previewingContext sourceView];
    DSChatImageCell *cell = (DSChatImageCell *)sourceView.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    DSImageLayout *layout = _layouts[indexPath.row];
    DSImagesData *imagesData = layout.imagesData[0];
    DSImageScrollItem * item = [[DSImageScrollItem alloc] init];
    item.thumbView = sourceView.imageViews[0];
    item.largeImageURL = imagesData.largeImage.url;
    item.largeImageSize = CGSizeMake(imagesData.largeImage.width, imagesData.largeImage.height);
    
    DSForceTouchController *vc = [[DSForceTouchController alloc] init];
    vc.actionTitles = @[@"赞",@"保存"].mutableCopy;
    vc.actionBlock = ^(NSInteger index) {
        // to do
        if (index == 0) {
            NSLog(@"赞了第%ld张图片",indexPath.row);
        }else {
            NSLog(@"保存第%ld张图片",indexPath.row);
            
        }
    };
    NSString *imageKey = [[YYWebImageManager sharedManager] cacheKeyForURL:item.largeImageURL];
    UIImage * image = [[YYWebImageManager sharedManager].cache getImageForKey:imageKey withType:YYImageCacheTypeAll];
    CGFloat maxWidht = self.view.width - 40;
    CGFloat maxHeight = self.view.height - 200;
    CGFloat height = 0, width = 0;
    if (!image) {
        if (layout.imageSize.height / layout.imageSize.width > maxHeight / maxWidht) {
            width = layout.imageSize.width / layout.imageSize.height * maxHeight;
            height = maxHeight;
        } else {
            width = maxWidht;
            height = layout.imageSize.height / layout.imageSize.width * maxWidht;
        }
        vc.item = item;
    }else {
        if (layout.imageSize.height / layout.imageSize.width > maxHeight / maxWidht) {
            width = layout.imageSize.width / layout.imageSize.height * maxHeight;
            height = maxHeight;
        } else {
            width = maxWidht;
            height = layout.imageSize.height / layout.imageSize.width * maxWidht;
        }
        vc.imageView.image = image;
    }
    vc.imageRect = CGRectMake(0,0,width, height);
    vc.preferredContentSize = CGSizeMake(width, height);
    return vc;
}

//最终界面
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
    DSImageBrowseView *sourceView = (DSImageBrowseView *)[previewingContext sourceView];
    [self present:sourceView];
}


- (void)dealloc {
#warning 有时候会出现控制器被销毁的情况，暂时没找到原因
    NSLog(@"dealloc");
}
@end
