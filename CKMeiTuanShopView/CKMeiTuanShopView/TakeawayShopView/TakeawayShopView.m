//
//  TakeawayShopView.m
//  AppPark
//
//  Created by 池康 on 2018/7/10.
//

#import "TakeawayShopView.h"
#import "FXBlurView.h"
#import "YBPopupMenu.h"
#import "ShopScrollView.h"
#import "NewShopModel.h"
#import "CustomTestCell.h"
#define TITLES @[@"我的购物车", @"消息中心"]
#define ICONS  @[@"icon-shoppingcart",@"icon-messagecenter"]

#define NAVBAR_CHANGE_POINT 50

//#define maxOffsetY  (long)(150*kScreenWidth/375 + 48 - kDefaultNavBarHeight)
@interface TakeawayShopView ()<ShopScrollViewDelegate,YBPopupMenuDelegate,UIGestureRecognizerDelegate>
{
    BOOL _isStopAnimation;//是否禁止动画执行
    CGFloat _alpha;//导航条透明度
    UIColor *styleColor;
    UIButton *_backBT;
    UIView *_sousuoView;
    UILabel *_sousuoLab;
    NewShopModel *_shopModel;//数据模型
    NSInteger _maxOffset_Y;
    CGFloat _startChange_Y;//开始改变的偏移量
    BOOL _isCollect;//是否已经收藏
    NSInteger _IMG_HEIGHT;//封面的高度
}
@property (nonatomic , strong) UIView *headerView;///<顶部头视图
@property (nonatomic , strong) UIImageView *shopImgView;///<店铺图片视图
@property (nonatomic , strong) UIView *infoView;///<店铺信息视图
@property (nonatomic , strong) UIView *activityView;///<活动满减视图
@property (nonatomic , strong) UIView *bottomView ;
@property (nonatomic , strong) UIScrollView *shopScrollView;//最底层的视图，显示满减活动、营业时间等
@property (nonatomic , strong) ShopScrollView *productListView;///<商品列表
@property (nonatomic , strong) UIView *navBarView;
@end

@implementation TakeawayShopView

- (id)initWithFrame:(CGRect)frame  withGroupID:(NSString *)groupId
{
    self = [super initWithFrame:frame];
    if (self) {
        // 隐藏状态栏
        _IMG_HEIGHT = Size(150);
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        self.backgroundColor = [UIColor whiteColor];
        [self setupViews];
        [self requestGetProductGroupInfo_new];
        //刷新优惠券
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewShop) name:@"refreshNewShop" object:nil];
    }
    return self;
}

- (void)refreshNewShop
{
    //刷新优惠券
}

//移除通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 控制事件
- (void)moveUpClick:(UIButton *)btn
{
    [UIView animateWithDuration:0.3 animations:^{
        //满减活动的透明度
        _activityView.alpha = 1.0;
        //店铺信息的透明度
        _infoView.alpha = 1.0 ;
        //店铺名称和认证的透明度
        _bottomView.alpha = 0.0;
        //店铺照片的平移动画
        _shopImgView.mj_x = 10;
        _isStopAnimation = NO;
        _productListView.transform = CGAffineTransformMakeTranslation(0, 0);//恢复原位置
    } completion:^(BOOL finished) {
        //满减活动的透明度
        _activityView.alpha = 1.0;
    }];
}

- (void)backAction
{
     UIViewController *superVC =   [self viewController];
    if (_bottomView.alpha != 0) {
        [self moveUpClick:nil];
        return;
    }
   
    [superVC.navigationController popViewControllerAnimated:YES];
}

- (void)searchClick:(UITapGestureRecognizer *)tap{
    //搜索
  
}

- (void)btnClick:(UIButton *)btn
{
    UIViewController *superVC =   [self viewController];
    switch (btn.tag ) {
        case 1:
        {
            //搜索
 
        }
            break;
        case 3:
        {
            //联系客服
    
        }
            break;
        case 2:
        {
            //必须先登录
            //收藏

        }
            break;
//        case 4:
//        {
//            [YBPopupMenu showRelyOnView:btn titles:TITLES icons:ICONS menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
//                popupMenu.cornerRadius = 2;
//                popupMenu.fontSize = 12;
//                popupMenu.textColor = kColor_GrayColor;
//                popupMenu.arrowWidth = 10;
//                popupMenu.arrowHeight = 7;
//                popupMenu.itemHeight = 34;
//                popupMenu.delegate = self;
//                popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//            }];
//        }
//            break;
        default:
            break;
    }
}

//领取优惠券
- (void)getCouponClick:(UITapGestureRecognizer *)tap
{
    //先判断是否登录
    //必须先登录
}

- (void)swipeClick:(UISwipeGestureRecognizer *)swipe
{
    [self moveUpClick:nil];
}

- (void)moveUpTap:(UITapGestureRecognizer *)tap
{
    [self moveUpClick:nil];
}

//跳转到优惠活动页面
- (void)activityTap:(UITapGestureRecognizer *)tap
{

}

