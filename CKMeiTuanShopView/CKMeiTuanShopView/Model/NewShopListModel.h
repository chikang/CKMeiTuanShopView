//
//  NewShopListModel.h
//  AppPark
//
//  Created by 池康 on 2018/3/7.
//

#import <Foundation/Foundation.h>

@interface NewShopListModel : JSONModel

/**图片 */
@property (nonatomic ,copy) NSString *picUrl;
/**价格 */
@property (nonatomic ,copy) NSString *price;
/**价格范围 */
@property (nonatomic ,copy) NSString *priceRange;
/**售出数量 */
@property (nonatomic ,copy) NSString *soldCount;
/**标题 */
@property (nonatomic ,copy) NSString *title;
//标签：1.新品  2.热卖  3.力荐 4.人气
@property (nonatomic ,copy) NSString *tag;

@property (nonatomic ,copy) NSString *goodRate;
//活动类型1.限时折扣  2.满减  3.优惠券
@property (nonatomic ,copy) NSString *activityType;

@property (nonatomic ,copy) NSString *iD;

@property (nonatomic ,copy) NSString *useTime;
@property (nonatomic ,copy) NSString *appointmentTime;
@property (nonatomic ,copy) NSString *virtualUseTime;
@property (nonatomic ,copy) NSString *rackRate;
@property (nonatomic ,copy) NSString *makeAnAppointmentDate;
@property (nonatomic ,copy) NSString *makeAnAppointment;
@property (nonatomic ,copy) NSString *isVirtual;
@property (nonatomic ,copy) NSString *activityId;
@property (nonatomic ,copy) NSString *activityEnterType;
@property (nonatomic ,copy) NSString *activityEnterState;
@property (nonatomic ,copy) NSString *activityEnterProductId;
@property (nonatomic ,copy) NSString *activityEnterId;
@property (nonatomic ,copy) NSString *activityDataStatus;


@end
