//
//  UINavigationController+Extension.h
//  TopHeader
//
//  Created by PatrickY on 2017/12/26.
//  Copyright © 2017年 PatrickY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Extension)

//自定义全屏拖拽返回手势
@property (nonatomic, strong, readonly)UIPanGestureRecognizer *pt_popGestureRecognizer;


@end