#pragma mark - 顶部视图
- (void)setHeaderView
{
    //顶部视图
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, _IMG_HEIGHT)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.userInteractionEnabled = YES;
    [self addSubview:headerView];
    _headerView = headerView;
    //背景封面
    UIImageView *faceImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, _IMG_HEIGHT)];
    faceImgView.backgroundColor = kColor_ButonCornerColor;
    [headerView addSubview:faceImgView];
    [faceImgView sd_setImageWithURL:[NSURL URLWithString:_shopModel.picUrl] placeholderImage:nil];//店铺背景图片
    //模糊效果
    FXBlurView *bview = [[FXBlurView alloc] initWithFrame:faceImgView.bounds];
    bview.tintColor = [UIColor whiteColor];  //前景颜色
    bview.blurEnabled = YES;                //是否允许模糊，默认YES
    bview.blurRadius = 10.0;               //模糊半径
    bview.dynamic = YES;                   //动态改变模糊效果
    [faceImgView addSubview:bview];
    //渐变
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor, (__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.5);
    gradientLayer.frame = CGRectMake(0, 0, self.width, _IMG_HEIGHT);
    [faceImgView.layer addSublayer:gradientLayer];
    //店铺图片
    UIImageView *shopImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, _IMG_HEIGHT - 78, 90, 90)];
    shopImgView.backgroundColor = [UIColor redColor];
    shopImgView.layer.cornerRadius = 4;
    //    shopImgView.layer.masksToBounds = YES;
    shopImgView.layer.shadowColor = kColor_darkGrayColor.CGColor;//shadowColor阴影颜色
    shopImgView.layer.shadowOffset = CGSizeMake(0,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    shopImgView.layer.shadowOpacity = 0.4;//阴影透明度，默认0
    shopImgView.layer.shadowRadius = 3;//阴影半径，默认3
    [self addSubview:shopImgView];
    _shopImgView = shopImgView;
    [_shopImgView sd_setImageWithURL:[NSURL URLWithString:_shopModel.shopIcon] placeholderImage:kImage_Name(@"thumb") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _shopImgView.image = [image drawCircularIconWithSize:CGSizeMake(90, 90) withRadius:4];
    }];
}

#pragma mark - 店铺信息视图
- (void)setShopInfoView
{
    UIView *infoView = [[UIView alloc]init];
    infoView.frame = CGRectMake(_shopImgView.maxX+10, _shopImgView.minY, self.width-(_shopImgView.maxX+20), 78);
    [_headerView addSubview:infoView];
    //店铺图标
    UIImageView *shopIcon = [[UIImageView alloc]init];
    shopIcon.image = kImage_Name(@"icon_brd_big");
    [infoView addSubview:shopIcon];
    shopIcon.frame = CGRectMake(0, 2, shopIcon.image.size.width, 16);
    //店铺名称
    UILabel *shopNameLab = [UITool createLabelWithTextColor:[UIColor whiteColor] textSize:kScreenWidth<375?Size(18):18 alignment:NSTextAlignmentLeft];
    shopNameLab.frame = CGRectMake(shopIcon.maxX+5, 0, infoView.width-(shopIcon.maxX+15), 20);
    shopNameLab.text = _shopModel.shopName; //店铺名称
    [infoView addSubview:shopNameLab];
    //公告
    UILabel *noticeLab = [UITool createLabelWithTextColor:[UIColor whiteColor] textSize:12 alignment:NSTextAlignmentLeft];
    noticeLab.frame = CGRectMake(0, shopNameLab.maxY+8, infoView.width, 12);
    noticeLab.text = [NSString stringWithFormat:@"公告：%@",_shopModel.shopNotice];//公告
    if (_shopModel.shopNotice.length == 0) {
        noticeLab.text = [NSString stringWithFormat:@"公告：%@",@"暂无公告"];//公告
    }
    [infoView addSubview:noticeLab];
    _infoView = infoView;
    //认证
    UIView *cerView = [self setShopGradeAndCerViewWithType:@"1"];
    cerView.frame =CGRectMake(0, _infoView.height-28, cerView.width, 18);
    [_infoView addSubview:cerView];
    
    [self bringSubviewToFront:_shopImgView];
}

