//
//  NewShopModel.h
//  AppPark
//
//  Created by 池康 on 2018/3/6.
//

#import <Foundation/Foundation.h>


@protocol CouponListModel
@end

@interface NewShopModel : JSONModel
/**活动数量 */
@property (nonatomic ,copy) NSString *activeCount;
/**评论数量 */
@property (nonatomic ,copy) NSString *commCount;
/** 评分*/
@property (nonatomic ,copy) NSString *commScore;
/** */
@property (nonatomic ,copy) NSString *count;
/**是否收藏*/
@property (nonatomic ,copy) NSString *isCollection;

//@property (nonatomic ,copy) NSDictionary *item;
/** 营业时间*/
@property (nonatomic ,copy) NSString *openHour;
/** 店铺背景图*/
@property (nonatomic ,copy) NSString *picUrl;
/** 地址*/
@property (nonatomic ,copy) NSString *shopAddress;
/**店铺图标*/
@property (nonatomic ,copy) NSString *shopIcon;
/** 店铺介绍*/
@property (nonatomic ,copy) NSString *shopIntroduce;
/** 经纬度*/
@property (nonatomic ,copy) NSString *shopLocation;
/** 店铺名称*/
@property (nonatomic ,copy) NSString *shopName;
/** 公告*/
@property (nonatomic ,copy) NSString *shopNotice;
//资质图片
@property (nonatomic ,strong) NSArray *shopPicList;
/** 店铺类型1.企业认证   2.商家认证  3.个体工商户 4.不显示*/
@property (nonatomic ,copy) NSString *shopType;
/**分类*/
@property (nonatomic ,strong) NSMutableArray *sortInfo;
/** */
//@property (nonatomic ,copy) NSDictionary *style;

//
@property (nonatomic ,copy) NSString *isStyle;
//是否显示店铺信息：0-否,1-是
@property (nonatomic ,copy) NSString *style_groupInfoShow;
//导航位置类型：1-横向导航,2-竖向导航
@property (nonatomic ,copy) NSString *style_tabPosition;
// 快速布局类型：1-列表布局，2-宫格布局，3-卡片布局
@property (nonatomic ,copy) NSString *sys_moduleType;

@property (nonatomic ,copy) NSString *telnumber;
/** 优惠券*/
@property (nonatomic ,strong) NSArray <CouponListModel > *couponList;
/** 活动*/
@property (nonatomic ,strong) NSArray <CouponListModel > *activityList;

/**聊天客服JID*/
@property (nonatomic ,copy) NSString *serviceJIDUserName;
/**客服名称*/
@property (nonatomic ,copy) NSString *serviceUserNickName;
/**客服头像*/
@property (nonatomic ,copy) NSString *serviceHeadFace;
/**聊天用户名*/
@property (nonatomic ,copy) NSString *serviceName;
/**聊天客服用户id*/
@property (nonatomic ,copy) NSString *serviceId;
/**是否开启客服聊天*/
@property (nonatomic ,copy) NSString *serviceOpenState;
@end



@interface CouponListModel : JSONModel<NSCopying,NSMutableCopying>
#pragma mark --- 优惠券
/***/
@property (nonatomic ,copy) NSString *activeId;
/***/
@property (nonatomic ,copy) NSString *couponCondition;
/***/
@property (nonatomic ,copy) NSString *couponEndTime;
/***/
@property (nonatomic ,copy) NSString *couponId;
/***/
@property (nonatomic ,copy) NSString *couponNumber;
/**couponPrice*/
@property (nonatomic ,copy) NSString *couponPrice;
/**开始时间*/
@property (nonatomic ,copy) NSString *couponStartTime;
/***/
@property (nonatomic ,copy) NSString *couponTime;
/***/
@property (nonatomic ,copy) NSString *couponTitle;
/***/
@property (nonatomic ,copy) NSString *isPlatForm;


#pragma mark --- 活动名称
/***/
@property (nonatomic ,copy) NSString *activeEndTime;
/**开始时间*/
@property (nonatomic ,copy) NSString *activeStartTime;
/***/
@property (nonatomic ,copy) NSString *activeTitle;
/**活动类型1.限时折扣  2.满减  3.优惠券*/
@property (nonatomic ,copy) NSString *activeType;
/***/
@property (nonatomic ,copy) NSString *isPlantActive;


@end
