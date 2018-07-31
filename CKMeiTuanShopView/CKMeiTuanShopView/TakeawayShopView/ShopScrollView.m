//
//  ShopScrollView.m
//  AppPark
//
//  Created by 池康 on 2018/7/10.
//

#import "ShopScrollView.h"
#import "ShopHomePageView.h"//商家主页
#import "ShopEvaluateView.h"//评价视图
#import "ShopMerchantView.h"//商家视图
#import "LJDynamicItem.h"
/*f(x, d, c) = (x * d * c) / (d + c * x)
 where,
 x – distance from the edge
 c – constant (UIScrollView uses 0.55)
 d – dimension, either width or height*/

static CGFloat rubberBandDistance(CGFloat offset, CGFloat dimension) {
    const CGFloat constant = 0.55f;
    CGFloat result = (constant * fabs(offset) * dimension) / (dimension + constant * fabs(offset));
    // The algorithm expects a positive offset, so we have to negate the result if the offset was negative.
    return offset < 0.0f ? -result : result;
}

@interface ShopScrollView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UILabel        *_scrollLab;
    NSInteger       _lastIndex;
    NSInteger       _currentIndex;
    CGFloat          currentScorllY;
    __block BOOL     isVertical;//是否是垂直
    NSMutableArray *_scorllArray;
    UIButton       *_evaluateBT;
    NSInteger       _sys_moduleType;
    NSInteger       _maxOffset_Y;
}
@property (nonatomic , strong) UIView                   *menuView;//最底层的菜单视图
@property (nonatomic , strong) UIScrollView             *subScrollView;//横向水平滚动视图
@property (nonatomic , strong) ShopHomePageView         *shopHomePageView;//商家列表主页,二级联动
@property (nonatomic , strong) ShopMerchantView         *merchantView;//商家视图
@property (nonatomic , strong) ShopEvaluateView         *shopEvaluateView;//评价视图
@property (nonatomic , strong) UIScrollView             *subTableView;//获取当前页面的子tableView.
@property (nonatomic , strong) NewShopModel             *shopModel;//数据模型

//弹性和惯性动画
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, weak)   UIDynamicItemBehavior *decelerationBehavior;
@property (nonatomic, strong) LJDynamicItem *dynamicItem;
@property (nonatomic, weak)   UIAttachmentBehavior *springBehavior;
@end

@implementation ShopScrollView

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame  withShopModel:(NewShopModel *)model  withGroupID:(NSString *)groupId currentVC:(UIViewController *)currentVC
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.scrollEnabled = NO;
        _currentVC = currentVC;
        _lastIndex = 1;
        _currentIndex = 1;
        _shopModel = model;
        _groupId = groupId;
        NSArray *activityList = _shopModel.activityList;//活动数组
        if (activityList.count > 0) {
            _maxOffset_Y = (Size(150) + 48 - kDefaultNavBarHeight);
        }else{
            _maxOffset_Y = (Size(150) + 48 - kDefaultNavBarHeight - 28);
        }
        self.contentSize = CGSizeMake(self.width, self.height + _maxOffset_Y);
        //创建顶部视图，商品,评价,商家
        [self createTopMenuView];
        //创建上下滑动的scrollview
        [self addSubview:self.subScrollView];
#warning mark - 在这里暂时改变商家主页样式
        self.shopViewType = 1;//
        [self.subScrollView addSubview:self.shopHomePageView];//店铺主页
        [self.subScrollView addSubview:self.shopEvaluateView];//评价
        [self.subScrollView addSubview:self.merchantView];//商家
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizerAction:)];
        pan.delegate = self;
        [self addGestureRecognizer:pan];
        
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
        self.dynamicItem = [[LJDynamicItem alloc] init];
        
        self.subTableView = [self currentSubTableView];
       
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllBehaviors:) name:@"removeAllBehaviors" object:nil];
    }
    return self;
}

////删除所有动力行为。
- (void)removeAllBehaviors:(NSNotification *)not
{
    [self.animator removeAllBehaviors];
}