#pragma mark - 店铺照片下面的满减活动视图
- (void)setActivityView
{
    NSArray *activityList = _shopModel.activityList;
    UIView *activityView = [[UIView alloc]initWithFrame:CGRectMake(0, _IMG_HEIGHT+12, self.width, 36)];
    [_headerView addSubview:activityView];
    if (activityList.count > 0) {
        CouponListModel *couponListModel = activityList[0];
        _activityView = activityView;
        //
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 11, 14, 14)];
        //1.限时折扣  2.满减  3.优惠券
        if ([couponListModel.activeType integerValue] == 1) {
            iconView.image = kImage_Name(@"icon-discounts");
        }else if ([couponListModel.activeType integerValue] == 2)
        {
            iconView.image = kImage_Name(@"icon-sale");
        }
        else if ([couponListModel.activeType integerValue] == 3)
        {
            iconView.image = kImage_Name(@"icon-coupons");
        }
        [activityView addSubview:iconView];
        //活动名称
        UILabel *activityLab = [UITool createLabelWithTextColor:kColor_TitleColor textSize:12 alignment:NSTextAlignmentLeft];
        activityLab.text = couponListModel.activeTitle;
        activityLab.frame = CGRectMake(iconView.maxX+10, 9, self.width-(iconView.maxX+10+60), 18);
        [activityView addSubview:activityLab];
        
        //
        UIImageView *nextImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width-20, 13, 10, 10)];
        nextImgView.image = kImage_Name(@"icon-folding");
        [activityView addSubview:nextImgView];
        //优惠活动数量
        UILabel *numLab = [UITool createLabelWithTextColor:kColor_GrayColor textSize:10 alignment:NSTextAlignmentRight];
        numLab.text = [NSString stringWithFormat:@"%ld个优惠",activityList.count];
        numLab.frame = CGRectMake(nextImgView.minX-45, 9, 40, 18);
        [activityView addSubview:numLab];
    }else{
        //没有活动
        activityView.mj_h = 0;
    }
}

