//
//  MaListCell.m
//  MoreCafe
//
//  Created by Thunder on 1/16/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import "MaListCell.h"

@implementation MaListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.backgroundColor = [UIColor colorWithRed:(arc4random()%100)/(float)100 green:(arc4random()%100)/(float)100 blue:(arc4random()%100)/(float)100 alpha:0.3];
		[self setSelectionStyle:UITableViewCellSelectionStyleNone];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
