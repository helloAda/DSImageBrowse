//
//  DSImageMacro.h
//  DSImageBrowse
//
//  Created by 黄铭达 on 2017/8/4.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#ifndef DSImageMacro_h
#define DSImageMacro_h

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define RGBA(r,g,b,a)     [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1)


#endif /* DSImageMacro_h */
