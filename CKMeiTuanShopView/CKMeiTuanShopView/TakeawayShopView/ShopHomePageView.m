//
//  ShopHomePageView.m
//  AppPark
//
//  Created by 池康 on 2018/7/10.
//

#import "ShopHomePageView.h"
#import "TakeawayProductListCell.h"//店铺主页列表样式
#import "TakeawayProductCardCell.h"//店铺主页卡片样式
#import "TakeawayProductCollectionCell.h"//店铺主页宫格样式
#import "NewShopListModel.h"
#import "HeaderReusableView.h"
#import "JHHeaderFlowLayout.h"
#define collectionCellH    ((takeawayRight_W - 30)/2 + 97)
@interface ShopHomePageView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger _leftIndex;//左边被选中的索引值
    BOOL _isStop;//停止右边的代理方法
    JHHeaderFlowLayout *_layout;
    
    NSMutableArray *_dataArray;
    NSInteger _maxOffset_Y;
    
    BOOL  _gestureEnd;//手势是否已经结束
    BOOL _isMoreThan;
    
    UIScrollView *_currentSubView;
    
    BOOL _isSelectSlide;//是点击leftTableView，还是拖拽右边的滑动视图
}
@property (nonatomic , strong) NSMutableArray *titlesAry;
/// 添加的商品数据
@property (nonatomic,strong) NSMutableArray *addOrderList;
/// 商品数据
@property (nonatomic,strong) NSArray *productList;

@end

@implementation ShopHomePageView

/// 存放用户添加到购物车的商品数组
-(NSMutableArray *)addOrderList
{
    if (!_addOrderList) {
        _addOrderList = [NSMutableArray new];
    }
    return _addOrderList;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _leftIndex = 0;
        _dataArray = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gestureStateBegan:) name:@"GestureRecognizerStateBegan" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gestureStateEnd:) name:@"GestureRecognizerStateEnded" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bottomShoppingCartMethod:) name:@"bottomShopCartOffsetY" object:nil];
    }
    return self;
}

#pragma mark ---通知方法
- (void)gestureStateBegan:(NSNotification *)not{
    
    BOOL isMore = _currentSubView.contentOffset.y >= (_currentSubView.contentSize.height - _currentSubView.height);
    if (isMore) {
        _gestureEnd = NO;
    }
    //手动拖拽
    _isSelectSlide = NO;
}

- (void)gestureStateEnd:(NSNotification *)not{
    //    手势已经结束
    BOOL isMore = _currentSubView.contentOffset.y > (_currentSubView.contentSize.height - _currentSubView.height);
    if (isMore) {
        //如果滑动的偏移量超出最大的内容范围
        CGFloat between = _currentSubView.contentOffset.y - (_currentSubView.contentSize.height - _currentSubView.height);
        if (between >= 70) {
            _gestureEnd = YES;
        }
    }
}

//底部购物车，暂时隐藏
- (void)bottomShoppingCartMethod:(NSNotification *)not
{
    NSDictionary *dic = not.userInfo;
    CGFloat offsetY = [dic[@"offsetY"] floatValue];
}
////底部购物车视图
//- (void)createBottonView
//{
//    _shopCarView = [[ShoppingCartBottonView alloc]initWithFrame:CGRectMake(0, self.height-49-30 - _maxOffset_Y, kScreenWidth, 49+30) inView:nil];
//    _shopCarView.delegate = self;
//    [self addSubview:_shopCarView];
//}

#pragma mark - get/set方法
- (void)setShopModel:(NewShopModel *)shopModel{
    _shopModel = shopModel;
    _titlesAry = _shopModel.sortInfo;
    NSArray *activityList = _shopModel.activityList;
    if (activityList.count > 0) {
        _maxOffset_Y = (Size(150) + 48 - kDefaultNavBarHeight);
    }else{
        _maxOffset_Y = (Size(150) + 48 - kDefaultNavBarHeight - 28);
    }
    [self createView];
    
    _currentSubView = [self currentScorllView];
}

