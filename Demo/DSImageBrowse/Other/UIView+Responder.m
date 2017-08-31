//
//  UIView+Responder.m
//  test
//
//  Created by 黄铭达 on 2017/7/19.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "UIView+Responder.h"

//static inline void swizzling_exchangeMethod(Class class ,SEL originalSelector, SEL swizzledSelector) {
//    
//    Method originalMethod = class_getInstanceMethod(class, originalSelector);
//    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//    
//    BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//    if (success) {
//        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//    }else {
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//}
//
//@implementation UIView (Responder)
//
//
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        swizzling_exchangeMethod([UIView class], @selector(hitTest:withEvent:), @selector(ds_hitTest:withEvent:));
//        swizzling_exchangeMethod([UIView class], @selector(pointInside:withEvent:), @selector(ds_pointInside:withEvent:));
//        swizzling_exchangeMethod([UIView class], @selector(touchesBegan:withEvent:), @selector(ds_touchesBegan:withEvent:));
//        swizzling_exchangeMethod([UIView class], @selector(touchesMoved:withEvent:), @selector(ds_touchesMoved:withEvent:));
//        swizzling_exchangeMethod([UIView class], @selector(touchesEnded:withEvent:), @selector(ds_touchesEnded:withEvent:));
//    });
//}
//
//
//#pragma mark - 重写的方法
//
//- (void)ds_touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event
//{
//    NSLog(@"%@ touch begin", self.class);
//    UIResponder *next = [self nextResponder];
//    while (next) {
//        NSLog(@"%@",next.class);
//        next = [next nextResponder];
//    }
//}
//
//- (void)ds_touchesMoved: (NSSet *)touches withEvent: (UIEvent *)event
//{
//    NSLog(@"%@ touch move", self.class);
//}
//
//- (void)ds_touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event
//{
//    NSLog(@"%@ touch end", self.class);
//    NSLog(@"----------------------");
//}
//
////模拟一下，系统真正的实现肯定不是这样的。
//- (UIView *)ds_hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    
//    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) return nil;
//    //判断点在不在这个视图里
//    if ([self pointInside:point withEvent:event]) {
//        //在这个视图 遍历该视图的子视图
//        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
//            //转换坐标到子视图
//            CGPoint convertedPoint = [subview convertPoint:point fromView:self];
//            //递归调用hitTest:withEvent继续判断
//            UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
//            if (hitTestView) {
//                //在这里打印self.class可以看到递归返回的顺序。
//                return hitTestView;
//            }
//        }
//        //这里就是该视图没有子视图了 点在该视图中，所以直接返回本身，上面的hitTestView就是这个。
//        NSLog(@"命中的view:%@",self.class);
//        return self;
//    }
//    //不在这个视图直接返回nil
//    return nil;
//}
//
//- (BOOL)ds_pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
//    BOOL success = CGRectContainsPoint(self.bounds, point);
//    if (success) {
//        NSLog(@"点在%@里",self.class);
//    }else {
//        NSLog(@"点不在%@里",self.class);
//    }
//    return success;
//}

//@end
