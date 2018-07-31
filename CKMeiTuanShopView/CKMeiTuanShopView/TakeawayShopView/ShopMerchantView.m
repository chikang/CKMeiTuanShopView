//
//  ShopMerchantView.m
//  AppPark
//
//  Created by 池康 on 2018/2/9.
//

#import "ShopMerchantView.h"
#import "SDPhotoBrowser.h"
@interface ShopMerchantView()<UITableViewDelegate,UITableViewDataSource,SDPhotoBrowserDelegate>
{
    UIScrollView *_scrollView ;
}
@end

@implementation ShopMerchantView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

- (void)createView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.width, self.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = kColor_LightGrayColor;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorColor = kColor_bgHeaderViewColor;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.tableView];
}

- (void)setShopModel:(NewShopModel *)shopModel
{
    _shopModel = shopModel;
     [self createView];
}

#pragma mark - FSBaseTableViewDataSource & FSBaseTableViewDelegate  委托方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else{
        if (_shopModel.openHour.length == 0 || !_shopModel.openHour) {
            //如果没有营业时间
            return 3;
        }
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_shopModel.shopIntroduce.length == 0) {
            return 0;
        }
        CGSize size = [AppMethods sizeWithFont:kFont(12) Str:_shopModel.shopIntroduce withMaxWidth:self.width];
        return size.height + 30;
    }else if (indexPath.section == 1){
        if (_shopModel.shopPicList.count == 0) {
            return 0;
        }
        return 100;
    }else{
        if (indexPath.row == 1) {
            NSString *text = _shopModel.shopNotice;
            CGSize size = [AppMethods sizeWithFont:kFont(12) Str:text withMaxWidth:self.width - 43];
            CGFloat height = size.height + 26;
            if (height > 44) {
                return size.height + 26;
            }
            return 44;
        }
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if (_shopModel.shopIntroduce.length == 0) {
            return 0.001;
        }
    }else if (section == 1){
        if (_shopModel.shopPicList.count == 0) {
            return 0.001;
        }
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = kColor_LightGrayColor;
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if (indexPath.section == 0) {
            //店铺介绍
            UILabel *introduceLab = [UITool createLabelWithTextColor:kColor_GrayColor textSize:12 alignment:NSTextAlignmentLeft];
            introduceLab.numberOfLines = 0;
            CGSize size = [AppMethods sizeWithFont:kFont(12) Str:_shopModel.shopIntroduce withMaxWidth:self.width];
            introduceLab.text =  _shopModel.shopIntroduce;
            introduceLab.frame = CGRectMake(10, 10, self.width-20, size.height+10);
            [cell.contentView addSubview:introduceLab];
        }else if (indexPath.section == 1){
            //相册集
            _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, 100)];
            _scrollView.showsHorizontalScrollIndicator = NO;
            [cell.contentView addSubview:_scrollView];
            CGFloat maxW = 0;
            NSArray *shopPicList = _shopModel.shopPicList;
            for (int i = 0; i<shopPicList.count; i++) {
                NSDictionary *dic = shopPicList[i];
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10+(80+20)*i, 10, 80, 80)];
                [_scrollView addSubview:imgView];
                [imgView sd_setImageWithURL:[NSURL URLWithString:dic[@"picUrl"]] placeholderImage:kImage_Name(@"thumb")];
                imgView.tag = 10010 + i;
                maxW = imgView.maxX ;
                imgView.userInteractionEnabled = YES;
                imgView.clipsToBounds = YES;
                imgView.contentMode = UIViewContentModeScaleAspectFill;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkPhotoClick:)];
                [imgView addGestureRecognizer:tap];
            }
            [_scrollView setContentSize:CGSizeMake(maxW+10, 80)];
            if (maxW+10 < self.width) {
                [_scrollView setContentSize:CGSizeMake(self.width, 80)];
            }
        }
        else if (indexPath.section == 2){
            //icon图标
            UIImageView *icon_loc = [[UIImageView alloc]init];
            icon_loc.backgroundColor = [UIColor redColor];
            icon_loc.frame = CGRectMake(10, 13, 18, 18);
            [cell.contentView addSubview:icon_loc];
            
            //
            UILabel *textLab = [UITool createLabelWithTextColor:kColor_TitleColor textSize:14 alignment:NSTextAlignmentLeft];
            textLab.frame = CGRectMake(33, 13, self.width- 120, 18);
            [cell.contentView addSubview:textLab];
            
            if (indexPath.row == 0) {
                icon_loc.image = kImage_Name(@"icon-address");
                textLab.text = _shopModel.shopAddress;
                
                UILabel *line = [[UILabel alloc]init];
                line.backgroundColor = kColor_LightGrayColor;
                line.frame = CGRectMake(self.width-75, 12, 1, 20);
                [cell.contentView addSubview:line];
                //电话
                UIImageView *icon_phone = [[UIImageView alloc]init];
                icon_phone.image = kImage_Name(@"icon-telephone");
                icon_phone.frame = CGRectMake(line.maxX+28, 13, 18, 18);
                icon_phone.contentMode =  UIViewContentModeScaleAspectFit;
                icon_phone.backgroundColor = [UIColor redColor];
                icon_phone.userInteractionEnabled = YES;
                [cell.contentView addSubview:icon_phone];
                
                UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(self.width-75, 0, 75, 44)];
                [cell.contentView addSubview:phoneView];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callPhoneClick:)];
                [phoneView addGestureRecognizer:tap];
                
            }else if (indexPath.row == 1)
            {
                icon_loc.image = kImage_Name(@"icon-announcement");
                NSString *text = _shopModel.shopNotice;
                if (text.length == 0||!text) {
                    text = @"暂无公告";
                }
                textLab.text = text;
                textLab.font = kFont(12);
                textLab.numberOfLines = 0;
                textLab.mj_w = self.width - 43;
                CGSize size = [AppMethods sizeWithFont:kFont(12) Str:text withMaxWidth:textLab.mj_w];
                textLab.mj_h = size.height;
                if (size.height < 18) {
                    textLab.mj_h = 18;
                }
            } else if (indexPath.row == 2){
                if (_shopModel.openHour.length == 0 || !_shopModel.openHour) {
                    //如果没有营业时间
                    //2区间
                    icon_loc.image = kImage_Name(@"icon-idcard");
                    textLab.text = @"营业资质";
                    cell.accessoryView =  [[UIImageView alloc]initWithImage:kImage_Name(@"icon_next")];
                }else{
                    icon_loc.image = kImage_Name(@"icon-footprint");
                    textLab.text = [NSString stringWithFormat:@"营业时间:   %@",_shopModel.openHour];
                }
               
            }else{
                //2区间
                icon_loc.image = kImage_Name(@"icon-idcard");
                textLab.text = @"营业资质";
                cell.accessoryView =  [[UIImageView alloc]initWithImage:kImage_Name(@"icon_next")];
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
         UIViewController *superVC =   [self viewController];
        if (indexPath.row == 0) {
            //位置,经纬度 百度地图
           
        }else if (indexPath.row ==3){
            //营业资质
           
        }else if (indexPath.row == 2){
           
        }
    }
}

- (void)checkPhotoClick:(UITapGestureRecognizer *)tap
{
    UIImageView *imgView = (UIImageView *)tap.view;
    //展示图片浏览器 （Cell 模式）
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    NSArray * shopPicList = _shopModel.shopPicList;
    browser.sourceImagesContainerView = _scrollView;
    browser.imageCount = shopPicList.count;
    browser.currentImageIndex = imgView.tag - 10010;
    browser.delegate = self;
    [browser show];
}

#pragma mark - SDPhotoBrowserDelegate 图片浏览器
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index { //图片的高清图片地址
    NSArray * shopPicList = _shopModel.shopPicList;
    NSDictionary *dic = shopPicList[index];
    NSString *picURL = dic[@"picUrl"];
    NSURL *url = [NSURL URLWithString:picURL];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index { //返回占位图片
    NSArray * shopPicList = _shopModel.shopPicList;
    NSDictionary *dic = shopPicList[index];
    NSString *picURL = dic[@"picUrl"];
    return [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:picURL];
}

- (void)callPhoneClick:(UITapGestureRecognizer *)tap
{
    NSString *telNum = [[NSString alloc] initWithFormat:@"tel://%@", _shopModel.telnumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNum]];
}

@end
