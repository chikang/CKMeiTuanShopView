//
//  ShopScrollView.h
//  AppPark
//
//  Created by 池康 on 2018/7/10.
//

#import <UIKit/UIKit.h>
#import "NewShopModel.h"

@protocol ShopScrollViewDelegate;

/**
 店铺商品列表
 */
@interface ShopScrollView : UIScrollView

//是否显示动画;
@property (nonatomic ,assign) BOOL isStopAnimation;
//商家展示风格类型
@property (nonatomic ,assign) ShopModuleType shopViewType;
//申明代理
@property (weak , nonatomic) id<ShopScrollViewDelegate> scrollDelegate;
//店铺ID
@property (nonatomic , copy) NSString *groupId;
//当前视图控制器
@property (nonatomic , strong) UIViewController *currentVC;
//初始化店铺主页方法
- (id)initWithFrame:(CGRect)frame  withShopModel:(NewShopModel *)model  withGroupID:(NSString *)groupId currentVC:(UIViewController *)currentVC;

//移除手势
- (void)removeBehaviors;
@end

@protocol ShopScrollViewDelegate <NSObject>

@optional

//监听列表滚动视图的偏移量
- (void)ListScrollViewDidScroll:(UIScrollView *)scrollView;

//偏移结束后
- (void)ListScrollViewDidEndDragging:(UIScrollView *)scrollView;

//点击顶部视图  让该视图平移向下消失
- (void)ListScrollViewDropDown:(UIScrollView *)scrollView;
@end
