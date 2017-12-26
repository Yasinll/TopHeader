//
//  ViewController.m
//  TopHeader
//
//  Created by PatrickY on 2017/12/26.
//  Copyright © 2017年 PatrickY. All rights reserved.
//

#import "ViewController.h"
#import "PTHeaderViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (IBAction)btnClick:(id)sender {
    
    PTHeaderViewController *vc = [[PTHeaderViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    //显示导航栏 !!animated
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}


@end
