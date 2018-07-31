//
//  OrderListInfo.h
//  AppPark
//
//  Created by kongxin on 2018/7/16.
//

#import "JSONModel.h"

@interface ShoppingCartOrderListInfo : JSONModel
@property(nonatomic,copy)NSString *orderid;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *min_price;
@property(nonatomic,copy)NSString *praise_num;
@property(nonatomic,copy)NSString *picture;
@property(nonatomic,copy)NSString *month_saled;
@property(nonatomic,copy)NSString *orderCount;

/// 产品名称
@property (nonatomic,copy) NSString *productName;
/// 原始价格
@property (nonatomic,copy) NSString *originalPrice;

@end
