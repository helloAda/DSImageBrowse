//
//  DSThumbnailView.m
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/7/20.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSThumbnailView.h"

@implementation DSThumbnailView {
    UIImage   *_image;
    CGPoint   _point;
    NSTimer   *_timer;
    BOOL      _longPressDetected;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.layer.contents = (id)image.CGImage;
}

- (UIImage *)image {
    
    id content = self.layer.contents;
    if (content != (id) _image.CGImage) {
        CGImageRef imageRef = (__bridge CGImageRef)(content);
        if (imageRef && CFGetTypeID(imageRef) == CGImageGetTypeID()) {
            _image = [UIImage imageWithCGImage:imageRef scale:self.layer.contentsScale orientation:UIImageOrientationUp];
        } else {
            _image = nil;
        }
    }
    return _image;
}


- (void)dealloc {
    [self endTimer];
}

#pragma mark -- Response Chain

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _longPressDetected = NO;
    if (_longPressBlock) {
        UITouch *touch = [touches anyObject];
        _point = [touch locationInView:self];
        [self startTimer];
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (_longPressDetected) return;
    [self endTimer];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_longPressDetected) return;
    if (_touchBlock) {
        UITouch *touch = [touches anyObject];
        _point = [touch locationInView:self];
        _touchBlock(self, _point);
    }
    [self endTimer];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_longPressDetected) return;
    [self endTimer];
}

#pragma mark - Timer

- (void)startTimer {
    [_timer invalidate];
    _timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(timerFire) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)endTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)timerFire {
    [self touchesCancelled:[NSSet set] withEvent:nil];
    _longPressDetected = YES;
    if (_longPressBlock) {
        _longPressBlock(self, _point);
    }
    [self endTimer];
}


@end
