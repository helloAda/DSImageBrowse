//
//  DSWebImageViewController.m
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/9/4.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSWebImageViewController.h"
#import "DSImageShowView.h"
@interface DSWebImageViewController ()

@property (nonatomic, strong) NSArray   *images;
@property (nonatomic, copy)   NSString  *currentImage;
@property (nonatomic, assign) NSInteger index;
@end

@implementation DSWebImageViewController

- (instancetype)initWithImages:(NSArray <NSString *>*)images currentImage:(NSString *)currentImage {
    self = [super init];
    if (self) {
        _index = 0;
        _images = images;
        _currentImage = currentImage;
        for (int i = 0; i < images.count; i++) {
            if ([currentImage isEqualToString:images[i]]) {
                _index = i;
                break;
            }
        }
        self.view.backgroundColor = [UIColor blackColor];
    }
    return self;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *url in _images) {
        DSImageScrollItem *item = [[DSImageScrollItem alloc] init];
        item.cancelPan = YES;
        item.largeImageURL =[NSURL URLWithString:url];
        item.largeImageSize = CGSizeZero;
        [items addObject:item];
    }

    DSImageShowView *scrollView = [[DSImageShowView alloc] initWithItems:items type:DSImageShowtypeWebImage];
    [self.view addSubview:scrollView];
    [scrollView showWebImageIndex:_index];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


@end
