//
//  DSImageShowView.m
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/8/4.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSImageShowView.h"
#import "UIImage+DSCategory.h"
#import "UIScrollView+DSCategory.h"
#import <QuartzCore/QuartzCore.h>

#define kPadding 20
#define DS_CLAMP(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))


@interface DSImageShowView () <UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, weak)   UIView *fromView;
@property (nonatomic, weak)   UIView *toContainerView;
@property (nonatomic, strong) UIView *hiddenView;
@property (nonatomic, strong) UIImageView *blurBackground;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *scrollViews;
@property (nonatomic, strong) UIPageControl *pager;
@property (nonatomic, assign) BOOL isPresented;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGPoint panGestureBeginPoint;
@property (nonatomic, assign) DSImageShowType type;
@end
@implementation DSImageShowView

- (instancetype)initWithItems:(NSArray <DSImageScrollItem *>*)items type:(DSImageShowType)type{
    self = [super init];
    if (items.count == 0) return nil;
    
    if (!type) type = DSImageShowTypeDefault;
    _type = type;
    _items = items.copy;
    _scrollViews = [NSMutableArray array];
    _blurEffectBackground = NO;

    self.backgroundColor = [UIColor clearColor];
    self.frame = [UIScreen mainScreen].bounds;
    self.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.delegate = self;
    doubleTap.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:doubleTap];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    press.delegate = self;
    [self addGestureRecognizer:press];
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(- kPadding / 2, 0, self.width + kPadding, self.height)];
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.alwaysBounceHorizontal = items.count > 1;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.delegate = self;
    [self addGestureRecognizer:pan];
    _panGesture = pan;
    _blurBackground = [[UIImageView alloc] init];
    _blurBackground.frame = self.bounds;
    _blurBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:_blurBackground];
    [self addSubview:_contentView];
    [_contentView addSubview:_scrollView];

    if (type == DSImageShowTypeDefault) {
        _pager = [[UIPageControl alloc] init];
        _pager.hidesForSinglePage = YES;
        _pager.userInteractionEnabled = NO;
        _pager.width = self.width - 36;
        _pager.height = 10;
        _pager.center = CGPointMake(self.width / 2 , self.height - 18);
        _pager.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [_contentView addSubview:_pager];
    }

    return self;
}