#pragma mark - 店铺照片下面的底部视图
//满减活动 、 营业时间 、 公告
- (void)createDeatailInfoView
{
    CGFloat max_Y = 0;
    _shopScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _IMG_HEIGHT, self.width, self.height - _IMG_HEIGHT)];
    _shopScrollView.contentSize = CGSizeMake(self.width, 1000);
    _shopScrollView.showsVerticalScrollIndicator = NO;
    _shopScrollView.bounces = YES;
    [self addSubview:_shopScrollView];
    
    [self bringSubviewToFront:_shopImgView];
    //间隔
    UILabel *lineLab = [UITool lineLabWithFrame: CGRectMake(0, 88, self.width, 10)];
    lineLab.backgroundColor = kColor_LightGrayColor;
    [_shopScrollView addSubview:lineLab];
    
    max_Y = lineLab.maxY;
    
    //*******************************优惠券活动************************************
    NSArray *couponList = _shopModel.couponList;
    
    if (couponList.count > 0) {
        UIScrollView *couponScorllView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, lineLab.maxY, self.width, 100)];
        couponScorllView.showsHorizontalScrollIndicator = NO;
        [_shopScrollView addSubview:couponScorllView];
        
        for (int i = 0; i<couponList.count; i++) {
            CouponListModel *couponModel = couponList[i];
            UIView *couponView = [[UIView alloc]initWithFrame:CGRectMake(10+(210 + 20)*i, 10, 210, 80)];
            [couponScorllView addSubview:couponView];
            //优惠券图片
            UIImageView *couponImgView = [[UIImageView alloc]init];
            couponImgView.frame = couponView.bounds;
            couponImgView.tag = 50;
            couponImgView.image = kImage_Name(@"bg_coupon_red");
            if ([couponModel.couponNumber integerValue] <= 0)
            {
                couponImgView.image = kImage_Name(@"bg_coupon_yellow");
            }
            
            [couponView addSubview:couponImgView];
            //优惠券价格
            UILabel *priceLab = [UITool createLabelWithFrame:CGRectMake(14, 9, 100, 20) backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0xFE5A2B) textSize:Size(20) alignment:NSTextAlignmentLeft lines:1];
            priceLab.text = [NSString stringWithFormat:@"¥%@",couponModel.couponPrice];
            [couponView addSubview:priceLab];
            //满多少钱可用
            UILabel *moreThanLab = [UITool createLabelWithFrame:CGRectMake(14, 40, 100, 14) backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0xFD8F33) textSize:14 alignment:NSTextAlignmentLeft lines:1];
            moreThanLab.text = [NSString stringWithFormat:@"满%@可用",couponModel.couponCondition];
            [couponView addSubview:moreThanLab];
            //时间
            
            UILabel *timeLab = [UITool createLabelWithFrame:CGRectMake(14, 59, 140, 10) backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0xFD8F33) textSize:10 alignment:NSTextAlignmentLeft lines:1];
            NSString *time = [ToolManager returnTime:couponModel.couponTime format:@"yyyy.MM.dd HH:mm"];
            timeLab.text = [NSString stringWithFormat:@"%@前使用",time];
            [couponView addSubview:timeLab];
            //领取
            UILabel *getLab = [UITool createLabelWithFrame:CGRectMake(couponView.width-4-60, 0, 60, 80) backgroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] textSize:16 alignment:NSTextAlignmentCenter lines:2];
            getLab.text = @"立即\n领取";
            if ([couponModel.couponNumber integerValue] <= 0)
            {
                getLab.text = @"已使用";
            }
            getLab.tag = 51;
            [couponView addSubview:getLab];
            
            [couponScorllView setContentSize:CGSizeMake(couponView.maxX+20, 100)];
            
            UITapGestureRecognizer *couponTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getCouponClick:)];
            couponView.tag = i+100;
            [couponView  addGestureRecognizer:couponTap ];
        }
        
        UILabel *lineLab2 = [UITool lineLabWithFrame: CGRectMake(0, couponScorllView.maxY, self.width, 10)];
        lineLab2.backgroundColor = kColor_LightGrayColor;
        [_shopScrollView addSubview:lineLab2];
        
        max_Y = lineLab2.maxY;
    }
    //*******************************满减活动************************************
    NSArray *activityList = _shopModel.activityList;
    if (activityList.count > 0) {
        //满减活动
        UIView *activityView2 = [[UIView alloc]initWithFrame:CGRectMake(0, max_Y, self.width, 36)];
        [_shopScrollView addSubview:activityView2];
        //
        for (int i = 0; i<activityList.count; i++) {
            
            CouponListModel *couponListModel = activityList[i];
            UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13+(14+11)*i, 14, 14)];
            //1.限时折扣  2.满减  3.优惠券
            if ([couponListModel.activeType integerValue] == 1) {
                iconView.image = kImage_Name(@"icon-discounts");
            }else if ([couponListModel.activeType integerValue] == 2)
            {
                iconView.image = kImage_Name(@"icon-sale");
            }
            else if ([couponListModel.activeType integerValue] == 3)
            {
                iconView.image = kImage_Name(@"icon-coupons");
            }
            [activityView2 addSubview:iconView];
            //活动名称
            UILabel *activityLab = [UITool createLabelWithTextColor:kColor_TitleColor textSize:12 alignment:NSTextAlignmentLeft];
            activityLab.text = couponListModel.activeTitle;
            activityLab.frame = CGRectMake(iconView.maxX+10, 15+(12+11)*i, self.width-(iconView.maxX+10+60), 12);
            [activityView2 addSubview:activityLab];
            
            activityView2.mj_h = activityLab.maxY+11;
        }
        //
        UIImageView *nextImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width-20, 13, 10, 10)];
        nextImgView.image = kImage_Name(@"icon_up_black");
        [activityView2 addSubview:nextImgView];
        
        UIControl *foldingBT = [[UIControl alloc]init];
        [foldingBT addTarget:self action:@selector(moveUpClick:) forControlEvents:UIControlEventTouchUpInside];
        foldingBT.frame = CGRectMake(activityView2.maxX-50, 0, 50, activityView2.height);
        [activityView2 addSubview:foldingBT];
        
        UILabel *lineLab3 = [UITool lineLabWithFrame: CGRectMake(0, activityView2.maxY, self.width, 0.5)];
        lineLab3.backgroundColor = kColor_bgHeaderViewColor;
        [_shopScrollView addSubview:lineLab3];
        
        UITapGestureRecognizer *activityTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(activityTap:)];
        [activityView2 addGestureRecognizer:activityTap];
        
        max_Y = lineLab3.maxY;
    }
    
    //营业时间
    if (_shopModel.openHour.length == 0 || !_shopModel.openHour) {
        //如果营业时间不存在
    }else{
        UILabel *textLab = [UITool createLabelWithTextColor:kColor_TitleColor textSize:14 alignment:NSTextAlignmentLeft];
        textLab.frame = CGRectMake(10, max_Y+10, self.width, 14);
        [_shopScrollView addSubview:textLab];
        textLab.text = @"营业时间";
        
        UILabel *timeLab = [UITool createLabelWithTextColor:kColor_GrayColor textSize:12 alignment:NSTextAlignmentLeft];
        timeLab.frame = CGRectMake(10, textLab.maxY+10, self.width, 12);
        timeLab.text = _shopModel.openHour;
        [_shopScrollView addSubview:timeLab];
        
        max_Y = timeLab.maxY;
    }
    
    //公告
    UILabel *noticeLab = [UITool createLabelWithTextColor:kColor_TitleColor textSize:14 alignment:NSTextAlignmentLeft];
    noticeLab.frame = CGRectMake(10, max_Y+15, 42, 14);
    noticeLab.text = @"公告:";
    [_shopScrollView addSubview:noticeLab];
    
    UILabel *contentLab = [UITool createLabelWithTextColor:kColor_GrayColor textSize:12 alignment:NSTextAlignmentLeft];
    contentLab.frame = CGRectMake(10, noticeLab.maxY+10, self.width-20, 12);
    [_shopScrollView addSubview:contentLab];
    NSString *text = _shopModel.shopNotice;
    if (text.length == 0||!text) {
        text = @"暂无公告";
    }
    contentLab.text = text;
    contentLab.font = kFont(12);
    contentLab.numberOfLines = 0;
    contentLab.mj_w = self.width - (noticeLab.maxX+20);
    CGSize size = [AppMethods sizeWithFont:kFont(12) Str:text withMaxWidth:contentLab.mj_w];
    contentLab.mj_h = size.height;
    if (size.height < 18) {
        contentLab.mj_h = 12;
    }
    
    _shopScrollView.contentSize = CGSizeMake(self.width, contentLab.maxY+10);
}

