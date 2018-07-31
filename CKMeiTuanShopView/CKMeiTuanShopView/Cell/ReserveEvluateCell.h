//
//  ReserveEvluateCell.h
//  AppPark
//
//  Created by 池康 on 2017/12/14.
//

#import <UIKit/UIKit.h>
#import "EvaluateModel.h"

@protocol ReserveEvluateCellDelegate;
@interface ReserveEvluateCell : UITableViewCell
/**
 头像
 */
@property (nonatomic , strong) UIImageView *headImgView;
/**
 用户名称
 */
@property (nonatomic , strong) UILabel *userNameLab;
/**
 评论时间
 */
@property (nonatomic , strong) UILabel *timeLab;
/**
 酒店套房类型
 */
@property (nonatomic , strong) UILabel *roomTypeLab;
/**
 评价分数
 */
@property (nonatomic , strong) UILabel *gradeLab;
/**
 评论内容
 */
@property (nonatomic , strong) UILabel *contentLab;
/**
 图片视图
 */
@property (nonatomic , strong) UIView *photoView;
/**
 图标
 */
@property (nonatomic , strong) UIImageView *topImgView;

/**
 酒店回复视图
 */
@property (nonatomic , strong) UIView *replyView;
/**
 酒店回复
 */
@property (nonatomic , strong) UILabel *replyLab;
/**
 底部的线
 */
@property (nonatomic , strong) UILabel *lineLab;

@property (nonatomic , weak) id <ReserveEvluateCellDelegate >delegate;

@property (nonatomic , strong)EvaluateModel *model;

/**
 1:代表店铺优化的评价
 */
@property (nonatomic , assign) NSInteger cellType;

@end


@protocol ReserveEvluateCellDelegate <NSObject>

@optional

- (void)didSelectedPhotoView:(ReserveEvluateCell *)cell withImgIndex:(NSInteger)index;

@end