- (void)presentfromImageView:(UIView *)fromView toContainer:(UIView *)toContainer index:(NSInteger)index animated:(BOOL)animated completion:(void (^)(void))completion {
    if (!toContainer || _type == DSImageShowtypeWebImage) return;
    _fromView = fromView;
    _toContainerView = toContainer;
    NSInteger page = 0;
    if (_type == DSImageShowTypeChat) {
        page = index;
        if (index < 0) page = 0;
    }else {
        page = index;
        if (index < 0 || index > 8) page = 0;
    }
    _hiddenView = fromView;
    _hiddenView.hidden = YES;
    if (_blurEffectBackground) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.frame = _blurBackground.bounds;
        [_blurBackground addSubview:effectView];
    }else {
        _blurBackground.image = [UIImage imageWithColor:[UIColor blackColor] size:CGSizeMake(1, 1)];
    }
    
    self.size = _toContainerView.size;
    self.blurBackground.alpha = 0;
    self.pager.numberOfPages = self.items.count;
    self.pager.currentPage = page;
    [_toContainerView addSubview:self];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width * self.items.count, _scrollView.height);
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.width * page, 0, _scrollView.width, _scrollView.height) animated:NO];
    [self scrollViewDidScroll:_scrollView];
    
    [UIView setAnimationsEnabled:YES];
    NSInteger currentPage = self.currentPage;
    DSImageScrollView *scrollView = [self scrollViewForPage:currentPage];
    DSImageScrollItem *item = _items[currentPage];
    
    if (!item.thumbClippedToTop) {
        NSString *imageKey = [[YYWebImageManager sharedManager] cacheKeyForURL:item.largeImageURL];
        if ([[YYWebImageManager sharedManager].cache getImageForKey:imageKey withType:YYImageCacheTypeMemory]) {
            scrollView.item = item;
        }
    }
    
    if (!scrollView.item) {
        scrollView.imageView.image = item.thumbImage;
        [scrollView resizeSubviewSize];
    }
    
    if (!item.isVisibleThumbView) {
        if (CGRectEqualToRect(_fromRect,CGRectZero)) {
            _fromRect = CGRectMake((self.width - 100) / 2, (self.height - 100) / 2, 100, 100);
        }
        CGRect fromFrame = _fromRect;
        [self presentAnimation:scrollView fromRect:fromFrame completion:^{
            if (completion) completion();
        }];
    }else {
        if (item.thumbClippedToTop) {
            CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:scrollView];
            CGRect originFrame = scrollView.imageContainerView.frame;
            CGFloat scale = fromFrame.size.width / scrollView.imageContainerView.width;
            
            scrollView.imageContainerView.centerX = CGRectGetMidX(fromFrame);
            scrollView.imageContainerView.height = fromFrame.size.height / scale;
            scrollView.imageContainerView.layer.transformScale = scale;
            scrollView.imageContainerView.centerY = CGRectGetMidY(fromFrame);
            _blurBackground.alpha = 1;
            
            float oneTime = animated ? 0.25 : 0;
            _scrollView.userInteractionEnabled = NO;
            [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelStatusBar;
            [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                scrollView.imageContainerView.layer.transformScale = 1;
                scrollView.imageContainerView.frame = originFrame;
                _pager.alpha = 1;
            } completion:^(BOOL finished) {
                _isPresented = YES;
                [self scrollViewDidScroll:_scrollView];
                _scrollView.userInteractionEnabled = YES;
                if (completion) completion();
            }];
        } else {
            CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:scrollView.imageContainerView];
            [self presentAnimation:scrollView fromRect:fromFrame completion:^{
                if (completion) completion();
            }];
        }
    }
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if (_type == DSImageShowtypeWebImage) return;
    [UIView setAnimationsEnabled:YES];
    NSInteger currentPage = self.currentPage;
    DSImageScrollView *scrollView = [self scrollViewForPage:currentPage];
    DSImageScrollItem *item = _items[currentPage];
    UIView *fromView = item.thumbView;
    
    [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelNormal;
    if (!item.isVisibleThumbView) {
        [self NoOriginalThumbViewAnimation:^{
            if (completion) completion();
        }];
        return;
    }
    
    BOOL isFromImageClipped = fromView.layer.contentsRect.size.height < 1;
    [self animatedBefore:isFromImageClipped imageScrollView:scrollView];
    
    [UIView animateWithDuration:animated ? 0.2 : 0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        _pager.alpha = 0.0;
        _blurBackground.alpha = 0.0;
        [self animatedAfter:isFromImageClipped imageScrollView:scrollView fromView:fromView];
    }completion:^(BOOL finished) {
        _hiddenView.hidden = NO;
        [UIView animateWithDuration:animated ? 0.15 : 0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            scrollView.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            [self removeFromSuperview];
            if (completion) completion();
        }];
    }];
    
    
}

