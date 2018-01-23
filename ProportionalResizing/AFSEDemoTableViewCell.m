//
//  AFSEDemoTableViewCell.m
//  ProportionalResizing
//
//  Created by Nikolaos Tsiolas on 17/01/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "AFSEDemoTableViewCell.h"
#import "UIView+ProportionalResizing.h"

@implementation AFSEDemoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	
	[self adaptForAllDevices];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