#pragma mark - 控制方法
//下拉，显示店铺详情
- (void)dropDownTap:(UITapGestureRecognizer *)tap
{
    //点击顶部，让整个滚动视图平移
    if ([self.scrollDelegate respondsToSelector:@selector(ListScrollViewDropDown:)]) {
        //删除所有动力行为。
        [self.animator removeAllBehaviors];
        [self.scrollDelegate ListScrollViewDropDown:self];
    }
}

#pragma mark - 创建顶部菜单视图
//创建顶部菜单视图 商品,评价,商家
- (void)createTopMenuView
{
    //1:顶部高度为_maxOffset_Y，背景透明，可以点击
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, _maxOffset_Y)];
    topView.userInteractionEnabled = YES;
    [self addSubview:topView];
    //2:添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dropDownTap:)];
    [topView addGestureRecognizer:tap];
    //3:创建 商品,评价,商家
    UIView *menuView = [[UIView alloc]initWithFrame:CGRectMake(0, _maxOffset_Y, self.width, 36)];
    menuView.backgroundColor = [UIColor whiteColor];
    [self addSubview:menuView];
    _menuView = menuView;
    //商品
    CGFloat button_W = self.width/3;
    UIButton *productBT = [UITool createButtonWithFrame:CGRectMake(0, 0, button_W, menuView.height) title:@"商品" backgroundColor:[UIColor whiteColor] titleColor:kColor_darkBlackColor target:self selector:@selector(btnClick:) tag:1];
    productBT.titleLabel.font = kFont(14);
    [productBT setBackgroundImage:[AppMethods createImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    [menuView addSubview:productBT];
    //评价
    UIButton *evaluateBT = [UITool createButtonWithFrame:CGRectMake(button_W, 0, button_W, menuView.height) title:[NSString stringWithFormat:@"评价(%@)",@"0"] backgroundColor:[UIColor whiteColor] titleColor:kColor_TitleColor target:self selector:@selector(btnClick:) tag:2];
    evaluateBT.titleLabel.font = kFont(14);
    [evaluateBT setBackgroundImage:[AppMethods createImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    [menuView addSubview:evaluateBT];
    _evaluateBT = evaluateBT;
    [_evaluateBT setTitle:[NSString stringWithFormat:@"评价(%@)",[_shopModel.commCount integerValue] >999?@"999+":_shopModel.commCount] forState:UIControlStateNormal] ;
    //商家
    UIButton *merchantBT = [UITool createButtonWithFrame:CGRectMake(button_W*2, 0, button_W, menuView.height) title:@"商家" backgroundColor:[UIColor whiteColor] titleColor:kColor_TitleColor target:self selector:@selector(btnClick:) tag:3];
    merchantBT.titleLabel.font = kFont(14);
    [merchantBT setBackgroundImage:[AppMethods createImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    [menuView addSubview:merchantBT];
    
    UILabel *line = [UITool lineLabWithFrame:CGRectMake(0, menuView.height-SINGLE_LINE_WIDTH, self.width, SINGLE_LINE_WIDTH)];
    line.backgroundColor = kColor_bgHeaderViewColor;
    [menuView addSubview:line];
    //4:可移动的底部滑竿
    _scrollLab = [[UILabel alloc]init];
    _scrollLab.frame = CGRectMake(productBT.center.x-10, menuView.height-2, 20, 2);
    _scrollLab.backgroundColor = [UIColor redColor];
    [menuView addSubview:_scrollLab];
}

#pragma mark -  UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //委托 方法
    if (scrollView == self) {
        if (!_isStopAnimation) {
            if ([self.scrollDelegate respondsToSelector:@selector(ListScrollViewDidScroll:)]) {
                [self.scrollDelegate ListScrollViewDidScroll:scrollView];
            }
        }
        //设置二级联动的左tableview的偏移量
        if (_shopHomePageView) {
            [_shopHomePageView superScrollViewDidScrollOffset:scrollView.contentOffset.y];
        }
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bottomShopCartOffsetY" object:self userInfo:@{@"offsetY":[NSString stringWithFormat:@"%f",scrollView.mj_offsetY]}];
    }else if (scrollView == self.subScrollView )
    {
        CGFloat scorllOffsetW = self.subScrollView.width*2;
        CGFloat currentOffsetX =  self.subScrollView.contentOffset.x;
        CGFloat rate = currentOffsetX/scorllOffsetW;//速率
        CGFloat offset_X = self.width/3 * rate*2;
        _scrollLab.mj_x = offset_X+(self.width/3/2-10);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.subScrollView) {
        NSInteger index = self.subScrollView.contentOffset.x/self.subScrollView.frame.size.width;
        _currentIndex = index+1;
        UIButton *lastBT = (UIButton *)[_menuView viewWithTag:_lastIndex];
        UIButton *currentBT = (UIButton *)[_menuView viewWithTag:_currentIndex];
        [lastBT setTitleColor:kColor_TitleColor forState:UIControlStateNormal];
        [currentBT setTitleColor:kColor_darkBlackColor forState:UIControlStateNormal];
        _lastIndex = _currentIndex;
        self.subTableView = [self currentSubTableView];

    }
}

#pragma mark - 控制事件
- (void)btnClick:(UIButton *)btn
{
    NSInteger tag = btn.tag;
    _currentIndex = tag;
    UIButton *lastBT = (UIButton *)[_menuView viewWithTag:_lastIndex];
    [lastBT setTitleColor:kColor_TitleColor forState:UIControlStateNormal];
    [btn setTitleColor:kColor_darkBlackColor forState:UIControlStateNormal];
//    _scrollLab.mj_x = btn.center.x-10;
    _lastIndex = tag;
    if (tag == 1) {
        //商品
        [self.animator removeAllBehaviors];
    }else if (tag == 2){
        //评价
        [self.animator removeAllBehaviors];
    }else if (tag == 3){
        //商家
        [self.animator removeAllBehaviors];
    }
    [self.subScrollView setContentOffset:CGPointMake((_lastIndex-1)*self.subScrollView.width, 0) animated:YES];
    self.subTableView = [self currentSubTableView];
}

#pragma mark 手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGFloat currentY = [recognizer translationInView:self].y;
        CGFloat currentX = [recognizer translationInView:self].x;
        if (currentY == 0.0) {
            isVertical = NO;
            return YES;
        } else {
            if (fabs(currentX)/fabs(currentY) >= 5.0) {
                isVertical = NO;
                return YES;
            } else {
                isVertical = YES;
                return NO;
                
            }
        }
    }
    return NO;
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)recognizer {
    _isStopAnimation = NO;
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            currentScorllY = self.contentOffset.y;
            if (isVertical) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GestureRecognizerStateBegan" object:self];
            }
            [self.animator removeAllBehaviors];
            break;
        case UIGestureRecognizerStateChanged:
        {
            //locationInView:获取到的是手指点击屏幕实时的坐标点；
            //translationInView：获取到的是手指移动后，在相对坐标中的偏移量
            if (isVertical) {
                //往上滑为负数，往下滑为正数
                CGFloat currentY = [recognizer translationInView:self].y;
                //                NSLog(@"currentY....%f",currentY);
                [self controlScrollForVertical:currentY AndState:UIGestureRecognizerStateChanged];
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
            
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (isVertical) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GestureRecognizerStateEnded" object:self];
                if (self.contentOffset.y <= -100) {
                    //向下滑动
                    if ([self.scrollDelegate respondsToSelector:@selector(ListScrollViewDropDown:)]) {
                        [self.scrollDelegate ListScrollViewDropDown:self];
                    }
                }
                else{
                    self.dynamicItem.center = CGPointMake(0, 0);
                    //velocity是在手势结束的时候获取的竖直方向的手势速度
                    CGPoint velocity = [recognizer velocityInView:self];
                    UIDynamicItemBehavior *inertialBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.dynamicItem]];
                    [inertialBehavior addLinearVelocity:CGPointMake(0, velocity.y) forItem:self.dynamicItem];
                    // 通过尝试取2.0比较像系统的效果
                    inertialBehavior.resistance = 5.0;
                    __block CGPoint lastCenter = CGPointZero;
                    __weak typeof(self) weakSelf = self;
                    inertialBehavior.action = ^{
                        if (isVertical) {
                            //得到每次移动的距离
                            CGFloat currentY = weakSelf.dynamicItem.center.y - lastCenter.y;
                            [weakSelf controlScrollForVertical:currentY AndState:UIGestureRecognizerStateEnded];
                        }
                        lastCenter = weakSelf.dynamicItem.center;
                    };
                    [self.animator addBehavior:inertialBehavior];
                    self.decelerationBehavior = inertialBehavior;
                }
            }
        }
            break;
        default:
            break;
    }
    //保证每次只是移动的距离，不是从头一直移动的距离
    [recognizer setTranslation:CGPointZero inView:self];
}