- (void)dismiss {
    if (_type != DSImageShowtypeWebImage) {
        [self dismissAnimated:YES completion:nil];
    }else {
        [self cancelAllImageLoad];
        _isPresented = NO;
        [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelNormal;
        if ([self.viewController respondsToSelector:@selector(navigationController)]) {
            [self.viewController.navigationController popViewControllerAnimated:YES];
        }else {
            [self.viewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)cancelAllImageLoad {
    [_scrollViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [((DSImageScrollView *)obj).imageView yy_cancelCurrentImageRequest];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateScrollViewForReuse];
    
    CGFloat floatPage = _scrollView.contentOffset.x / _scrollView.width;
    NSInteger page    = floatPage + 0.5;
    //预加载
    for (NSInteger i = page - 1; i <= page + 1; i++) {
        if (i >= 0 && i < self.items.count) {
            DSImageScrollView *scrollView = [self scrollViewForPage:i];
            if (!scrollView) {
                DSImageScrollView *scrollView = [self dequeueReusableScrollView];
                scrollView.page = i;
                scrollView.left = (self.width + kPadding) * i + kPadding / 2;
                if (_isPresented) {
                    scrollView.item = self.items[i];
                }
                [self.scrollView addSubview:scrollView];
            } else {
                if (_isPresented && !scrollView.item) {
                    scrollView.item = self.items[i];
                }
            }
        }
    }
    
    NSInteger intPage = floatPage + 0.5;
    intPage = intPage < 0 ? 0 : intPage >= _items.count ? (int)_items.count - 1 : intPage;
    _pager.currentPage = intPage;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _hiddenView.hidden = NO;
    DSImageScrollItem *item = _items[self.currentPage];
    _hiddenView = item.thumbView;
    _hiddenView.hidden = YES;
}


- (void)updateScrollViewForReuse {
    
    for (DSImageScrollView *scrollView in _scrollViews) {
        if (scrollView.superview) {
            if (scrollView.left > _scrollView.contentOffset.x + _scrollView.width * 2 || scrollView.right < _scrollView.contentOffset.x - _scrollView.width) {
                [scrollView removeFromSuperview];
                scrollView.page = -1;
                scrollView.item = nil;
            }
        }
    }
}

- (DSImageScrollView *)dequeueReusableScrollView {
    
    DSImageScrollView *scrollView = nil;
    for (scrollView in _scrollViews) {
        if (!scrollView.superview) {
            return scrollView;
        }
    }
    
    scrollView = [[DSImageScrollView alloc] init];
    scrollView.frame = self.bounds;
    scrollView.imageContainerView.frame = self.bounds;
    scrollView.imageView.frame = scrollView.bounds;
    scrollView.page = -1;
    scrollView.item = nil;
    [_scrollViews addObject:scrollView];
    return scrollView;
}

- (DSImageScrollView *)scrollViewForPage:(NSInteger)page {
    for (DSImageScrollView *scrollView in _scrollViews) {
        if (scrollView.page == page) {
            return scrollView;
        }
    }
    return nil;
}

- (NSInteger)currentPage {
    NSInteger page = _scrollView.contentOffset.x / _scrollView.width + 0.5;
    if (page >= _items.count) page = (NSInteger)_items.count - 1;
    if (page < 0) page = 0;
    return page;
}


- (void)doubleTap:(UITapGestureRecognizer *)doubleTap {
    if (!_isPresented) return;
    DSImageScrollView *scrollView = [self scrollViewForPage:self.currentPage];
    if (scrollView) {
        if (scrollView.zoomScale > 1) {
            [scrollView setZoomScale:1 animated:YES];
        }else {
            CGPoint touchPoint = [doubleTap locationInView:scrollView.imageView];
            CGFloat newZoomScale = scrollView.maximumZoomScale;
            CGFloat xsize = self.width / newZoomScale;
            CGFloat ysize = self.height / newZoomScale;
            [scrollView zoomToRect:CGRectMake(touchPoint.x - xsize / 2, touchPoint.y - ysize / 2, xsize, ysize) animated:YES];
        }
    }
}

- (void)longPress {
    if (!_isPresented) return;
    
    DSImageScrollView *scrollView = [self scrollViewForPage:self.currentPage];
    if (!scrollView.imageView.image) return;
    if (_longPressBlock) {
        self.longPressBlock(scrollView.imageView);
    }
}


- (void)pan:(UIPanGestureRecognizer *)pan {
    if (_type == DSImageShowtypeWebImage) return;
    NSInteger currentPage = self.currentPage;
    DSImageScrollView *scrollView = [self scrollViewForPage:currentPage];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            if (_isPresented) {
                _panGestureBeginPoint = [pan locationInView:self];
            }else {
                _panGestureBeginPoint = CGPointZero;
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            CGPoint p = [pan locationInView:self];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            
            CGFloat deltaX = p.x - _panGestureBeginPoint.x;
            _scrollView.top = deltaY;
            _scrollView.left = - kPadding / 2 + deltaX;
            
            CGFloat alphaDelta = 160;
            CGFloat alpha = (alphaDelta - fabs(deltaY) + 50) / alphaDelta;
            alpha = DS_CLAMP(alpha, 0, 1);
            
            CGFloat scale = self.height / (fabs(deltaY) + self.height);
            if (alpha < 0.95) {
                [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelNormal;
            }else {
                [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelStatusBar;
            }
            
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
                _blurBackground.alpha = alpha;
                scrollView.layer.transformScale = scale;
            } completion:nil];
            
        } break;
        case UIGestureRecognizerStateEnded:
            if(_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            CGPoint v = [pan velocityInView:self];
            CGPoint p = [pan locationInView:self];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            
            if (fabs(v.y) > 1000 || fabs(deltaY) > 120) {

                BOOL moveToTop = (v.y < - 50 || (v.y < 50 && deltaY < 0));
                CGFloat vy = fabs(v.y);
                if (vy < 1) vy = 1;
                CGFloat duration = (moveToTop ? _scrollView.bottom : self.height - _scrollView.top) / vy;
                duration *= 0.8;
                duration = DS_CLAMP(duration, 0.05, 0.3);
                DSImageScrollItem *item = _items[currentPage];
                UIView *fromView = item.thumbView;
                [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelNormal;
                if (!item.isVisibleThumbView) {
                    [self NoOriginalThumbViewAnimation:nil];
                    return;
                }
                BOOL isFromImageClipped = fromView.layer.contentsRect.size.height < 1;
                [self animatedBefore:isFromImageClipped imageScrollView:scrollView];
                
                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState  animations:^{
                    _scrollView.top = 0;
                    _scrollView.left = - kPadding / 2;
                    scrollView.layer.transformScale = 1;
                    [self animatedAfter:isFromImageClipped imageScrollView:scrollView fromView:fromView];
                } completion:^(BOOL finished) {
                    _blurBackground.alpha = 0;
                    _pager.alpha = 0;
                    _hiddenView.hidden = NO;
                    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    } completion:^(BOOL finished) {
                        scrollView.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
                        [self removeFromSuperview];
                    }];
                }];
                
            } else {
                [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelStatusBar;
                [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:v.y / 1000 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                    _scrollView.top = 0;
                    _scrollView.left = - kPadding / 2;
                    _blurBackground.alpha = 1;
                    _pager.alpha = 1;
                    scrollView.layer.transformScale = 1;
                } completion:^(BOOL finished) {
                }];
            }
            break;
        case UIGestureRecognizerStateCancelled: {
            _scrollView.top = 0;
            _blurBackground.alpha = 1;
            scrollView.left = - kPadding / 2;
            scrollView.layer.transformScale = 1;
            [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelStatusBar;
        }
        default:
            break;
    }
}



#pragma mark ---  animation

// dismiss animation before
- (void)animatedBefore:(BOOL)isFromImageClipped imageScrollView:(DSImageScrollView *)scrollView{
    
    [self cancelAllImageLoad];
    _isPresented = NO;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (isFromImageClipped) {
        CGRect frame = scrollView.imageContainerView.frame;
        scrollView.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0);
        scrollView.imageContainerView.frame = frame;
    }
    scrollView.progressLayer.hidden = YES;
    [CATransaction commit];
    
    if (isFromImageClipped) {
        [scrollView scrollToTopAnimated:NO];
    }

}

//dismiss animation after
- (void)animatedAfter:(BOOL)isFromImageClipped imageScrollView:(DSImageScrollView *)scrollView fromView:(UIView *)fromView {
    
    if (isFromImageClipped) {
        CGRect fromFrame = [fromView convertRect:fromView.bounds toView:scrollView];
        CGFloat scale = fromFrame.size.width / scrollView.imageContainerView.width * scrollView.zoomScale;
        CGFloat height = fromFrame.size.height / fromFrame.size.width * scrollView.imageContainerView.width;
        if (isnan(height)) height = scrollView.imageContainerView.height;
        
        scrollView.imageContainerView.height = height;
        scrollView.imageContainerView.center = CGPointMake(CGRectGetMidX(fromFrame), CGRectGetMinY(fromFrame));
        scrollView.imageContainerView.layer.transformScale = scale;
        
    } else {
        CGRect fromFrame = [fromView convertRect:fromView.bounds toView:scrollView.imageContainerView];
        scrollView.imageContainerView.clipsToBounds = NO;
        scrollView.imageView.contentMode = fromView.contentMode;
        scrollView.imageView.frame = fromFrame;
    }
}

//present animation
- (void)presentAnimation:(DSImageScrollView *)scrollView fromRect:(CGRect)fromFrame completion:(void (^)(void))completion{
    scrollView.imageContainerView.clipsToBounds = NO;
    scrollView.imageView.frame = fromFrame;
    scrollView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _blurBackground.alpha = 1;
    [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelStatusBar;
    _scrollView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.18 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        scrollView.imageView.frame = scrollView.imageContainerView.bounds;
        scrollView.imageView.layer.transformScale = 1.01;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.18 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            scrollView.imageView.layer.transformScale = 1.0;
            _pager.alpha = 1;
        }completion:^(BOOL finished) {
            scrollView.imageContainerView.clipsToBounds = YES;
            _isPresented = YES;
            [self scrollViewDidScroll:_scrollView];
            _scrollView.userInteractionEnabled = YES;
            if (completion) completion();
        }];
    }];
}

