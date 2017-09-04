//
//  DSDefaultViewController.m
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/9/1.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSDefaultViewController.h"

#import "DSImageBrowse.h"
#import "DSImageDemoCell.h"
#import <YYWebImageManager.h>
#import "YYImageCoder.h"
#import "DSDemoLayout.h"
#import "DSDemoModel.h"

@interface DSDefaultViewController ()<UITableViewDelegate,UITableViewDataSource,DSImageBrowseCellDelegate,UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *layouts;


@property (nonatomic, assign) BOOL supportsForceTouch;
@property (nonatomic, strong) NSMutableDictionary *previews;

@property (nonatomic, assign) int random;
@end

@implementation DSDefaultViewController

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
    
    //随便模拟一下数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int i = 0; i < 99; i += _random) {
            _random = arc4random() % 8 + 1;
            NSMutableArray *dataArray = [NSMutableArray array];
            for (int j = i; j < i + _random; j++) {
                int thumbnailWidth = arc4random() % 114 + 100;
                int thumbnailHeigth = arc4random() % 114 + 100;
//                int thumbnailWidth = 100;
//                int thumbnailHeigth = 300;
                int random = arc4random() % 5 + 1;
//                int random = 3;
                int largeWidth = thumbnailWidth * random;
                int largeHeight = thumbnailHeigth * random;
                NSString *thumbnail = [NSString stringWithFormat:@"https://unsplash.it/%d/%d?image=%d",thumbnailWidth,thumbnailHeigth,j];
                NSString *large = [NSString stringWithFormat:@"https://unsplash.it/%d/%d?image=%d",largeWidth,largeHeight,j];
                //                -------------------
                DSImagesData *imagesData =[[DSImagesData alloc] init];
                imagesData.thumbnailImage.width = thumbnailWidth;
                imagesData.thumbnailImage.height = thumbnailHeigth;
                imagesData.thumbnailImage.url = [NSURL URLWithString:thumbnail];
                imagesData.largeImage.width = largeWidth;
                imagesData.largeImage.height = largeHeight;
                imagesData.largeImage.url = [NSURL URLWithString:large];
                
                [dataArray addObject:imagesData];
            }
            NSString *desc = [NSString stringWithFormat:@"这是模拟数据这是模拟数据这是模拟数据这是模拟数据%d",arc4random() % 1000 + 1];
            
            DSDemoModel *model = [[DSDemoModel alloc] init];
            model.imageDataArray = dataArray;
            model.describe = desc;
            
            DSDemoLayout *layout = [[DSDemoLayout alloc] initWithDSDemoMode:model];
            [_layouts addObject:layout];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator removeFromSuperview];
            self.title = @"九宫格浏览方式";
            self.navigationController.view.userInteractionEnabled = YES;
            [_tableView reloadData];
        });
    });
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _layouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cell";
    DSImageDemoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[DSImageDemoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    [cell setLayout:_layouts[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((DSDemoLayout *)_layouts[indexPath.row]).cellHeight;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)didClick:(DSImageBrowseView *)imageView atIndex:(NSInteger)index {
    
    NSLog(@"点击第%ld图片",index + 1);
    [self present:imageView index:index];
}

//缩略图的时候长按
- (void)longPress:(DSImageBrowseView *)imageView atIndex:(NSInteger)index {
    
    NSLog(@"长按第%ld图片",index + 1);
}


- (void)present:(DSImageBrowseView *)imageView index:(NSInteger)index{
    UIView *fromView = nil;
    NSMutableArray *items = [NSMutableArray array];
    NSArray<DSImagesData *> *imagesData = imageView.layout.imagesData;
    
    for (NSUInteger i = 0,max = imagesData.count; i < max ;i++) {
        DSThumbnailView *imgView = imageView.imageViews[i];
        DSImagesData *imageData = imagesData[i];
        
        DSImageScrollItem * item = [[DSImageScrollItem alloc] init];
        item.thumbView = imgView;
        item.largeImageURL = imageData.largeImage.url;
        item.largeImageSize = CGSizeMake(imageData.largeImage.width, imageData.largeImage.height);
        [items addObject:item];
        if (i == index) {
            fromView = imgView;
        }
    }
    DSImageShowView *scrollView = [[DSImageShowView alloc] initWithItems:items type:DSImageShowTypeDefault];
    //    scrollView.blurEffectBackground = YES;
    [scrollView presentfromImageView:fromView toContainer:self.navigationController.view index:index animated:YES completion:nil];
    scrollView.longPressBlock = ^(UIImageView *imageView) {
        // try to save original image data if the image contains multi-frame (such as GIF/APNG)
        id imageItem = [imageView.image yy_imageDataRepresentation];
        YYImageType type = YYImageDetectType((__bridge CFDataRef _Nonnull)(imageItem));
        if (type != YYImageTypePNG && type != YYImageTypeJPEG && type != YYImageTypeGIF) {
            imageItem = imageView;
        }
        //todo
    };

}

/**
 如果要支持3DTouch 请在自己项目中对应实现以下方法
 */

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.supportsForceTouch) {
        for (UIView *view in cell.subviews) {
            if ([view isKindOfClass:[DSImageBrowseView class]]) {
                for (UIView *imageView in view.subviews) {
                    id<UIViewControllerPreviewing> preview = [self registerForPreviewingWithDelegate:self sourceView:imageView];
                    [self.previews setObject:preview forKey:@(indexPath.row)];
                }
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
    
    DSThumbnailView *sourceView = (DSThumbnailView *)[previewingContext sourceView];
    DSImageBrowseView *imageBrowseView = (DSImageBrowseView *)sourceView.superview;
    NSInteger index = 0;
    for (NSInteger i = 0 ; i < imageBrowseView.imageViews.count; i++ ) {
        if (sourceView == imageBrowseView.imageViews[i]) {
            index = i;
            break;
        }
    }
    
    DSImageLayout *layout = imageBrowseView.layout;
    DSImagesData *imagesData = layout.imagesData[index];
    
    DSImageScrollItem * item = [[DSImageScrollItem alloc] init];
    item.thumbView = sourceView;
    item.largeImageURL = imagesData.largeImage.url;
    item.largeImageSize = CGSizeMake(imagesData.largeImage.width, imagesData.largeImage.height);
    
    DSForceTouchController *vc = [[DSForceTouchController alloc] init];
    vc.actionTitles = @[@"赞",@"保存"].mutableCopy;
    vc.actionBlock = ^(NSInteger index) {
        // to do
        NSLog(@"%ld",index);
    };
    NSString *imageKey = [[YYWebImageManager sharedManager] cacheKeyForURL:item.largeImageURL];
    UIImage * image = [[YYWebImageManager sharedManager].cache getImageForKey:imageKey withType:YYImageCacheTypeAll];
    CGFloat maxWidht = self.view.width - 40;
    CGFloat maxHeight = self.view.height - 200;
    CGFloat height = 0, width = 0;
    if (!image) {
        //单张图片的时候
        if (layout.imagesData.count == 1) {
            if (layout.imageSize.height / layout.imageSize.width > maxHeight / maxWidht) {
                width = layout.imageSize.width / layout.imageSize.height * maxHeight;
                height = maxHeight;
            } else {
                width = maxWidht;
                height = layout.imageSize.height / layout.imageSize.width * maxWidht;
            }
            vc.imageRect = CGRectMake(0,0,width, height);
            vc.preferredContentSize = CGSizeMake(width, height);
        }else {
            vc.imageRect = CGRectMake(0,0,maxWidht, maxWidht);
            vc.preferredContentSize = CGSizeMake(maxWidht, maxWidht);
        }
        vc.item = item;
        
    }else {
        //单张图片的时候
        if (layout.imagesData.count == 1) {
            if (layout.imageSize.height / layout.imageSize.width > maxHeight / maxWidht) {
                width = layout.imageSize.width / layout.imageSize.height * maxHeight;
                height = maxHeight;
            } else {
                width = maxWidht;
                height = layout.imageSize.height / layout.imageSize.width * maxWidht;
            }
        }else {
            if(image.size.height / image.size.width > maxHeight / maxWidht) {
                width = maxWidht;
                height = MIN(image.size.height / image.size.width * maxWidht, maxHeight);
            }else {
                width = maxWidht;
                height = image.size.height / image.size.width * maxWidht;
            }
        }
        
        vc.preferredContentSize = CGSizeMake(width, height);
        vc.imageRect = CGRectMake(0, 0, width, height);
        vc.imageView.image = image;
    }
    
    
    return vc;
}

//最终界面
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    DSThumbnailView *sourceView = (DSThumbnailView *)[previewingContext sourceView];
    DSImageBrowseView *imageBrowseView = (DSImageBrowseView *)sourceView.superview;
    NSInteger index = 0;
    for (NSInteger i = 0 ; i < imageBrowseView.imageViews.count; i++ ) {
        if (sourceView == imageBrowseView.imageViews[i]) {
            index = i;
            break;
        }
    }
    [self present:imageBrowseView index:index];
}

@end