#pragma mark - 创建视图
- (void)createView
{
    self.leftTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,takeawayLeft_W, self.height-_maxOffset_Y) style:UITableViewStyleGrouped];
    self.leftTabView.dataSource = self;
    self.leftTabView.delegate = self;
    self.leftTabView.backgroundColor = UIColorFromRGB(0xF4F4F4);
    self.leftTabView.tableFooterView = [UIView new];
    self.leftTabView.separatorColor = kColor_bgHeaderViewColor;
    self.leftTabView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.leftTabView];
    
    UILabel *line = [UITool lineLabWithFrame:CGRectMake(takeawayLeft_W-0.5, 0, 0.5, self.height)];
    line.backgroundColor = kColor_bgHeaderViewColor;
    [self.leftTabView addSubview:line];
    
    if (self.shopModuleType == ShopModuleTypeGongGe) {
        [self createCollectionView];
    }else{
        [self createRightTableView];
    }
}

- (void)createRightTableView
{
    self.rightTabView = [[UITableView alloc]initWithFrame:CGRectMake(takeawayLeft_W, 0,takeawayRight_W, self.height) style:UITableViewStylePlain];
    self.rightTabView.dataSource = self;
    self.rightTabView.delegate = self;
    self.rightTabView.backgroundColor = [UIColor whiteColor];
    self.rightTabView.tableFooterView = [UIView new];
    self.rightTabView.separatorColor = kColor_bgHeaderViewColor;
    if (self.shopModuleType == ShopModuleTypeCard) {
        self.rightTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    self.rightTabView.showsVerticalScrollIndicator = NO;
    self.rightTabView.scrollEnabled = NO;
    [self addSubview:self.rightTabView];
}

- (void)createCollectionView
{
    //创建流水布局
    _layout = [[JHHeaderFlowLayout alloc] init];
    _layout.headerReferenceSize = CGSizeMake(takeawayRight_W, 34);
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置列表视图
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(takeawayLeft_W, 0,takeawayRight_W, self.height) collectionViewLayout:_layout];
    // 注册cell、sectionHeader、sectionFooter
    [_collectionView registerClass:[TakeawayProductCollectionCell class] forCellWithReuseIdentifier:@"collectCell"];
    [_collectionView registerClass:[HeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hederView"];
    //设置代理
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
}

- (void)superScrollViewDidScrollOffset:(CGFloat)offset
{
    if (offset <= _maxOffset_Y) {
        _leftTabView.mj_h = self.height-_maxOffset_Y + offset;
    }
}

#pragma mark -  UICollectionViewDataSource/UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _titlesAry.count;
}

//这组多少item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 11;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        HeaderReusableView *headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"hederView" forIndexPath:indexPath];
        NSDictionary *dic = _titlesAry[indexPath.section];
        headerView.titleLab.text = dic[@"name"];
        headerView.tag = 50;
        return headerView;
    }
    return nil;
}

//每行cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TakeawayProductCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectCell" forIndexPath:indexPath];
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionCellH-97, collectionCellH);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
   return  UIEdgeInsetsMake(0,10,0,10);
}
//选中cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - ThrowLineToolDelegate methods
/// 抛物线结束动画回调
- (void)animationDidFinish
{
    
}

