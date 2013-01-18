//
//  MaListCell.h
//  MoreCafe
//
//  Created by Thunder on 1/16/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaListCell : UITableViewCell
{
	AsyncImageView* _imgView;
	UILabel* _nameLable;
	UILabel* _discriptionLable;
	
	
}
-(void)fillCellDataWith:(NSDictionary*)dict;

@end
