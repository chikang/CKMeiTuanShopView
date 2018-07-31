//
//  ReserveEvluateCell.m
//  AppPark
//
//  Created by 池康 on 2017/12/14.
//

#import "ReserveEvluateCell.h"

@implementation ReserveEvluateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        //头像
        _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 22, 24, 24)];
        _headImgView.image = [[UIImage imageNamed:@"icon_user"] drawCircularIconWithSize:CGSizeMake(22, 22) withRadius:12];
        [self.contentView addSubview:_headImgView];
        //用户名称
        _userNameLab = [UITool createLabelWithFrame:CGRectMake(44, 18, 200, 18) backgroundColor:[UIColor clearColor] textColor:kColor_darkBlackColor textSize:14 alignment:NSTextAlignmentLeft lines:1];
        _userNameLab.text = @"hahahahaha";
        [self.contentView addSubview:_userNameLab];
        //时间
        _timeLab = [UITool createLabelWithFrame:CGRectMake(44, 36, kScreenWidth-80, 14) backgroundColor:[UIColor clearColor] textColor:kColor_GrayColor textSize:12 alignment:NSTextAlignmentLeft lines:1];
        _timeLab.text = @"2017/09/02    厨房清洁 | 上门服务";
        [self.contentView addSubview:_timeLab];
        
        //分数
        UIImageView *icon_scoring = [[UIImageView alloc]initWithImage:kImage_Name(@"icon-scoring")];
        icon_scoring.frame = CGRectMake(kScreenWidth-37, -1, 27, 24);
        [self.contentView addSubview:icon_scoring];
        
        _gradeLab = [UITool createLabelWithFrame:CGRectMake(kScreenWidth-37, -1, 27, 17) backgroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] textSize:12 alignment:NSTextAlignmentCenter lines:1];
        _gradeLab.text = @"5.0";
        [self.contentView addSubview:_gradeLab];
        
        //评论内容
        NSString *str = @"非常好，干净，地理位置好。附近很安静，适合散步。离宝能太古城很近，电视节目也很多。";
        CGSize size = [AppMethods sizeWithFont:[UIFont systemFontOfSize:14] Str:str withMaxWidth:kScreenWidth-54];
        _contentLab = [UITool createLabelWithFrame:CGRectMake(44, _timeLab.maxY+10, kScreenWidth-54, size.height+3) backgroundColor:[UIColor clearColor] textColor:kColor_darkBlackColor textSize:14 alignment:NSTextAlignmentLeft lines:0];
        _contentLab.text = str;
        [self.contentView addSubview:_contentLab];
        
        _photoView = [[UIView alloc]initWithFrame:CGRectMake(44, _contentLab.maxY+6, kScreenWidth-54, 0)];
        _photoView.userInteractionEnabled = YES;
        [self.contentView addSubview:_photoView];
        
        //回复内容
        _replyView = [[UIView alloc]initWithFrame:CGRectMake(44, _photoView.maxY+20, kScreenWidth-54,0)];
        _replyView.clipsToBounds = YES;
        _replyView.backgroundColor = kColor_bgViewColor;
        [self.contentView addSubview:_replyView];
        _replyLab = [UITool createLabelWithFrame:CGRectMake(10, 10, _replyView.width-20,0) backgroundColor:kColor_bgViewColor textColor:UIColorFromRGB(0x878787) textSize:14 alignment:NSTextAlignmentLeft lines:0];
        [_replyView addSubview:_replyLab];
        
        //图标
        _topImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_top"]];
        _topImgView.frame = CGRectMake(44+30, _replyView.minY-8, 15, 8);
        _topImgView.hidden = YES;
        [self.contentView addSubview:_topImgView];
        
    
        _lineLab = [UITool lineLabWithFrame:CGRectMake(10, _replyLab.maxY + 10, kScreenWidth-10, 1)];
        _lineLab.backgroundColor = kColor_bgHeaderViewColor;
        [self.contentView addSubview:_lineLab];
    }
    return self;
    
}

//重新布置
- (void)layoutSubviews
{
    
}


