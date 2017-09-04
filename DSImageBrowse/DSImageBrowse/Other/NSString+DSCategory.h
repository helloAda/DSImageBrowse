//
//  NSString+DSCategory.h
//  DSCategory
//
//  Created by 黄铭达 on 2017/8/29.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSString (DSCategory)

/**
  NSString for md5 hash.
 */
- (nullable NSString *)ds_md5String;


/**
 Computing the string size

 @param font Font used
 @param size Maximum of size for string.
 @param lineBeakMode see NSLineBreakMode
 @return Size of the string's bounding
 */
- (CGSize)ds_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBeakMode;

@end
NS_ASSUME_NONNULL_END
