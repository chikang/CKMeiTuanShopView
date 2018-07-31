//
//  HeaderReusableView.m
//  AppPark
//
//  Created by 池康 on 2018/2/9.
//

#import "HeaderReusableView.h"

@implementation HeaderReusableView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *line = [UITool lineLabWithFrame:CGRectMake(10, 10, 1, 14)];
        line.backgroundColor = UIColorFromRGB(0xFF5A49);
        [self addSubview:line];
        
        _titleLab = [UITool createLabelWithFrame:CGRectMake(line.maxX+7,0, 200, 34) backgroundColor:[UIColor clearColor] textColor:kColor_GrayColor textSize:12 alignment:NSTextAlignmentLeft lines:1];
        [self addSubview:_titleLab];
      
    }
    return self;
}


@end


