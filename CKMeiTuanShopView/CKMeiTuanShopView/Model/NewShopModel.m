//
//  NewShopModel.m
//  AppPark
//
//  Created by 池康 on 2018/3/6.
//

#import "NewShopModel.h"

@implementation NewShopModel


+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:
            @{
              @"iD":@"id",
              }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end



@implementation CouponListModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:
            @{
              @"iD":@"id",
              }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (id)copyWithZone:(NSZone *)zone{
    
    CouponListModel * model = [[CouponListModel allocWithZone:zone] init];
    model.couponNumber = self.couponNumber;//self是被copy的对象
    return model;
    
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    
    CouponListModel * model = [[CouponListModel allocWithZone:zone] init];
    model.couponNumber = self.couponNumber;//self是被copy的对象
    return model;
}


@end
