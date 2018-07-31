//
//  NewShopListModel.m
//  AppPark
//
//  Created by 池康 on 2018/3/7.
//

#import "NewShopListModel.h"

@implementation NewShopListModel


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
