//
//  DSForceTouchController
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/8/14.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSForceTouchController.h"

@interface DSForceTouchController ()
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@end

@implementation DSForceTouchController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _actionTitles = [NSMutableArray array];
        _imageView = [[YYAnimatedImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        [self.view addSubview:_imageView];
        
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
        [_imageView.layer addSublayer:_progressLayer];
    }
    return self;
}

- (void)setImageRect:(CGRect)imageRect {
    _imageView.frame = imageRect;
    _progressLayer.center = CGPointMake(_imageView.width / 2, _imageView.height / 2);
}

- (void)setItem:(DSImageScrollItem *)item {
    _item = item;
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
    [_imageView yy_setImageWithURL:item.largeImageURL placeholder:item.thumbImage options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
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
            if (image) {
                [sself.imageView.layer addFadeAnimationWithDuration:0.1 curve:UIViewAnimationCurveLinear];
            }
        }
    }];
}

- (NSArray <id<UIPreviewActionItem>>*)previewActionItems {
    NSMutableArray *actions = [NSMutableArray array];
    if (_actionTitles.count > 4) return nil;
    for (NSInteger index = 0; index < _actionTitles.count; index ++) {
        NSString *title = _actionTitles[index];
        UIPreviewAction *action = [UIPreviewAction actionWithTitle:title style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
            if (self.actionBlock) {
                self.actionBlock(index);
            }
        }];
        [actions addObject:action];
    }
    return actions;
}



- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
