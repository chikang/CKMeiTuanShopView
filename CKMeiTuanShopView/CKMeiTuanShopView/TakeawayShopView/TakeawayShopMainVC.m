//
//  TakeawayShopMainVC.m
//  AppPark
//
//  Created by CK on 2018/7/3.
//

#import "TakeawayShopMainVC.h"
#import "TakeawayShopView.h"
@interface TakeawayShopMainVC ()

@end

@implementation TakeawayShopMainVC

#pragma mark - 视图生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //发送通知已经完成定位
    //    if ([PublicMethod checkUserLogin ]) {
    //        //已经登录
    //         [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNewShop" object:self userInfo:nil];
    //    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
     [self initSubView];
}

#pragma mark - 控件事件


#pragma mark - 私有方法
//初始化数据
- (void)initData
{
    
}

//加载子视图
- (void)initSubView
{
    //在请求中携带店铺ID
    TakeawayShopView *shopView = [[TakeawayShopView alloc]initWithFrame:self.view.bounds withGroupID:_GroupID];
    [self.view addSubview:shopView];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
