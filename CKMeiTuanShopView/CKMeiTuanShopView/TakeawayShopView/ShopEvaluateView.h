//
//  ShopEvaluateView.h
//  AppPark
//
//  Created by 池康 on 2018/3/2.
//

#import <UIKit/UIKit.h>

@interface ShopEvaluateView : UIView
@property (nonatomic , strong) UITableView *tableView;

//店铺ID
@property (nonatomic , copy) NSString *groupId;

- (id)initWithFrame:(CGRect)frame  withGroupID:(NSString *)groupId;
@end