//控制上下滚动的方法
- (void)controlScrollForVertical:(CGFloat)detal AndState:(UIGestureRecognizerState)state {
    //判断是主ScrollView滚动还是子ScrollView滚动,detal为手指移动的距离
    if (self.contentOffset.y >= _maxOffset_Y) {
        CGFloat offsetY = self.subTableView.contentOffset.y - detal;
        if (offsetY < 0) {
            //当子ScrollView的contentOffset小于0之后就不再移动子ScrollView，而要移动主ScrollView
            offsetY = 0;
            self.contentOffset = CGPointMake(self.frame.origin.x, self.contentOffset.y - detal);
        } else if (offsetY > (self.subTableView.contentSize.height - self.subTableView.frame.size.height)) {
            //当子ScrollView的contentOffset大于contentSize.height时
            offsetY = self.subTableView.contentOffset.y - rubberBandDistance(detal, self.height);
        }
        self.subTableView.contentOffset = CGPointMake(0, offsetY);
    }
    else {
        if (self.subTableView.contentOffset.y != 0 && detal >= 0) {
            
            CGFloat offsetY = self.subTableView.contentOffset.y - detal;
            if (offsetY < 0) {
                //当子ScrollView的contentOffset小于0之后就不再移动子ScrollView，而要移动主ScrollView
                offsetY = 0;
                self.contentOffset = CGPointMake(self.frame.origin.x, self.contentOffset.y - detal);
            } else if (offsetY > (self.subTableView.contentSize.height - self.subTableView.frame.size.height)) {
                //当子ScrollView的contentOffset大于contentSize.height时
                offsetY = self.subTableView.contentOffset.y - rubberBandDistance(detal, self.height);
            }
            self.subTableView.contentOffset = CGPointMake(0, offsetY);
            
        }else{
            CGFloat mainOffsetY = self.contentOffset.y - detal;
            if (mainOffsetY < 0) {
                //滚到顶部之后继续往上滚动需要乘以一个小于1的系数
                mainOffsetY = self.contentOffset.y - rubberBandDistance(detal, self.height);
                
            } else if (mainOffsetY > _maxOffset_Y) {
                mainOffsetY = _maxOffset_Y;
            }
            self.contentOffset = CGPointMake(self.frame.origin.x, mainOffsetY);
            
            if (mainOffsetY == 0) {
                self.subTableView.contentOffset = CGPointMake(0, 0);
            }
        }
    }
    
    BOOL outsideFrame = self.contentOffset.y < 0 || self.subTableView.contentOffset.y > (self.subTableView.contentSize.height - self.subTableView.frame.size.height);
    BOOL isMore = self.subTableView.contentSize.height >= self.subTableView.frame.size.height || self.contentOffset.y >= _maxOffset_Y||self.contentOffset.y < 0 ;
    if (isMore && outsideFrame &&
        (self.decelerationBehavior && !self.springBehavior)) {
        CGPoint target = CGPointZero;
        BOOL isMian = NO;
        if (self.contentOffset.y < 0) {
            self.dynamicItem.center = self.contentOffset;
            target = CGPointZero;
            isMian = YES;
        } else if (self.subTableView.contentOffset.y > (self.subTableView.contentSize.height - self.subTableView.frame.size.height)) {
            self.dynamicItem.center = self.subTableView.contentOffset;
            
            target = CGPointMake(self.subTableView.contentOffset.x, (self.subTableView.contentSize.height - self.subTableView.frame.size.height));
            //********池康--判断tableview的contentsize.height是否大于自身高度，从而控制滚动/
            if (self.subTableView.contentSize.height <= self.subTableView.frame.size.height) {
                target = CGPointMake(self.subTableView.contentOffset.x,0);
            }
            isMian = NO;
        }
        [self.animator removeBehavior:self.decelerationBehavior];
        __weak typeof(self) weakSelf = self;
        UIAttachmentBehavior *springBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.dynamicItem attachedToAnchor:target];
        springBehavior.length = 0;
        springBehavior.damping = 1;
        springBehavior.frequency = 2;
        springBehavior.action = ^{
            if (isMian) {
                weakSelf.contentOffset = weakSelf.dynamicItem.center;
                if (weakSelf.contentOffset.y == 0) {
                    self.subTableView.contentOffset = CGPointMake(0, 0);
                }
            } else {
                
                weakSelf.subTableView.contentOffset = self.dynamicItem.center;
            }
        };
        [self.animator addBehavior:springBehavior];
        self.springBehavior = springBehavior;
    }
}