- (void)setBottomView{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 25, self.width, 63)];
    [_shopScrollView addSubview:bottomView];
    bottomView.alpha = 0.0;
    _bottomView = bottomView;
    //店铺名称
    UILabel *shopNameLab = [UITool createLabelWithTextColor:kColor_darkBlackColor textSize:kScreenWidth<375?Size(18):18 alignment:NSTextAlignmentCenter];
    shopNameLab.text = _shopModel.shopName;
    [bottomView addSubview:shopNameLab];
    [shopNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomView);
        make.height.mas_offset(26);
        make.top.mas_equalTo(0);
    }];
    //店铺图标
    UIImageView *shopIcon = [[UIImageView alloc]init];
    shopIcon.image = kImage_Name(@"icon_brd_big");
    [bottomView addSubview:shopIcon];
    [shopIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(shopNameLab.mas_left).offset(-6);
        make.height.mas_offset(16);
        make.centerY.mas_equalTo(shopNameLab);
        
    }];
    //店铺认证
    UIView *cerView = [self setShopGradeAndCerViewWithType:@"2"];
    [bottomView addSubview:cerView];
    [cerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(shopNameLab.mas_bottom).offset(6);
        make.centerX.mas_equalTo(bottomView);
        make.height.mas_offset(18);
        make.width.mas_offset(cerView.width);
    }];
}

#pragma mark - 店铺评分视图
- (UIView *)setShopGradeAndCerViewWithType:(NSString *)type {
    
    CGFloat max_X = 0;
    UIView *cerView = [[UIView alloc]init];
    //店铺评价
    //分数
    UILabel *gradeLab = [UITool createLabelWithTextColor:UIColorFromRGB(0xFFCD20) textSize:kScreenWidth<375?Size(18):18 alignment:NSTextAlignmentLeft];
    NSString *grade = [NSString stringWithFormat:@"%@分",@"4.9"];
    NSMutableAttributedString *str = [AppDefaultUtil returnStringSize:grade rang:NSMakeRange(grade.length - 1,1) size:12];
    gradeLab.attributedText = str;
    gradeLab.adjustsFontSizeToFitWidth = YES;
    CGSize gradeSize = [AppMethods sizeWithFont:kFont(12) Str:grade withMaxWidth:100];
    gradeLab.frame = CGRectMake(max_X, 0, gradeSize.width+2, 18);
    [cerView addSubview:gradeLab];
    //超出预期
    UILabel *yuQiLab = [UITool createLabelWithTextColor:UIColorFromRGB(0xFFCD20) textSize:12 alignment:NSTextAlignmentLeft];
    yuQiLab.text = [ToolManager returnYuQiType:@"4.9"];
    CGSize yuQiSize = [AppMethods sizeWithFont:kFont(12) Str:yuQiLab.text withMaxWidth:100];
    yuQiLab.frame = CGRectMake(gradeLab.maxX+5, 4, yuQiSize.width+5, 14);
    
    [cerView addSubview:yuQiLab];
    
//    if ([_shopModel.commScore floatValue] == 0) {
//        gradeLab.hidden = YES;
//        yuQiLab.hidden = YES;
//        //暂无评论
//        UILabel *noCommentLab = [UITool createLabelWithTextColor:UIColorFromRGB(0xFFCD20) textSize:12 alignment:NSTextAlignmentLeft];
//        noCommentLab.text = @"暂无评论";
//        CGSize size = [AppMethods sizeWithFont:kFont(12) Str:@"暂无评论" withMaxWidth:150];
//        noCommentLab.frame = CGRectMake(max_X, 0, size.width, 25);
//        [cerView addSubview:noCommentLab];
//
//        cerView.mj_w = noCommentLab.maxX;
//    }
    
    //月售
    UILabel *line = [UITool lineLabWithFrame:CGRectMake(yuQiLab.maxX+8, 1, 2, 16)];
    line.backgroundColor = UIColorFromRGB(0xF4F4F4);
//    line.alpha = 0.6;
    [cerView addSubview:line];
    
    UILabel *sellCountLab = [UITool createLabelWithTextColor:kColor_ButonCornerColor textSize:12 alignment:NSTextAlignmentLeft];
    sellCountLab.text = @"月售1088";
    CGSize sellSize = [AppMethods sizeWithFont:kFont(12) Str:sellCountLab.text withMaxWidth:100];
    sellCountLab.frame = CGRectMake(line.maxX+8, 2, sellSize.width, 16);
    [cerView addSubview:sellCountLab];
    
    cerView.mj_w = sellCountLab.maxX;
    
    return cerView;
}

