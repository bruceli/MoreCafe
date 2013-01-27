//
//  UIBarButtonItem+StyledButton.h
//  MoreArt
//
//  Created by Thunder on 12/22/12.
//  Copyright (c) 2012 MagicApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (StyledButton)
+ (UIBarButtonItem *)styledBackBarImgButtonItemWithTarget:(id)target selector:(SEL)selector buttomImage:(UIImage*)image;
+ (UIBarButtonItem *)styledBackBarButtonItemWithTarget:(id)target selector:(SEL)selector;
+ (UIBarButtonItem *)styledCancelBarButtonItemWithTarget:(id)target selector:(SEL)selector;
+ (UIBarButtonItem *)styledSubmitBarButtonItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;

@end

@interface UIButton (UIButton_StyledButton)
+ (UIButton *)styledButtonWithBackgroundImage:(UIImage *)image font:(UIFont *)font title:(NSString *)title target:(id)target selector:(SEL)selector;
@end
