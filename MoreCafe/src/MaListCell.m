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
	CGRect frame = CGRectMake(MA_LIST_CELL_GAP, MA_LIST_CELL_GAP, MA_LIST_CELL_WIDTH, MA_LIST_CELL_HEIGHT);
	UIView* view = [[UIView alloc] initWithFrame:frame];
//	[view setUserInteractionEnabled:YES];
//	[self addGestureRecognizerTo:view];

	view.backgroundColor = [UIColor colorWithRed:(arc4random()%100)/(float)100 green:(arc4random()%100)/(float)100 blue:(arc4random()%100)/(float)100 alpha:0.3];
	
	[self addSubview:view];
	CGRect innerFrame = CGRectMake(MA_LIST_CELL_INNER_GAP,MA_LIST_CELL_INNER_GAP, MA_LIST_CELL_INNER_WIDTH, MA_LIST_CELL_INNER_HEIGHT);

	_imgView = [[AsyncImageView alloc] initWithFrame:innerFrame];
	_imgView.backgroundColor = [UIColor colorWithRed:(arc4random()%100)/(float)100 green:(arc4random()%100)/(float)100 blue:(arc4random()%100)/(float)100 alpha:0.3];
	[view addSubview:_imgView];

	
	_nameLable = [[UILabel alloc] initWithFrame:CGRectMake(innerFrame.origin.x, innerFrame.origin.y+innerFrame.size.height - 40, MA_LIST_CELL_INNER_WIDTH, 40)];
	_nameLable.backgroundColor = [UIColor colorWithRed:(arc4random()%100)/(float)100 green:(arc4random()%100)/(float)100 blue:(arc4random()%100)/(float)100 alpha:0.3];
	
	_nameLable.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
	_nameLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_nameLable.font = [UIFont boldSystemFontOfSize:20];
	_nameLable.textAlignment = NSTextAlignmentRight;
	_nameLable.textColor = [UIColor whiteColor];
	_nameLable.opaque = NO;

	[view addSubview:_nameLable];
	
	_discriptionLable = [[UILabel alloc] initWithFrame:CGRectMake(innerFrame.origin.x, innerFrame.origin.y+innerFrame.size.height + 2, MA_LIST_CELL_INNER_WIDTH, 46)]; 
	_discriptionLable.backgroundColor = [UIColor colorWithRed:(arc4random()%100)/(float)100 green:(arc4random()%100)/(float)100 blue:(arc4random()%100)/(float)100 alpha:0.3];
	
	_discriptionLable.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
	_discriptionLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_discriptionLable.font = [UIFont systemFontOfSize:12];
	_discriptionLable.textAlignment = NSTextAlignmentLeft;
	_discriptionLable.textColor = [UIColor whiteColor];
	_discriptionLable.opaque = NO;
	_discriptionLable.lineBreakMode = NSLineBreakByWordWrapping;
	_discriptionLable.numberOfLines = 0;
	[view addSubview:_discriptionLable];
}

-(void)fillCellDataWith:(NSDictionary*)dict
{
	NSString* imgName = [dict objectForKey:@"imagePrefix"];
	if ([imgName length]>0) {
		NSMutableString* imgPath = [NSMutableString stringWithString:imgName];
		[imgPath appendString:@".jpg"];
		[_imgView setImageByString:imgPath];
	}
	else
	{
		[_imgView setImageByString:@"emptyImg.jpg"];
	}
	
	_nameLable.text = [dict objectForKey:@"name"];
	_discriptionLable.text = [dict objectForKey:@"discription"];


}

-(void)addGestureRecognizerTo:(UIView*)view
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	singleTap.numberOfTapsRequired = 1;
	[view setUserInteractionEnabled:YES];
    [view addGestureRecognizer:singleTap];
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
	
}
@end