- (void)createMoveUpView
{
    //渐变
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor, (__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.5);
    gradientLayer.frame = CGRectMake(0, self.height-30, self.width, 30);
    [self.layer addSublayer:gradientLayer];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake((self.width - 20)/2, self.height-27, 20, 20);
    imageView.userInteractionEnabled = YES;
    imageView.image = kImage_Name(@"icon-Slidingback");
    [self addSubview:imageView];
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, self.height-90, self.width, 90);
    [self addSubview:view];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeClick:)];
    swipe.delegate = self;
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [view addGestureRecognizer:swipe];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moveUpTap:)];
    tap.delegate = self;
    [view addGestureRecognizer:tap];
}

#pragma mark - ShopProductListViewDelegate  --滚动监听
//滚动
- (void)ListScrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    if (scrollView == _productListView ) {
        if (offset <= 0 && !_isStopAnimation) {
            //满减活动的透明度
            CGFloat rate = -offset/30;
            if (rate >= 1) {
                rate = 1;
            }
            if (rate <= 0) {
                rate = 0;
            }
            _activityView.alpha = 1.0 * (1.0-rate);
            //店铺信息的透明度
            CGFloat infoViewRate = -offset/50;
            _infoView.alpha = 1.0 *(1.0-infoViewRate);
            //店铺名称和认证的透明度
            CGFloat nameRate = -offset/65;
            if (nameRate >= 1) {
                nameRate = 1;
            }
            if (_infoView.alpha <0.5) {
                _bottomView.alpha = 1.0 *nameRate;
            }else{
                _bottomView.alpha = 0;
            }
            //店铺照片的平移动画
            CGFloat distance = self.width/2 - 55;
            CGFloat imgRate = -offset/65;
            if (imgRate >=1.0) {
                imgRate = 1.0;
            }
            _shopImgView.mj_x = imgRate*distance +10;
        }else{
            //满减活动的透明度
            _activityView.alpha = 1.0;
            //店铺信息的透明度
            _infoView.alpha = 1.0 ;
            //店铺名称和认证的透明度
            _bottomView.alpha = 0.0;
            //店铺照片的平移动画
            _shopImgView.mj_x = 10;
            _isStopAnimation = NO;
        }
    }
    
    [self didScorll:scrollView];
}

- (void)ListScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    if (offset <= -80) {
        //如果下滑偏移量小于-80,禁止动画执行
        _isStopAnimation = YES;
    }else{
        _isStopAnimation = NO;
    }
}

- (void)ListScrollViewDropDown:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3 animations:^{
        scrollView.transform = CGAffineTransformMakeTranslation(0, self.height);
        //满减活动的透明度
        _activityView.alpha = 0.0;
        //店铺信息的透明度
        _infoView.alpha = 0.0 ;
        //店铺照片的平移动画
        CGFloat distance = self.width/2 - 55;
        _shopImgView.mj_x = distance + 10;
        _isStopAnimation = NO;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            //店铺名称和认证的透明度
            _bottomView.alpha = 1.0;
        }];
        _productListView.isStopAnimation = YES;
        _productListView.contentOffset = CGPointZero;
    }];
    
    //导航条恢复原状
    [self navBarState];
}

#pragma mark - 商品、评价、商家列表视图
- (ShopScrollView *)productListView
{
    if (!_productListView) {
        _productListView = [[ShopScrollView alloc]initWithFrame:CGRectMake(0, kDefaultNavBarHeight, self.width, self.height - kDefaultNavBarHeight) withShopModel:_shopModel withGroupID:_groupId currentVC:[self viewController]];
        _productListView.showsVerticalScrollIndicator = NO;
        _productListView.scrollDelegate = self;
    }
    return _productListView;
}

#pragma mark - 导航条
- (void)setUpNavBarView
{
    UIView *navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, kDefaultNavBarHeight)];
    navBarView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];//透明度
    [self addSubview:navBarView];
    self.navBarView = navBarView;
    //返回按钮
    UIButton *backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 20+kDefaultNavBar_SubView_MinY, 54, 44);
    [backBT setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
    [backBT setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateHighlighted];
    backBT.titleLabel.font=[UIFont systemFontOfSize:16];
    [backBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBT setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0 ,0)];
    [backBT setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    [backBT addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:backBT];
    _backBT = backBT;
    
    //搜索框
    UIView *sousuoView = [[UIView alloc]initWithFrame:CGRectMake(self.width-37*4-10, 20+kDefaultNavBar_SubView_MinY+ 5 + 5, 37, 24)];
    sousuoView.backgroundColor =[UIColorFromRGB(0xF4F4F4) colorWithAlphaComponent:0.0];
    [navBarView addSubview:sousuoView];
    _sousuoView = sousuoView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchClick:)];
    [_sousuoView addGestureRecognizer:tap];
    
    _sousuoLab = [UITool createLabelWithFrame:CGRectMake(30, 2, 120, 20) backgroundColor:[UIColor clearColor] textColor:kColor_GrayColor textSize:Size(12) alignment:NSTextAlignmentLeft lines:1];
    _sousuoLab.text = @"请输入商品名称";
    [sousuoView addSubview:_sousuoLab];
    _sousuoLab.textColor = [kColor_GrayColor colorWithAlphaComponent:0];
    
    //搜索 信息  收藏 更多
    NSArray *imgAray = @[@"sousuo_white",@"collect_white",@"message_white"];
    for (int i = 0; i<3; i++) {
        UIButton *itemBT  = [UIButton buttonWithType:UIButtonTypeCustom];
        itemBT.frame = CGRectMake(self.width-37*(3-i)-5, 20+kDefaultNavBar_SubView_MinY+5, 37, 34);
        [itemBT setImage:kImage_Name(imgAray[i]) forState:UIControlStateNormal];
        [itemBT addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        itemBT.tag = i + 1;
        [navBarView addSubview:itemBT];
        if (i == 2) {
            if (_isCollect) {
                //已经收藏
                [itemBT setImage:kImage_Name(@"Already collected")   forState:UIControlStateNormal];
            }
        }
        if (i == 3) {
            //            UILabel *redLab = [[UILabel alloc]init];
            //            redLab.backgroundColor = [UIColor redColor];
            //            redLab.layer.cornerRadius = 2;
            //            redLab.layer.masksToBounds = YES;
            //            redLab.frame = CGRectMake(31, 8, 4, 4);
            //            [itemBT addSubview:redLab];
        }
    }
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    //推荐回调
    if (index == 0) {
        //购物车
       
    }else{
        //消息中心
      
    }
}