#pragma mark - 公用方法
//移除手势
- (void)removeBehaviors
{
    [self.animator removeAllBehaviors];
}
//获取当前页面的子tableView.
- (UIScrollView *)currentSubTableView
{
    UIScrollView *tableView;
    //单
    switch (_currentIndex) {
        case 1:
        {
            //店铺主页样式
            if (self.shopViewType == ShopModuleTypeList) {
                //列表样式
                 tableView = self.shopHomePageView.rightTabView;
            }else if (self.shopViewType == ShopModuleTypeCard){
                //卡片样式
                 tableView = self.shopHomePageView.rightTabView;
            }else{
                //宫格样式
                 tableView = self.shopHomePageView.collectionView;
            }
        }
            break;
        case 2:
        {
            tableView = self.shopEvaluateView.tableView;
        }
            break;
        case 3:
        {
            tableView = self.merchantView.tableView;
        }
            break;
            
        default:
            break;
    }
    return tableView;
}

#pragma mark - 懒加载
- (UIScrollView *)subScrollView {
    if (_subScrollView == nil) {
        _subScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _menuView.maxY, self.width, self.height-_menuView.maxY+ _maxOffset_Y)];
        _subScrollView.contentSize = CGSizeMake(self.width * 3, _subScrollView.height);
        _subScrollView.pagingEnabled = YES;
        _subScrollView.scrollEnabled = YES;
        _subScrollView.showsHorizontalScrollIndicator = NO;
        _subScrollView.backgroundColor = kColor_bgHeaderViewColor;
        _subScrollView.delegate = self;
    }
    return _subScrollView;
}

- (ShopHomePageView *)shopHomePageView
{
    if (!_shopHomePageView) {
        _shopHomePageView = [[ShopHomePageView alloc]initWithFrame:CGRectMake(0, 0, self.width, _subScrollView.height)];
        _shopHomePageView.shopSuperView = self;
        _shopHomePageView.currentVC = _currentVC;
        _shopHomePageView.shopModuleType = self.shopViewType;
        _shopHomePageView.groupId = _groupId;
        _shopHomePageView.shopModel = _shopModel;
    }
    return _shopHomePageView;
}

- (ShopEvaluateView *)shopEvaluateView
{
    if (!_shopEvaluateView) {
        _shopEvaluateView = [[ShopEvaluateView alloc]initWithFrame:CGRectMake(self.width, 0, self.width, _subScrollView.height) withGroupID:_groupId];
    }
    return _shopEvaluateView;
}

- (ShopMerchantView *)merchantView
{
    if (!_merchantView) {
        _merchantView = [[ShopMerchantView alloc]initWithFrame:CGRectMake(self.width*2, 0, self.width, _subScrollView.height)];
        _merchantView.groupId = _groupId;
        _merchantView.shopModel = _shopModel;
    }
    return _merchantView;
}

@end
