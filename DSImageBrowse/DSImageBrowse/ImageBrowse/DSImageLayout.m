//
//  DSImageLayout.m
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/7/15.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSImageLayout.h"

@implementation DSImageLayout

- (instancetype)initWithImageData:(NSArray <DSImagesData *>*)imagesdata{

    if (!imagesdata) return nil;

    self = [super init];
    if (self) {
        _imagesData   = imagesdata;
        _imagePadding = 4;
        _topPadding = 12;
        _bottomPadding = 12;
        _leftPadding = 12;
        _rightPadding = 12;
        _imageBrowseWidth = kScreenWidth;
    }
    return self;
}

- (void)layout {
    
    _imageSize = CGSizeZero;
    _imageBrowseHeight = 0;
    if (_imagesData.count == 0) return;
    CGSize imageSize = CGSizeZero;
    CGFloat imageBrowseHeight = 0;
    
    CGFloat eachImage = (_imageBrowseWidth - (_imagePadding * 2) - _leftPadding - _rightPadding) / 3;
    switch (_imagesData.count) {
        case 1: {
            DSImagesData *image = _imagesData.firstObject;
            if (image.thumbnailImage.width < 1 || image.thumbnailImage.height < 1) {
                CGFloat max = _imageBrowseWidth / 2.0;
                imageSize = CGSizeMake(max, max);
                imageBrowseHeight = max + _topPadding + _bottomPadding;
            }else {
                CGFloat max = eachImage * 2 + _imagePadding;
                if (image.thumbnailImage.width < image.thumbnailImage.height) {
                    imageSize.width = (float)image.largeImage.width / (float)image.largeImage.height * max;
                    imageSize.height = max;
                } else {
                    imageSize.width = max;
                    imageSize.height = (float)image.thumbnailImage.height / (float)image.thumbnailImage.width * max;
                }
                imageSize = CGSizeMake(imageSize.width, imageSize.height);
                imageBrowseHeight = imageSize.height + _topPadding + _bottomPadding;
            }
        }
            break;
        case 2:
        case 3: {
            imageSize = CGSizeMake(eachImage, eachImage);
            imageBrowseHeight = eachImage + _topPadding + _bottomPadding;
        }
            break;
        case 4:
        case 5:
        case 6: {
            imageSize = CGSizeMake(eachImage, eachImage);
            imageBrowseHeight = eachImage * 2 + _imagePadding + _topPadding + _bottomPadding;
        }
            break;
        case 7:
        case 8:
        case 9: {
            imageSize = CGSizeMake(eachImage, eachImage);
            imageBrowseHeight = eachImage * 3 + _imagePadding * 2 + _topPadding + _bottomPadding;
        }
        default:
            break;
    }
    
    _imageSize = imageSize;
    _imageBrowseHeight = imageBrowseHeight;
}

@end