-(void)shopCartBtn{
}

- (void)ybPopupMenuBeganDismiss
{
    
}

- (UITableViewCell *)ybPopupMenu:(YBPopupMenu *)ybPopupMenu cellForRowAtIndex:(NSInteger)index
{
    static NSString * identifier = @"customCell";
    CustomTestCell * cell = [ybPopupMenu.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomTestCell" owner:self options:nil] firstObject];
    }
    cell.titleLabel.text = TITLES[index];
    cell.iconImageView.image = [UIImage imageNamed:ICONS[index]];
    switch (index) {
        case 0:
            cell.redLab.hidden = YES;
            break;
        case 1:
            cell.redLab.hidden = YES;
            break;
    }
    return cell;
}

#pragma mark - 导航栏渐变
- (void)didScorll:(UIScrollView *)scorllView
{
    CGFloat offsetY = scorllView.contentOffset.y;
    
    _alpha = offsetY/_maxOffset_Y;
    if (_alpha > 1) {
        _alpha = 1;
    }
    if (_alpha < 0) {
        _alpha = 0;
    }
//    CGFloat alpha2 = MIN(1, fabs((offsetY - _startChange_Y)/(_maxOffset_Y - _startChange_Y)));
    CGFloat alpha2 = 0;
    if (_alpha >= 0.6) {
        alpha2 = (_alpha - 0.6)/0.4;
    }
    if (offsetY > NAVBAR_CHANGE_POINT) {
        self.navBarView.backgroundColor = [styleColor  colorWithAlphaComponent:_alpha];
    } else {
        self.navBarView.backgroundColor = [styleColor  colorWithAlphaComponent:0];
    }
    UIButton *sousuBT = (UIButton *)[_navBarView viewWithTag:1];
    UIButton *collectBT = (UIButton *)[_navBarView viewWithTag:2];
    UIButton *messageBT = (UIButton *)[_navBarView viewWithTag:3];
    
    CGFloat startLoc = self.width-37*3-5;
    CGFloat endLoc = _backBT.maxX;
    CGFloat distance =  startLoc  -  endLoc;
    if (offsetY <= _maxOffset_Y && offsetY >= 0) {
        //18x18
        if (offsetY >= _startChange_Y) {
            CGFloat imgRate = (offsetY - _startChange_Y)/(_maxOffset_Y - _startChange_Y);
            if (imgRate >= 1) {
                imgRate = 1;
            }
            sousuBT.frame = CGRectMake(startLoc - imgRate*distance, 20+kDefaultNavBar_SubView_MinY+5, 37, 34);
            CGFloat imgRate2 = imgRate*3.5;
            if (imgRate2 >= 1) {
                imgRate2 = 1;
            }
            if (imgRate2  >= 1) {
                [sousuBT setImage:kImage_Name(@"icon-search box") forState:UIControlStateNormal];
            }else{
                [sousuBT setImage:kImage_Name(@"sousuo_white") forState:UIControlStateNormal];
            }
            sousuBT.imageEdgeInsets = UIEdgeInsetsMake(8*imgRate2, 8*imgRate2, 8*imgRate2, 8*imgRate2);
            _sousuoView.mj_x = sousuBT.mj_x;
            _sousuoLab.mj_x = 30;
            _sousuoView.backgroundColor = [UIColorFromRGB(0xF4F4F4) colorWithAlphaComponent:alpha2];
            if (_alpha >= 0.8) {
                _sousuoLab.textColor = [kColor_GrayColor colorWithAlphaComponent:_alpha];
            }else{
                _sousuoLab.textColor = [kColor_GrayColor colorWithAlphaComponent:0];
            }
            CGFloat sousuoBgRate = (offsetY - _startChange_Y)/(_maxOffset_Y- _startChange_Y);
            if (sousuoBgRate >= 1) {
                sousuoBgRate = 1;
            }
            _sousuoView.mj_w = distance*sousuoBgRate + 37;
        }
    }else{
        sousuBT.frame = CGRectMake(startLoc, 20+kDefaultNavBar_SubView_MinY+5, 37, 34);
        [sousuBT setImage:kImage_Name(@"sousuo_white") forState:UIControlStateNormal];
        sousuBT.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _sousuoView.backgroundColor = [UIColorFromRGB(0xF4F4F4) colorWithAlphaComponent:0];
        _sousuoView.mj_x = sousuBT.mj_x;
        _sousuoView.mj_w =  37;
        _sousuoLab.mj_x = 30;
        _sousuoLab.textColor = [kColor_GrayColor colorWithAlphaComponent:0];
    }
    
    if (_alpha >= 0.5) {
        [_backBT   setImage:kImage_Name(@"back_grey")    forState:UIControlStateNormal];
        [messageBT setImage:kImage_Name(@"message_grey") forState:UIControlStateNormal];
        [collectBT setImage:kImage_Name(@"collect_grey") forState:UIControlStateNormal];
    }else{
        [_backBT   setImage:kImage_Name(@"icon_back_white") forState:UIControlStateNormal];
        [messageBT setImage:kImage_Name(@"message_white")   forState:UIControlStateNormal];
        [collectBT setImage:kImage_Name(@"collect_white")   forState:UIControlStateNormal];
    }
    if (_isCollect) {
        //已经收藏
        [collectBT setImage:kImage_Name(@"Already collected")   forState:UIControlStateNormal];
    }
    if (_alpha >= 0.8) {
        //         [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }else{
        //        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}

//导航条颜色
- (void)setupViews
{
    styleColor = [UIColor whiteColor];
    self.navBarView.backgroundColor = [styleColor  colorWithAlphaComponent:0];
}

- (void)navBarState
{
    UIButton *sousuBT = (UIButton *)[_navBarView viewWithTag:1];
     UIButton *collectBT = (UIButton *)[_navBarView viewWithTag:2];
    UIButton *messageBT = (UIButton *)[_navBarView viewWithTag:3];
    CGFloat startLoc = self.width-37*3-5;
    [UIView animateWithDuration:0.1 animations:^{
        _sousuoLab.textColor = [kColor_GrayColor colorWithAlphaComponent:0];
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.navBarView.backgroundColor = [styleColor  colorWithAlphaComponent:0];
        sousuBT.frame = CGRectMake(startLoc, 20+kDefaultNavBar_SubView_MinY+5, 37, 34);
        sousuBT.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _sousuoView.mj_x = sousuBT.mj_x;
        _sousuoLab.mj_x = 30;
        _sousuoView.backgroundColor = [UIColorFromRGB(0xF4F4F4) colorWithAlphaComponent:0];
        _sousuoView.mj_w =  37;
        [sousuBT   setImage:kImage_Name(@"sousuo_white") forState:UIControlStateNormal];
        [messageBT setImage:kImage_Name(@"message_white")   forState:UIControlStateNormal];
        [collectBT setImage:kImage_Name(@"collect_white")   forState:UIControlStateNormal];
        if (_isCollect) {
            //已经收藏
            [collectBT setImage:kImage_Name(@"Already collected")   forState:UIControlStateNormal];
        }
    } completion:^(BOOL finished) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }];
}

#pragma mark -  [店铺详情]
//根据容器ID,获取对应的源ID
-(void)requestGetProductGroupInfo_new {

    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shop.json" ofType:nil]];
    [self analysisData:dataDict];
    
}

- (void)analysisData:(NSDictionary *)dic
{
    /*
     #define maxOffsetY (200 + 48 - kDefaultNavBarHeight)
     #define maxOffsetY2 (200 + 48 - kDefaultNavBarHeight - 28)
     */
    _shopModel = [[NewShopModel alloc]initWithDictionary:dic error:nil];
    NSArray *activityList = _shopModel.activityList;
    if (activityList.count > 0) {
        _maxOffset_Y = (Size(150) + 48 - kDefaultNavBarHeight);
        _startChange_Y = 21 + 28;
    }else{
        _maxOffset_Y = (Size(150) + 48 - kDefaultNavBarHeight - 28);
        _startChange_Y = 21;
    }
    _isCollect = [_shopModel.isCollection integerValue];
    [self setHeaderView];//顶部视图
    [self setShopInfoView];//店铺信息视图
    [self createDeatailInfoView]; //优惠券、满减活动等信息视图
    [self setBottomView];//认证、店铺评分
    [self setActivityView];//店铺照片下面的满减活动视图
    [self createMoveUpView];//点击按钮弹出滚动视图
    [self setUpNavBarView];//创建导航栏
    //创建滚动视图
    [self addSubview:self.productListView];
}

#pragma mark 手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