#pragma mark - FSBaseTableViewDataSource & FSBaseTableViewDelegate  委托方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.leftTabView) {
        return 1;
    }
    return _titlesAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTabView) {
        return _titlesAry.count;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTabView) {
        return 44;
    }else{
//        NewShopListModel *model = _dataArray[indexPath.row];
        if (self.shopModuleType == ShopModuleTypeCard){
            return 110 + 4*(takeawayRight_W-20)/7;
        }else{
            return 100;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_rightTabView == tableView) {
        return 30;
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //最后一个
   return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    if (tableView == _leftTabView) {
        bgView.backgroundColor = UIColorFromRGB(0xF4F4F4);
    }
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _rightTabView) {
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UILabel *line = [UITool lineLabWithFrame:CGRectMake(10, 10, 1, 14)];
        line.backgroundColor = UIColorFromRGB(0xFF5A49);
        [bgView addSubview:line];
        
        UILabel *titleLab = [UITool createLabelWithFrame:CGRectMake(line.maxX+7,0, 200, 34) backgroundColor:[UIColor clearColor] textColor:kColor_GrayColor textSize:12 alignment:NSTextAlignmentLeft lines:1];
        NSDictionary *dic = _titlesAry[section];
        titleLab.text = dic[@"name"];
        [bgView addSubview:titleLab];
        
        return bgView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTabView) {
        static NSString *reuseID = @"leftCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            UILabel *titleLab = [UITool createLabelWithFrame:CGRectMake(0,0, takeawayLeft_W, 50) backgroundColor:[UIColor clearColor] textColor:kColor_darkBlackColor textSize:13 alignment:NSTextAlignmentCenter lines:1];
            titleLab.tag = 10;
            [cell.contentView addSubview:titleLab];
            
            UIView *selectView = [[UIView alloc]initWithFrame:cell.frame];
            selectView.backgroundColor = [UIColor whiteColor];
            cell.selectedBackgroundView = selectView;
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 );
        }
        UILabel *titleLab = [cell.contentView viewWithTag:10];
        NSDictionary *dic = _titlesAry[indexPath.row];
        titleLab.text = dic[@"name"];
        if (indexPath.row == _leftIndex) {
            [_leftTabView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        cell.backgroundColor = UIColorFromRGB(0xF4F4F4);
        return cell;
        
    }else
    {
        if (self.shopModuleType == ShopModuleTypeCard){
            static NSString *cardCell = @"cardCell1";
            TakeawayProductCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cardCell];
            if (!cell) {
                cell = [[TakeawayProductCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cardCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 );
            }
//            NewShopListModel *model = _dataArray[indexPath.row];
//            cell.listModel = model;
            return cell;
        }else{
            static NSString *listCell = @"listCell1";
            TakeawayProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell];
            if (!cell) {
                cell = [[TakeawayProductListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 );
            }
//            NewShopListModel *model = _dataArray[indexPath.row];
//            cell.listModel = model;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_leftTabView == tableView) {
        //选中_leftTabView而不是拖拽右边的滑动视图
        _isSelectSlide = YES;
      if (self.shopModuleType == ShopModuleTypeGongGe) {
        //宫格样式
//         [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
          //collectionCellH  计算偏移量
          CGFloat offsetY = 0;
          NSLog(@"--------%f",collectionCellH);
          for (int i = 0; i<indexPath.row; i++) {
              NSInteger count = 10;//动态返回数量
              offsetY = (count/2+count%2)*collectionCellH + 74 + offsetY;
          }
          [_collectionView setContentOffset:CGPointMake(0, offsetY) animated:YES];
       }else{
         [_rightTabView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
      }
         [_leftTabView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        
        _leftIndex = indexPath.row;
    }else{
        UIViewController *superVC =   [self viewController];
        DMLog(@"--跳转到详情。。。");
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //当拖拽_leftTabView时候，应该停止右视图的手势,停止滚动
    [_shopSuperView removeBehaviors];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != _leftTabView) {
        NSArray *array;
        if (scrollView == _collectionView) {
            array = _collectionView.indexPathsForVisibleItems;
        }else{
            array = _rightTabView.indexPathsForVisibleRows;
        }
        if (array.count > 0) {
            NSIndexPath *indexPath = array[0];
            //2:可见的第一个section位置
            NSInteger section = indexPath.section;
            //3:
            if (!_isSelectSlide) {
                //只有拖拽的时候，才执行该方法
                [_leftTabView selectRowAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            }
        }
    }
}

- (UIScrollView *)currentScorllView
{
    UIScrollView *scrollView;
    switch (self.shopModuleType) {
        case 1:
        {
            scrollView = _rightTabView;
        }
            break;
        case 2:
        {
            scrollView = _collectionView;
        }
            break;
        case 3:
        {
            scrollView = _rightTabView;
        }
            break;
            
        default:
            break;
    }
    return scrollView;
}

@end
