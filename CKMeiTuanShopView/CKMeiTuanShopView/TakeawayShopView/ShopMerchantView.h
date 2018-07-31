//
//  ShopMerchantView.h
//  AppPark
//
//  Created by 池康 on 2018/2/9.
//

#import <UIKit/UIKit.h>
#import "NewShopModel.h"

@interface ShopMerchantView : UIView

@property (nonatomic , strong) UITableView *tableView;

//店铺ID
@property (nonatomic , copy) NSString *groupId;

@property (nonatomic ,strong) NewShopModel *shopModel;//数据模型


@end
