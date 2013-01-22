//
//  MaPostController.h
//  WeiboNote
//
//  Created by Accthun He on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaDefine.h"
#import "MaScaleImageView.h"

#define IMAGE_ICON_INDEX 0

@interface MaPostController : UIViewController<UIActionSheetDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MaScaleImageViewDelegate>
{
    // PostController UI element.
    UIToolbar* _postToolbar;
    UILabel* _theLable;
    UIBarButtonItem* cameraButton;
    UIBarButtonItem* imageButton;
    UITextView* _textView;
    UINavigationBar* _navBar;
    UIImagePickerController *imagePickerController;
    NSInteger textCount;
    NSInteger textCountSEC;

    // PostController Status.
    BOOL isSendCancelled;
    BOOL isViewImage;
    
    // PostController Message Data
    UIImage* capturedImage;
    NSNumber* weiboID;      
	
	AsyncImageView* _hiddenView;
	MaScaleImageView* _scaleImageView;

}
-(void)setText:(NSString*)string image:(UIImage*)image;

@end
