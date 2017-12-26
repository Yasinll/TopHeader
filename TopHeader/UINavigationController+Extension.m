//
//  UINavigationController+Extension.m
//  TopHeader
//
//  Created by PatrickY on 2017/12/26.
//  Copyright © 2017年 PatrickY. All rights reserved.
//

#import "UINavigationController+Extension.h"
#import <objc/runtime.h>

@interface PTFullScreenPopGestureRecognizerDelegate:NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak)UINavigationController *navigationController;

@end


@implementation PTFullScreenPopGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    //是否是根视图
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    //是否在转场动画
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    //判断手指移动方向
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    return YES;
}

@end


@implementation UINavigationController (Extension)

+ (void)load {
    
    Method originalMethod = class_getInstanceMethod([self class], @selector(pushViewController:animated:));
    Method swizzledMethod = class_getInstanceMethod([self class], @selector(pt_pushViewController:animated:));
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
}


- (void)pt_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.pt_popGestureRecognizer]) {
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.pt_popGestureRecognizer];
        
        NSArray *targets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [targets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        
        self.pt_popGestureRecognizer.delegate = [self pt_fullScreenPopGestureRecognizerDelegate];
        [self.pt_popGestureRecognizer addTarget:internalTarget action:internalAction];
        
        //禁用系统交互手势
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    if (![self.viewControllers containsObject:viewController]) {
        [self pt_pushViewController:viewController animated:animated];
    }
}

#pragma mark -- PTFullScreenPopGestureRecognizerDelegate
- (PTFullScreenPopGestureRecognizerDelegate *)pt_fullScreenPopGestureRecognizerDelegate {
    
    PTFullScreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    
    if (!delegate) {
        delegate = [[PTFullScreenPopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return delegate;
}

//自定义交互手势
- (UIPanGestureRecognizer *)pt_popGestureRecognizer {
    
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    
    if (panGestureRecognizer == nil) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return panGestureRecognizer;
    
}

@end


