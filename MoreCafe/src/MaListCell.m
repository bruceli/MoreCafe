//
//  MaListCell.m
//  MoreCafe
//
//  Created by Thunder on 1/16/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import "MaListCell.h"
#import "MaScaleImageView.h"

@implementation MaListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		[self setSelectionStyle:UITableViewCellSelectionStyleNone];
		[self initCell];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


-(void)initCell
{
	CGRect frame = CGRectMake(5, 5, 310, 280);
	


}
@end
