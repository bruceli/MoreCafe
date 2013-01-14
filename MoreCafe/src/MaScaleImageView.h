//
//  MaScaleImageView.h
//  MoreArt
//
//  Created by Thunder on 11/30/12.
//  Copyright (c) 2012 MagicApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@protocol MaScaleImageViewDelegate
-(void)toggleZoom:()view;
@end 

@interface MaScaleImageView : UIScrollView <UIScrollViewDelegate, AsyncImageViewDelegate>
{
	AsyncImageView* _imageView;
	CGRect _imageViewFrame;
}

-(void)loadImageFrom:(NSString*)imgPath;
-(void)setPreloadedImages:(UIImage*)img;
-(void)changeRotation;
@property (nonatomic, weak) id <MaScaleImageViewDelegate> scaleImageViewDelegate; 


@end
