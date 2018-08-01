//
//  TakeawayShopView.h
//  AppPark
//
//  Created by CK on 2018/7/10.
//

#import <UIKit/UIKit.h>

/**
 外卖店铺主页
 */
@interface TakeawayShopView : UIView

//店铺ID
@property (nonatomic , copy) NSString *groupId;

- (id)initWithFrame:(CGRect)frame  withGroupID:(NSString *)groupId;


@end
