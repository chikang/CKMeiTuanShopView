//
//  ShopHomePageView.h
//  AppPark
//
//  Created by 池康 on 2018/7/10.
//

#import <UIKit/UIKit.h>
#import "ShopScrollView.h"
/**
 店铺主页
 */
@interface ShopHomePageView : UIView

//商家展示风格类型 cell样式
@property (nonatomic ,assign) ShopModuleType shopModuleType;
//左视图-->标签tableView
@property (nonatomic , strong)UITableView *leftTabView;
//右视图-->列表样式or卡片样式
@property (nonatomic , strong)UITableView *rightTabView;
//右视图-->宫格样式
@property (nonatomic , strong)UICollectionView *collectionView;
//当前视图控制器
@property (nonatomic , strong) UIViewController *currentVC;
//店铺ID
@property (nonatomic , copy) NSString *groupId;
//数据模型
@property (nonatomic ,strong) NewShopModel *shopModel;
//该视图的父视图
@property (nonatomic ,strong) ShopScrollView *shopSuperView;


//父视图偏移量
- (void)superScrollViewDidScrollOffset:(CGFloat)offset;

@end
