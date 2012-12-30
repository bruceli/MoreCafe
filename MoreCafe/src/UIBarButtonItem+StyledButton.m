//
//  UIBarButtonItem+StyledButton.m
//  MoreArt
//
//  Created by Thunder on 12/22/12.
//  Copyright (c) 2012 MagicApp. All rights reserved.
//

#import "UIBarButtonItem+StyledButton.h"
#define MA_BUTTON_FONT_SIZE 13


@implementation UIBarButtonItem (StyledButton)

+ (UIBarButtonItem *)styledBackBarImgButtonItemWithTarget:(id)target selector:(SEL)selector;
{
	UIImage *image = [UIImage imageNamed:@"backButtom"];
	image = [image stretchableImageWithLeftCapWidth:20.0f topCapHeight:20.0f];
	
//	NSString *title = NSLocalizedString(@"Back", nil);
	
//	CGSize imgSize = image.size;
	
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, image.size.width, image.size.height)];
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	[button setBackgroundImage:image forState:UIControlStateNormal];

	return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)styledBackBarButtonItemWithTarget:(id)target selector:(SEL)selector;
{
	UIImage *image = [UIImage imageNamed:@"button_back"];
	image = [image stretchableImageWithLeftCapWidth:20.0f topCapHeight:20.0f];
	
	NSString *title = NSLocalizedString(@"Back", nil);
	UIFont *font = [UIFont boldSystemFontOfSize:MA_BUTTON_FONT_SIZE];
	
	UIButton *button = [UIButton styledButtonWithBackgroundImage:image font:font title:title target:target selector:selector];
	button.titleLabel.textColor = [UIColor blackColor];
	
	CGSize textSize = [title sizeWithFont:font];
	CGFloat margin = (button.frame.size.height - textSize.height) / 2;
	CGFloat marginRightLeft = (button.frame.size.width - textSize.width)/2;
	
	
	
	//CGFloat marginLeft = button.frame.size.width - textSize.width - marginRight;
	//(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
	[button setTitleEdgeInsets:UIEdgeInsetsMake(margin, marginRightLeft+3, margin, marginRightLeft-5)]; 
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];   
	
	return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)styledCancelBarButtonItemWithTarget:(id)target selector:(SEL)selector;
{
	UIImage *image = [UIImage imageNamed:@"button_square"];
	image = [image stretchableImageWithLeftCapWidth:20.0f topCapHeight:20.0f];
	
	NSString *title = NSLocalizedString(@"Cancel", nil);
	UIFont *font = [UIFont boldSystemFontOfSize:MA_BUTTON_FONT_SIZE];
	
	UIButton *button = [UIButton styledButtonWithBackgroundImage:image font:font title:title target:target selector:selector];   
	button.titleLabel.textColor = [UIColor blackColor];   
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];   
	
	return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)styledSubmitBarButtonItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;
{
	UIImage *image = [UIImage imageNamed:@"button_submit"];
	image = [image stretchableImageWithLeftCapWidth:20.0f topCapHeight:20.0f];
	
	UIFont *font = [UIFont boldSystemFontOfSize:MA_BUTTON_FONT_SIZE];
	
	UIButton *button = [UIButton styledButtonWithBackgroundImage:image font:font title:title target:target selector:selector];
	button.titleLabel.textColor = [UIColor whiteColor];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];   
	
	return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end


@implementation UIButton (UIButton_StyledButton)

+ (UIButton *)styledButtonWithBackgroundImage:(UIImage *)image font:(UIFont *)font title:(NSString *)title target:(id)target selector:(SEL)selector
{

	CGSize imgSize = image.size;
//	CGSize textSize = [title sizeWithFont:font];
//	CGSize buttonSize = CGSizeMake(textSize.width + 25.0f, image.size.height+2.0f);
	
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imgSize.width, imgSize.height)];
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	[button setBackgroundImage:image forState:UIControlStateNormal];
	[button setTitle:title forState:UIControlStateNormal];
	[button.titleLabel setFont:font];
	
	return button;
}



@end
