//
//  DSImageScrollView.m
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/8/15.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSImageScrollView.h"


@interface DSImageScrollView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL showProgress;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, readonly) BOOL itemDidLoad;

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, assign) BOOL panGesture;
@end

@implementation DSImageScrollView

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.delegate = self;
    self.bouncesZoom = YES;
    self.maximumZoomScale = 3;
    self.multipleTouchEnabled = YES;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.frame = [UIScreen mainScreen].bounds;
    self.delaysContentTouches = NO;
    self.canCancelContentTouches = YES;
    self.panGestureRecognizer.delegate = self;
    _imageContainerView = [[UIView alloc] init];
    _imageContainerView.clipsToBounds = YES;
    [self addSubview:_imageContainerView];
    
    _imageView = [[YYAnimatedImageView alloc] init];
    _imageView.clipsToBounds = YES;
    _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    [_imageContainerView addSubview:_imageView];
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.size = CGSizeMake(40, 40);
    _progressLayer.cornerRadius = 20;
    _progressLayer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.5].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(_progressLayer.bounds, 7, 7) cornerRadius:(40 / 2 - 7)];
    _progressLayer.path = path.CGPath;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    _progressLayer.lineWidth = 4;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [self.layer addSublayer:_progressLayer];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _progressLayer.center = CGPointMake(self.width / 2, self.height / 2);
}

- (void)setItem:(DSImageScrollItem *)item {
    if (_item == item)  return;
    _item = item;
    _itemDidLoad = NO;
    
    [self setZoomScale:1.0 animated:NO];
    self.maximumZoomScale = 1;
    
    [_imageView yy_cancelCurrentImageRequest];
    [_imageView.layer removePreviousFadeAnimation];
    
    _progressLayer.hidden = NO;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    
    [CATransaction commit];
    
    if (!_item) {
        _imageView.image = nil;
        return;
    }
    self.progressLayer.hidden = NO;
    _progressLayer.strokeEnd  = 0.01;
    __weak typeof(self) wself = self;
    [_imageView yy_setImageWithURL:item.largeImageURL placeholder:item.thumbImage options:YYWebImageOptionAvoidSetImage progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        __strong typeof(wself) sself = wself;
        if (!sself) return ;
        CGFloat progress = receivedSize / (float)expectedSize;
        progress = progress < 0.01 ? 0.01 : progress > 1 ? 1 : progress;
        if (isnan(progress)) progress = 0;
        self.progressLayer.strokeEnd = progress;
        
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        __strong typeof(wself) sself = wself;
        if (!sself) return;
        self.progressLayer.hidden = YES;
        if (stage == YYWebImageStageFinished) {
            sself.maximumZoomScale = 3;
            if (image) {
                _imageView.image = image;
                sself->_itemDidLoad = YES;
                [sself resizeSubviewSize];
                [sself.imageView.layer addFadeAnimationWithDuration:0.1 curve:UIViewAnimationCurveLinear];
            }
        }
    }];
    [self resizeSubviewSize];
}

- (void)resizeSubviewSize {
    
    _imageContainerView.origin = CGPointZero;
    _imageContainerView.width = self.width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.height / self.width) {
        _imageContainerView.height = floor(image.size.height / (image.size.width / self.width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.width;
        if (height < 1 || isnan(height)) height = self.height;
        height = floor(height);
        _imageContainerView.height = height;
        _imageContainerView.centerY = self.height / 2;
    }
    if (_imageContainerView.height > self.height && _imageContainerView.height - self.height <= 1) {
        _imageContainerView.height = self.height;
    }
    self.contentSize = CGSizeMake(self.width, MAX(_imageContainerView.height, self.height));
    [self scrollRectToVisible:self.bounds animated:NO];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _imageView.frame = _imageContainerView.bounds;
    [CATransaction commit];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = _imageContainerView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}






/**
 这下面主要是为了处理长图滑动的时候手势冲突。解决方法很粗糙的。。。没有像微信那样在滑动到顶部后 手势切换了。(请教！！)
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (_item.cancelPan) return YES;
    if (_panGesture) {
        _panGesture = NO;
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_item.cancelPan) return;
    UITouch *touch = [touches anyObject];
    _startPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_item.cancelPan) return;
    UITouch *touch = [touches anyObject];
    _currentPoint = [touch locationInView:self];
    if (_startPoint.y - _currentPoint.y < 0 && self.contentOffset.y < 10) {
        _panGesture = YES; //禁用滑动手势
    }

}


@end