//没有原始ThumbView的Rect的时候的动画效果
- (void)NoOriginalThumbViewAnimation:(void (^)(void))completion {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0.0;
        self.scrollView.layer.transformScale = 0.95;
        self.scrollView.alpha = 0;
        self.pager.alpha = 0;
        self.blurBackground.alpha = 0;
    }completion:^(BOOL finished) {
        self.scrollView.layer.transformScale = 1;
        [self removeFromSuperview];
        [self cancelAllImageLoad];
        if(completion) completion();
    }];
}



#pragma mark --- ShowWebImage

- (void)showWebImageIndex:(NSInteger)index {
    
    if (_type != DSImageShowtypeWebImage) return;
    NSInteger page = index;
    if (page < 0) page = 0;
    self.size = [UIScreen mainScreen].bounds.size;
    _scrollView.contentSize = CGSizeMake(_scrollView.width * self.items.count, _scrollView.height);
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.width * page, 0, _scrollView.width, _scrollView.height) animated:NO];
    [self scrollViewDidScroll:_scrollView];
    
    NSInteger currentpage = self.currentPage;
    DSImageScrollView *scrollView = [self scrollViewForPage:currentpage];
    DSImageScrollItem *item = _items[currentpage];

    NSString *imageKey = [[YYWebImageManager sharedManager] cacheKeyForURL:item.largeImageURL];
    if ([[YYWebImageManager sharedManager].cache getImageForKey:imageKey withType:YYImageCacheTypeMemory]) {
        scrollView.item = item;
    }
    if (!scrollView.item) {
        scrollView.imageView.image = item.thumbImage;
        [scrollView resizeSubviewSize];
    }
    
    [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelStatusBar;
    _isPresented = YES;
    _scrollView.userInteractionEnabled = YES;
    [self scrollViewDidScroll:_scrollView];
}

@end
