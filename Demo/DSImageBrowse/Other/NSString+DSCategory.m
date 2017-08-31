//
//  NSString+DSCategory.m
//  DSCategory
//
//  Created by 黄铭达 on 2017/8/29.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "NSString+DSCategory.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (DSCategory)



- (nullable NSString *)ds_md5String {
    const char *cstr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


- (CGSize)ds_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBeakMode {
    if (!font) font = [UIFont systemFontOfSize:12];
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = font;
    if (lineBeakMode != NSLineBreakByWordWrapping) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBeakMode;
        attr[NSParagraphStyleAttributeName] = paragraphStyle;
    }
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attr context:nil];
    return rect.size;
}
@end
