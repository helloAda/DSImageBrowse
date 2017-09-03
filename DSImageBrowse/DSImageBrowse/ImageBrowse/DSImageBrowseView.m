//
//  DSImageBrowseView.m
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/7/15.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSImageBrowseView.h"
#import "CALayer+YYWebImage.h"

@implementation DSImageBrowseView


- (instancetype)init{
    
    self = [super init];
    _longImageBadgeName = @"image_longimage";
    _gifImageBadgeName  = @"image_gif";
    _defaultImageName   = @"default";
    
    self.backgroundColor = [UIColor clearColor];
    self.exclusiveTouch = YES;
    NSMutableArray *imageViews = [[NSMutableArray alloc] init];
    __weak typeof(self) weakSelf = self;
    for (int i = 0; i< 9 ;i++) {
        DSThumbnailView *thumbanilView = [[DSThumbnailView alloc] init];
        thumbanilView.size = CGSizeMake(100, 100);
        thumbanilView.hidden = YES;
        thumbanilView.clipsToBounds = YES;
        thumbanilView.backgroundColor = RGB(240, 240, 240);
        thumbanilView.exclusiveTouch = YES;
        thumbanilView.touchBlock = ^(DSThumbnailView *view, CGPoint point) {
            if (![weakSelf.delegate respondsToSelector:@selector(imageBrowse:didSelectImageAtIndex:)]) return;
            if (CGRectContainsPoint(view.bounds, point)) {
                [weakSelf.delegate imageBrowse:weakSelf didSelectImageAtIndex:i];
            }
        };
        thumbanilView.longPressBlock = ^(DSThumbnailView *view, CGPoint point) {
            if (![weakSelf.delegate respondsToSelector:@selector(imageBrowse:longPressImageAtIndex:)]) return;
            if (CGRectContainsPoint(view.bounds, point)) {
                [weakSelf.delegate imageBrowse:weakSelf longPressImageAtIndex:i];
            }
        };
        UIView *badge = [[UIImageView alloc] init];
        badge.userInteractionEnabled = NO;
        badge.contentMode = UIViewContentModeScaleAspectFit;
        badge.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        badge.right = thumbanilView.width;
        badge.bottom = thumbanilView.height;
        badge.hidden = YES;
        [thumbanilView addSubview:badge];
        [imageViews addObject:thumbanilView];
        [self addSubview:thumbanilView];
    }
    
    _imageViews = imageViews;
    
    return self;
}

- (void)setLayout:(DSImageLayout *)layout {
    
    _layout = layout;
    self.width = layout.imageBrowseWidth;
    self.height = layout.imageBrowseHeight;
    
    CGSize imageSize = layout.imageSize;
    int imagesCount = (int)layout.imagesData.count;
    
    for (int i = 0; i < 9; i++) {
        DSThumbnailView *thumbanilView = _imageViews[i];
        if (i >= imagesCount) {
            [thumbanilView.layer yy_cancelCurrentImageRequest];
            thumbanilView.hidden = YES;
        } else {
            CGPoint origin = CGPointZero;
            switch (imagesCount) {
                case 1: {
                    origin.x = layout.leftPadding;
                    origin.y = layout.topPadding;
                }
                    break;
                case 4: {
                    origin.x = layout.leftPadding + (i % 2) * (imageSize.width + layout.imagePadding);
                    origin.y = layout.topPadding  + (i / 2) * (imageSize.height + layout.imagePadding);
                }
                    break;
                default: {
                    origin.x = layout.leftPadding + (i % 3) * (imageSize.width + layout.imagePadding);
                    origin.y = layout.topPadding  + (i / 3) * (imageSize.height + layout.imagePadding);
                }
                    break;
            }
            thumbanilView.frame = CGRectMake(origin.x, origin.y, imageSize.width, imageSize.height);
            thumbanilView.hidden = NO;
            [thumbanilView.layer removeAnimationForKey:@"contents"];
            
            
            DSImagesData *imagesData = layout.imagesData[i];
            UIView *badge = thumbanilView.subviews.firstObject;
            badge.size = CGSizeMake(layout.imageBadgeWidth, layout.imageBadgeHeight);
            switch (imagesData.largeImage.badgeType) {
                case DSImageBadgeTypeNone: {
                    if (badge.layer.contents) {
                        badge.layer.contents = nil;
                        badge.hidden = YES;
                    }
                }
                    break;
                case DSImageBadgeTypeGIF: {
                    badge.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:_longImageBadgeName].CGImage);
                    badge.hidden = NO;
                }
                    break;
                case DSImageBadgeTypeLong: {
                    badge.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:_gifImageBadgeName].CGImage);
                    badge.hidden = NO;
                }
                    break;
            }
            
            if (!imagesData.thumbnailImage.url && !imagesData.largeImage.url) return;
            DSImageData *imageData;
            //如果没有缩略图，就直接使用大图来显示。
            if (imagesData.thumbnailImage.url) {
                imageData = imagesData.thumbnailImage;
                [self setImageWithData:imageData imageView:thumbanilView];
            } else {
                imageData = imagesData.largeImage;
                [self setImageWithData:imageData imageView:thumbanilView];
            }
        }
    }
}


- (void)setImageWithData:(DSImageData *)imageData imageView:(DSThumbnailView *)thumbanilView {
    __weak typeof(thumbanilView) wThumbanilView = thumbanilView;
    [thumbanilView.layer yy_setImageWithURL:imageData.url
                            placeholder:[UIImage imageNamed:_defaultImageName]
                                options:YYWebImageOptionAvoidSetImage | YYWebImageOptionShowNetworkActivity
                             completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                 __strong typeof(wThumbanilView) sThumbanilView = wThumbanilView;
                                 if (!sThumbanilView) return;
                                 if (image && stage == YYWebImageStageFinished) {
                                     
                                     int width;
                                     int height;
                                     if (imageData.width < 1 || imageData.height < 1) {
                                         width = image.size.width;
                                         height = image.size.height;
                                         
                                     }else {
                                         width = imageData.width;
                                         height = imageData.height;
                                     }
                                     
                                     if (_layout.imagesData.count == 1) {
                                         sThumbanilView.contentMode = UIViewContentModeScaleAspectFill;
                                         sThumbanilView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                                     }else {
                                         CGFloat scale = (height / width) / (sThumbanilView.height / sThumbanilView.width);
                                         if (scale < 0.99 || isnan(scale)) {
                                             sThumbanilView.contentMode = UIViewContentModeScaleAspectFill;
                                             sThumbanilView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                                         }else {
                                             sThumbanilView.contentMode = UIViewContentModeScaleToFill;
                                             sThumbanilView.layer.contentsRect = CGRectMake(0, 0, 1, (float) width / height);
                                         }
                                     }
                                     ((DSThumbnailView *)sThumbanilView).image = image;
                                     if (from != YYWebImageFromMemoryCacheFast) {
                                         CATransition *transition = [CATransition animation];
                                         transition.duration = 0.15;
                                         transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                         transition.type = kCATransitionFade;
                                         [sThumbanilView.layer addAnimation:transition forKey:@"contents"];
                                     }
                                     
                                 }
                             }];
}

@end
