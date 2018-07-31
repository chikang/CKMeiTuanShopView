//
//  EvaluateModel.m
//  AppPark
//
//  Created by 池康 on 2017/11/29.
//

#import "EvaluateModel.h"

@implementation EvaluateModel




- (void)calculateCellHeightWithDic:(NSDictionary *)dic
{
    CGFloat  height = 60;
    //评论内容
    NSString *commContent = [NSString jsonUtils:dic[@"commContent"]];
    CGSize commContentSzie = [AppMethods sizeWithFont:[UIFont systemFontOfSize:14] Str:commContent withMaxWidth:kScreenWidth-20];
    height = height + commContentSzie.height;
    
    //是否有图片
    NSArray *picList = dic[@"picList"];
    if (picList.count > 0) {
        // 图片宽和高
        CGFloat pgotoW = 80;
        //有图片
        height = height + 6;// +6是文本和图片的间隔
        if (picList.count <=3) {
            //小于等于三张
            height = height + pgotoW;
        }else if (picList.count > 3 && picList.count<=6){
            //小于等于6张大于三张
            height = height + pgotoW + pgotoW + 4;//+4是图片与图片之间的间隔
        }else{
            //大于6张，小于等于9张
             height = height + pgotoW + pgotoW +pgotoW + 4 + 4;// +4是图片与图片之间的间隔
        }
        
    }else{
        //没图片
        height = height;
    }
    
    //是否商家回复了
     NSString *replyContent = [NSString stringWithFormat:@"酒店回复:%@",[NSString jsonUtils:dic[@"replyContent"]]];
    if (replyContent.length > 5) {
        //有回复
        height = height + 20; //+20是上下之间的间隔。
        CGSize replyContentSzie = [AppMethods sizeWithFont:[UIFont systemFontOfSize:14] Str:replyContent withMaxWidth:kScreenWidth-40];
        height = height + replyContentSzie.height + 20 + 20;
    }else{
        //无回复
        height = height + 20;
    }
    
    //缓存高度
    self.cellHeight = height;
    
}



- (void)calculateCellHeight
{
    CGFloat  height = 60;
    //评论内容
    NSString *commContent = self.content;
    CGSize commContentSzie = [AppMethods sizeWithFont:[UIFont systemFontOfSize:14] Str:commContent withMaxWidth:kScreenWidth-54];
    
    height = height + commContentSzie.height;
    
    //是否有图片
    NSArray *picList = self.picList;
    if (picList.count > 0) {
        // 图片宽和高
        CGFloat pgotoW = 80;
        //有图片
        height = height + 6;// +6是文本和图片的间隔
        if (picList.count <=3) {
            //小于等于三张
            height = height + pgotoW;
        }else if (picList.count > 3 && picList.count<=6){
            //小于等于6张大于三张
            height = height + pgotoW + pgotoW + 4;//+4是图片与图片之间的间隔
        }else{
            //大于6张，小于等于9张
            height = height + pgotoW + pgotoW +pgotoW + 4 + 4;// +4是图片与图片之间的间隔
        }
        
    }else{
        //没图片
        height = height;
    }
    
    //是否商家回复了
    NSString *replyContent = [NSString stringWithFormat:@"酒店回复:%@",[NSString jsonUtils:self.replyContent]];
    if (replyContent.length > 5) {
        //有回复
        height = height + 20; //+20是上下之间的间隔。
        CGSize replyContentSzie = [AppMethods sizeWithFont:[UIFont systemFontOfSize:14] Str:replyContent withMaxWidth:kScreenWidth-74];
        height = height + replyContentSzie.height + 20 + 20;
    }else{
        //无回复
        height = height + 20;
    }
    
    //缓存高度
    self.cellHeight = height;
    
}


- (void)calculateReserveCellHeight
{
    CGFloat  height = 60;
    //评论内容
    NSString *commContent = self.commContent;
    CGSize commContentSzie = [AppMethods sizeWithFont:[UIFont systemFontOfSize:14] Str:commContent withMaxWidth:kScreenWidth-54];
    
    height = height + commContentSzie.height;
    
    //是否有图片
    NSArray *picList = self.picList;
    if (picList.count > 0) {
        // 图片宽和高
        CGFloat pgotoW = 80;
        //有图片
        height = height + 6;// +6是文本和图片的间隔
        if (picList.count <=3) {
            //小于等于三张
            height = height + pgotoW;
        }else if (picList.count > 3 && picList.count<=6){
            //小于等于6张大于三张
            height = height + pgotoW + pgotoW + 4;//+4是图片与图片之间的间隔
        }else{
            //大于6张，小于等于9张
            height = height + pgotoW + pgotoW +pgotoW + 4 + 4;// +4是图片与图片之间的间隔
        }
        
    }else{
        //没图片
        height = height;
    }
    
    //是否商家回复了
    NSString *replyContent = [NSString stringWithFormat:@"酒店回复:%@",[NSString jsonUtils:self.replyContent]];
    if (replyContent.length > 5) {
        //有回复
        height = height + 20; //+20是上下之间的间隔。
        CGSize replyContentSzie = [AppMethods sizeWithFont:[UIFont systemFontOfSize:14] Str:replyContent withMaxWidth:kScreenWidth-74];
        height = height + replyContentSzie.height + 20 + 20;
    }else{
        //无回复
        height = height + 20;
    }
    
    //缓存高度
    self.cellHeight = height;
    
}


#pragma mark - 计算外卖店铺主页评价cell的高度
- (void)calculateTakeawayEvaluateCellHeight
{
    CGFloat  height = 42;
    //评论内容
    NSString *commContent = self.commContent;
    CGSize commContentSzie = [AppMethods sizeWithFont:[UIFont systemFontOfSize:12] Str:commContent withMaxWidth:kScreenWidth-60];
    if (commContent.length == 0) {
        //评论为空
    }else{
        height = height + commContentSzie.height + 10;//+10是文本跟时间的间隔
    }
    //是否有图片
    NSArray *picList = self.picList;
    if (picList.count > 0) {
        // 图片宽和高
        CGFloat pgotoW = 80;
        //有图片
        height = height + 10;// +10是图片和上面控件的间隔
        if (picList.count <=3) {
            //小于等于三张
            height = height + pgotoW;
        }else if (picList.count > 3 && picList.count<=6){
            //小于等于6张大于三张
            height = height + pgotoW + pgotoW + 4;//+4是图片与图片之间的间隔
        }else{
            //大于6张，小于等于9张
            height = height + pgotoW + pgotoW +pgotoW + 4 + 4;// +4是图片与图片之间的间隔
        }
    }else{
        //没图片
        height = height;
    }
    
    //踩菜品，赞菜品视图
    height = height + 15 + 40;
    
    //是否商家回复了
    NSString *replyContent = [NSString stringWithFormat:@"酒店回复:%@",[NSString jsonUtils:self.replyContent]];
    if (replyContent.length > 5) {
        //有回复
        height = height + 10; //+20是上下之间的间隔。
        CGSize replyContentSzie = [AppMethods sizeWithFont:[UIFont systemFontOfSize:12] Str:replyContent withMaxWidth:kScreenWidth-80];
        height = height + replyContentSzie.height + 14 + 20;
    }else{
        //无回复
        height = height + 20;
    }
    //缓存高度
    self.cellHeight = height;
}


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
