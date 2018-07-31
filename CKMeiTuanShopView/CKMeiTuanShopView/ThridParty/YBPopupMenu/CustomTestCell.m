//
//  CustomTestCell.m
//  YBPopupMenuDemo
//
//  Created by lyb on 2017/12/20.
//  Copyright © 2017年 LYB. All rights reserved.
//

#import "CustomTestCell.h"

@implementation CustomTestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.redLab.layer.cornerRadius = 2;
    self.redLab.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
