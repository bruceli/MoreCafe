//
//  MaListCell.m
//  MoreCafe
//
//  Created by Thunder on 1/16/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import "MaListCell.h"
#import "MaUtility.h"

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
	CGRect frame = CGRectMake(MA_LIST_CELL_GAP, MA_LIST_CELL_GAP, MA_LIST_CELL_WIDTH, MA_LIST_CELL_HEIGHT);
//	UIView* view = [[UIView alloc] initWithFrame:frame];
	UIImageView* backgroundView =  [[UIImageView alloc] initWithFrame:frame];
	UIImage* backgroundImage = [UIImage imageNamed:@"listCellbackground"];
	backgroundView.image = backgroundImage;
	
//	[view setUserInteractionEnabled:YES];
//	[self addGestureRecognizerTo:view];

//	view.backgroundColor = [UIColor colorWithRed:(arc4random()%100)/(float)100 green:(arc4random()%100)/(float)100 blue:(arc4random()%100)/(float)100 alpha:0.3];
	
	CGRect innerFrame = CGRectMake(MA_LIST_CELL_INNER_GAP,MA_LIST_CELL_INNER_GAP, MA_LIST_CELL_INNER_WIDTH, MA_LIST_CELL_INNER_HEIGHT);

	_imgView = [[AsyncImageView alloc] initWithFrame:innerFrame];
	_imgView.crossfadeDuration = 0.2;
	// _imgView.backgroundColor = [UIColor colorWithRed:(arc4random()%100)/(float)100 green:(arc4random()%100)/(float)100 blue:(arc4random()%100)/(float)100 alpha:0.3];

	
	_nameLable = [[UILabel alloc] initWithFrame:CGRectMake(innerFrame.origin.x, innerFrame.origin.y+innerFrame.size.height - 40, MA_LIST_CELL_INNER_WIDTH, 40)];	
	_nameLable.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
	_nameLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_nameLable.font = [UIFont boldSystemFontOfSize:20];
	_nameLable.textAlignment = NSTextAlignmentRight;
	_nameLable.textColor = [UIColor whiteColor];
	_nameLable.opaque = NO;

	
	_discriptionLable = [[UILabel alloc] initWithFrame:CGRectMake(innerFrame.origin.x, innerFrame.origin.y+innerFrame.size.height + 2, MA_LIST_CELL_INNER_WIDTH, 46)]; 
//	_discriptionLable.backgroundColor = [UIColor colorWithRed:(arc4random()%100)/(float)100 green:(arc4random()%100)/(float)100 blue:(arc4random()%100)/(float)100 alpha:0.3];
	
	_discriptionLable.backgroundColor = [UIColor clearColor];
	_discriptionLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_discriptionLable.font = [UIFont systemFontOfSize:12];
	_discriptionLable.textAlignment = NSTextAlignmentLeft;
	_discriptionLable.textColor = [UIColor darkGrayColor];
	_discriptionLable.opaque = NO;
	_discriptionLable.lineBreakMode = NSLineBreakByWordWrapping;
	_discriptionLable.numberOfLines = 0;
	
	CGRect newImageViewFrame = CGRectMake(_imgView.frame.origin.x+ backgroundView.frame.origin.x, _imgView.frame.origin.y+ backgroundView.frame.origin.y, _imgView.frame.size.width, _imgView.frame.size.height);
	_imgView.frame = newImageViewFrame;
	
	CGRect newNameLableFrame = CGRectMake(_nameLable.frame.origin.x+ backgroundView.frame.origin.x, _nameLable.frame.origin.y+ backgroundView.frame.origin.y, _nameLable.frame.size.width, _nameLable.frame.size.height);
	_nameLable.frame = newNameLableFrame;

	[self addSubview:_imgView];
	[self addSubview:_nameLable];

	[self addSubview:backgroundView];
	[backgroundView addSubview:_discriptionLable];
}

-(void)fillCellDataWith:(NSDictionary*)dict
{
	NSString* imgPrefix = [dict objectForKey:@"imagePrefix"];

	if ([imgPrefix length]>0 && [MaUtility isFileExist:imgPrefix]) {
		[_imgView setImageByString:imgPrefix];
	}
	else
	{
		[_imgView setImageByString:@"emptyImg.jpg"];
	}
	
	_nameLable.text = [dict objectForKey:@"name"];
	_discriptionLable.text = [dict objectForKey:@"discription"];


}

@end