- (void)setModel:(EvaluateModel *)model
{
    
    _model = model;
    _gradeLab.text = [NSString stringWithFormat:@"%@",model.totalScore];
    _topImgView.hidden = YES;
    _photoView.hidden = YES;
    _replyView.hidden = YES;
    _gradeLab.text = [NSString stringWithFormat:@"%.1f",[model.totalScore floatValue]];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:model.memberHeadUrl] placeholderImage:[UIImage imageNamed:@"icon_user"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _headImgView.image = [image drawCircularIconWithSize:CGSizeMake(24, 24) withRadius:12];
    }];
    
    _userNameLab.text = model.memberName;
    _timeLab.text = [NSString stringWithFormat:@"%@    %@",model.commTime,model.regular];
    if (self.cellType == 1) {
       _timeLab.text = [NSString stringWithFormat:@"%@",model.commTime];
    }
    //评论内容
    NSString *commContent = [NSString jsonUtils:model.commContent];
    CGSize commContentSzie = [AppMethods sizeWithFont:[UIFont systemFontOfSize:14] Str:commContent withMaxWidth:kScreenWidth-54];
    _contentLab.text = commContent;
    
    
    //
    //是否有图片
    NSArray *picList = model.picList;
    
    if (commContent.length == 0) {
        [_contentLab setChangeHeight:0];
        _photoView.mj_y = _contentLab.maxY ;
    }else{
        [_contentLab setChangeHeight:commContentSzie.height];
        _photoView.mj_y = _contentLab.maxY+ 6 ;
    }

    //删除所有图片子视图
    for (UIView *subViews in _photoView.subviews) {
        [subViews removeFromSuperview];
    }
    if (picList.count > 0) {
        _photoView.hidden = NO;
        // 图片宽和高
        CGFloat pgotoW = 80;
        //有图片
        if (picList.count <=3) {
            //小于等于三张
            [_photoView setChangeHeight:pgotoW];
            
        }else if (picList.count > 3 && picList.count<=6){
            //小于等于6张大于三张
            [_photoView setChangeHeight:pgotoW + pgotoW + 4];
        }else{
            //大于6张，小于等于9张
            [_photoView setChangeHeight:pgotoW + pgotoW + pgotoW + 4 + 4];
        }
        
        for (int i = 0; i<picList.count; i++) {
            
            UIImageView *photoImgView = [[UIImageView alloc]init];
            photoImgView.frame = CGRectMake((pgotoW+4)*(i%3), (pgotoW+4) *(i/3), pgotoW, pgotoW);
            [photoImgView sd_setImageWithURL:[NSURL URLWithString:picList[i][@"picUrl"]] placeholderImage:[UIImage imageNamed:@"thumb"]];
            photoImgView.tag = i + 1;
            photoImgView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPhotoClick:)];
            [photoImgView addGestureRecognizer:tap];
            [_photoView addSubview:photoImgView];
        }
    }else{
        //没图片
        [_photoView setChangeHeight:0];
    }
    
    //是否商家回复了
    NSString *replyContent = [NSString stringWithFormat:@"商家回复:%@",[NSString jsonUtils:model.replyContent]];
    if (replyContent.length > 5) {
        //有回复
        if (picList.count == 0) {
            _replyView.mj_y = _contentLab.maxY + 20;
        }else{
            _replyView.mj_y = _photoView.maxY + 20;
        }
        _topImgView.hidden = NO;
        _replyView.hidden = NO;
        CGSize replyContentSzie = [AppMethods sizeWithFont:[UIFont systemFontOfSize:14] Str:replyContent withMaxWidth:kScreenWidth-74];
        [_replyLab setChangeHeight:replyContentSzie.height];
        [_replyView setChangeHeight:_replyLab.height + 20];
        _topImgView.mj_y = _replyView.minY-8;
        
        NSMutableAttributedString *replyStr = [AppDefaultUtil returnStringColor:replyContent rang:NSMakeRange(5, replyContent.length-5) color:kColor_ReplyColor];
        _replyLab.attributedText = replyStr;
    }else
    {
        _topImgView.hidden = YES;
        _replyView.hidden = YES;
        [_replyView setChangeHeight:0];
    }
    
    _lineLab.mj_y = model.cellHeight - 1;
}

#pragma mark -控制方法
- (void)btnClick:(UIButton *)btn
{
    
}


- (void)tapPhotoClick:(UITapGestureRecognizer *)tap
{
    
    NSInteger tag = tap.view.tag;
    if ([self.delegate respondsToSelector:@selector(didSelectedPhotoView:withImgIndex:)]) {
        [self.delegate didSelectedPhotoView:self withImgIndex:tag];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
