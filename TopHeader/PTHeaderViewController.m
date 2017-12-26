//
//  PTHeaderViewController.m
//  TopHeader
//
//  Created by PatrickY on 2017/12/26.
//  Copyright © 2017年 PatrickY. All rights reserved.
//

#import "PTHeaderViewController.h"
#import "UIColor+Extension.h"
#import "UINavigationController+Extension.h"
//@import AFNetworking;
#import <YYWebImage/YYWebImage.h>

NSString *const cellId = @"cellId";
#define kHeaderHeight 250

@interface PTHeaderViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation PTHeaderViewController {
    UITableView       *_tableView;
    UIView            *_headerView;
    UIImageView       *_headerImageView;
    UIView            *_lineView;
    UIStatusBarStyle  _statusBarStyle;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareTableView];
    
    [self prepaerHeaderView];
    
    _statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //取消自动调整滚动视图间距 !! VC+NAV 会自动调整tableView的 contentInset
    if (@available(iOS 11.0, *)) {
        
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return _statusBarStyle;
}

- (void)prepareTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    
    [self.view addSubview:_tableView];
    
    //设置表格间距
    _tableView.contentInset = UIEdgeInsetsMake(kHeaderHeight, 0, 0, 0);
    
    //设置滚动指示器间距
    _tableView.scrollIndicatorInsets = _tableView.contentInset;
    
}

//准备顶部视图
- (void)prepaerHeaderView {
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kHeaderHeight)];
    _headerView.backgroundColor = [UIColor pt_colorWithHex:0xF8F8F8];
   
    [self.view addSubview:_headerView];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:_headerView.bounds];
    _headerImageView.backgroundColor = [UIColor pt_colorWithHex:0x003300];
    //设置contentMode
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    //裁切 UIViewContentModeScaleAspectFill 有时候不会自动裁切
    _headerImageView.clipsToBounds = YES;
   
    [_headerView addSubview:_headerImageView];
    
    //添加分割线 1个像素点
    CGFloat lineHeight = 1 / [UIScreen mainScreen].scale;
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeaderHeight - lineHeight, _headerView.bounds.size.width, lineHeight)];
    _lineView.backgroundColor = [UIColor lightGrayColor];
    
    [_headerView addSubview:_lineView];
    
    //设置图像
    NSURL *url = [NSURL URLWithString:@"https://ss3.baidu.com/-fo3dSag_xI4khGko9WTAnF6hhy/image/pic/item/0824ab18972bd407e320e60670899e510eb30961.jpg"];
    //YYWebImage  YYWebImageOptionShowNetworkActivity 网络指示器
    [_headerImageView yy_setImageWithURL:url options:YYWebImageOptionShowNetworkActivity];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offSet = scrollView.contentOffset.y + scrollView.contentInset.top;
    
    if (offSet <= 0) {
        //放大  调整headerView和headerImageView
        _headerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, kHeaderHeight - offSet);
        _headerImageView.alpha = 1;
        
    }else {
        //整体上移
        //headerView最小y值
        // 88 iPhone X
        CGFloat min = kHeaderHeight - 88;
        _headerView.frame = CGRectMake(0, -MIN(min, offSet), self.view.bounds.size.width, kHeaderHeight);
        
        CGFloat progressAlpha = 1 - (offSet / min);
        _headerImageView.alpha = progressAlpha;
        
        //根据透明度修改状态栏颜色
        _statusBarStyle = (progressAlpha < 0.2) ? UIStatusBarStyleDefault :UIStatusBarStyleLightContent;
        
        //更新
        [self.navigationController setNeedsStatusBarAppearanceUpdate];
        
    }
    
    //设置图像高度
    _headerImageView.frame = _headerView.bounds;
    
    //设置分割线的位置
    _lineView.frame = CGRectMake(0, _headerView.frame.size.height - _lineView.frame.size.height, _headerView.bounds.size.width, 1 / [UIScreen mainScreen].scale) ;
}


#pragma mark --UITableViewDelegate, UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1000;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    cell.textLabel.text = @(indexPath.row).stringValue;
    
    return cell;
    
}
@end
