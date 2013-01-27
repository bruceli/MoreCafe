//
//  MaPostController.m
//  WeiboNote
//
//  Created by Accthun He on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaPostController.h"
#import "RDActionSheet.h"
//#import "MaImageViewController.h"
#import "MoreCafeAppDelegate.h"
#import "SinaWeibo.h"

#import "UIImage+Resize.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <QuartzCore/QuartzCore.h>
#import "UIBarButtonItem+StyledButton.h"

@interface MaPostController() 
-(void)removeCapturedImage;
-(void)removeCameraButton;
-(void)viewCapturedImage;
-(void)updateSendButtonStatus;
//-(void)setupPostCtrlStatus;
-(UIImage*)resizeImage:(UIImage*)inImage;
-(UIImage*)textToImage:(NSString*)text;
-(BOOL)isMaxLength:(NSString*)text;
@end

@implementation MaPostController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        isSendCancelled = YES;
        isViewImage = YES;
        capturedImage = nil;

        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        
        _postToolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, screenBounds.size.width, 44)];
 //       _postToolbar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"toobarBackground"]];
		_postToolbar.barStyle = UIBarStyleBlackTranslucent;		
		
		UIImage *image = [UIImage imageNamed:@"closeButtom"];
		self.navigationItem.leftBarButtonItem = [UIBarButtonItem styledBackBarImgButtonItemWithTarget:self selector:@selector(cancel) buttomImage:image];
		
		image = [UIImage imageNamed:@"sendButtom"];
		self.navigationItem.rightBarButtonItem = [UIBarButtonItem styledBackBarImgButtonItemWithTarget:self selector:@selector(post) buttomImage:image];


   //     UINavigationBar* navBar = self.navigationController.navigationBar;
     //   [navBar setBackgroundImage:[UIImage imageNamed: @"toobarBackground"] forBarMetrics:UIBarMetricsDefault];

        // init textView
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, 0)];
        [_textView setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        self.view.backgroundColor = [UIColor grayColor];
        [_textView becomeFirstResponder];
        [self.view addSubview:_textView];
        //Disable scrollerIndicator
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.showsVerticalScrollIndicator = YES;

        _textView.text = NSLocalizedString(@"WeiboTag",nil);
        
        _textView.delegate = self;
        // other init actions.
       
        UIImage* camIcon = [UIImage imageNamed:@"camera"];
		UIButton *camBaseButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,48,48)];
        [camBaseButton setImage:camIcon forState:UIControlStateNormal];
        [camBaseButton addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
         cameraButton = [[UIBarButtonItem alloc] initWithCustomView:camBaseButton];

        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        // Counting lable
        _theLable = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 11.0f, 120, 21.0f)];
        [_theLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [_theLable setBackgroundColor:[UIColor clearColor]];
        [_theLable setTextColor:[UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1.0]];
//        [_theLable setText:@"140"];
        [self updateTextCounter];
        [_theLable setTextAlignment:NSTextAlignmentRight];
        UIBarButtonItem* lableItem = [[UIBarButtonItem alloc] initWithCustomView:_theLable];
        
        
        NSArray *items = [[NSArray alloc] initWithObjects:cameraButton, flexibleSpace, lableItem, nil];
        [_postToolbar setItems:items];
        [self.view addSubview:_postToolbar];
        
        [_postToolbar sizeToFit];
        //Set the toolbar to fit the width of the app. 
	}
    return self;
}

-(void)setText:(NSString*)string image:(UIImage*)image
{
	_textView.text = string;
	capturedImage = image; 
	[self updateTextCounter];
	[self updateToolbarImageIcon];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    //   [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification 
{
    // Get Keyboard Top point
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardHeight = keyboardRect.size.height;
//    NSLog(@"keyboardHeight is %f", keyboardHeight); 

    CGFloat textViewHeight = self.view.bounds.size.height - keyboardHeight -_postToolbar.bounds.size.height;
//    NSLog(@"textViewHeight is %f ",textViewHeight);

    CGRect newScreenViewRect = CGRectMake(_textView.frame.origin.x, _textView.frame.origin.y, _textView.frame.size.width, textViewHeight);
    _textView.frame = newScreenViewRect;
    
    //CGFloat toolbarY = keyboardRect.origin.y - _postToolbar.bounds.size.height;
    CGFloat toolbarY = self.view.bounds.size.height - keyboardHeight -_postToolbar.bounds.size.height ;
    
    CGRect toolbarRect = CGRectMake(self.view.bounds.origin.x, toolbarY, _postToolbar.frame.size.width, _postToolbar.frame.size.height);
//    NSLog(@"Toolbar Button is %f",toolbarY +  _postToolbar.bounds.size.height); 
//    NSLog(@"Keyboard Top point is %f", keyboardRect.origin.y ); 
//    NSLog(@"\n");
    
    _postToolbar.frame = toolbarRect;
}

- (void)scrollViewDidScroll:(id)scrollView
{
    // disable Horizontal Scrolling
    CGPoint origin = [scrollView contentOffset]; 
    [scrollView setContentOffset:CGPointMake(0, origin.y)];
}

-(void)updateTextCounter
{
    // Enable send button
    // Change character counts
    // Change CamaraButton
    
    if ([self isMaxLength:_textView.text]) 
        _theLable.text = NSLocalizedString(@"WeiboLongMessageTextCount",nil);
    else
        _theLable.text = [NSString stringWithFormat:@"%d", MAX_TEXT_LENGTH - textCount];
    
    [self updateSendButtonStatus];
    [self updateCaptureImageButtonStatus];

}

- (void)textViewDidChange:(UITextView *)textView
{    
    [self updateTextCounter];
}
- (void)textViewDidEndEditing:(UITextView *)textView;
{
    [self updateTextCounter];
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{   
    
    if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraUI.delegate = self;
        cameraUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        cameraUI.allowsEditing = NO;
        
        [self presentViewController: cameraUI animated: YES completion:nil];
        
    } 
}

- (void)addImage
{
    [_textView resignFirstResponder];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        RDActionSheet *actionSheet = [[RDActionSheet alloc] initWithCancelButtonTitle:NSLocalizedString(@"WeiboCancel",nil) primaryButtonTitle:nil destroyButtonTitle:nil otherButtonTitles: NSLocalizedString(@"WeiboChooseFromLib",nil), NSLocalizedString(@"WeiboTakeFromCam",nil), nil];
        actionSheet.callbackBlock = ^(RDActionSheetResult result, NSInteger buttonIndex) 
        {
            
            switch (result) {
                case RDActionSheetButtonResultSelected:{
                    if(buttonIndex == 0){   // Select from Library
                        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
                        
                    }
                    
                    if (buttonIndex == 1 ) {    // Take a Photo
                        [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
                    }
                    
//                    NSLog(@"Pressed %i", buttonIndex);
                    break;
                }
                case RDActionSheetResultResultCancelled:{
                    [_textView becomeFirstResponder];
                    
                }
//                    NSLog(@"Sheet cancelled");
            }
        };
        
        [actionSheet showFrom: self.view];
        
    }
    else 
        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
}

-(void)imageButtonAction
{
    [_textView resignFirstResponder];
    RDActionSheet *actionSheet = [[RDActionSheet alloc] initWithCancelButtonTitle:NSLocalizedString(@"WeiboCancel",nil) primaryButtonTitle:nil destroyButtonTitle:NSLocalizedString(@"WeiboRemovePict",nil) otherButtonTitles: NSLocalizedString(@"WeiboViewPict",nil), nil];
    
    actionSheet.callbackBlock = ^(RDActionSheetResult result, NSInteger buttonIndex) 
    {
        switch (result) {
            case RDActionSheetButtonResultSelected:{
                if(buttonIndex == 0){   // Delete Image
                    isViewImage = YES;
                    [self removeCapturedImage];
                }
                
                if (buttonIndex == 1 ) {    // View Image
                    isViewImage = NO;
                    [self viewCapturedImage];
                }
                
//                NSLog(@"Pressed %i", buttonIndex);
                break;
            }
                
            case RDActionSheetResultResultCancelled:{
                if(isViewImage)
                    [_textView becomeFirstResponder];    
            }
        }
    };
    
    [actionSheet showFrom: self.view];
}

- (void)addLocation
{
    
}

-(void)mention
{
    
}

- (void) sendMessage:(NSString*) text withImage:(UIImage*)image
{
    UIImage* outputImage = image;
    NSMutableString* messageText = [[NSMutableString alloc] initWithString:text];
    if (messageText.length == 0 && image) {
        [messageText appendString:NSLocalizedString(@"WeiboShareImage",nil)];
    }
    
    //resize Image
    if (image) {
        if (capturedImage.size.width > OUTPUT_IMAGE_WIDE_MAX)
        {
            outputImage = [self resizeImage:image];
            [self sendWeiBoWithText:messageText image:outputImage];
        }
        else {
            [self sendWeiBoWithText:messageText image:image];
        }
    }
    else {
        [self sendWeiBoWithText:messageText image:nil];
    }
}

- (void)sendWeiBoWithText:(NSString *)text image:(UIImage *)image
{
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
	MoreCafeAppDelegate *app = (MoreCafeAppDelegate *)[UIApplication sharedApplication].delegate;
	SinaWeibo *sinaweibo = app.sinaweibo;
		
	[params setObject:(text ? text : @"") forKey:@"status"];
		
	if (image)
	{
		[params setObject:image forKey:@"pic"];
		[sinaweibo requestWithURL:@"statuses/upload.json"
						   params:params
					   httpMethod:@"POST"
						 delegate:(id<SinaWeiboRequestDelegate>)app.weiboViewController];
	}
	else
	{
		[sinaweibo requestWithURL:@"statuses/update.json"
						   params:params
					   httpMethod:@"POST"
						 delegate:(id<SinaWeiboRequestDelegate>)app.weiboViewController];
	}

}

-(void) rePostMessage:(NSString*) message
{
//    [engine repostWithWeiboID:weiboID message:message];
}

-(void) commentPostMessage:(NSString*) message
{
//    [engine commentWithWeiboID:weiboID message:message];
}

- (void)post {
    
    if ([self isMaxLength:_textView.text ]) {   // Out of MAX_TEXT_LENGTH
        UIImage* img =  [self textToImage:_textView.text];
        [self sendMessage:NSLocalizedString(@"WeiboLongMessage",nil) withImage:img];
    }
    else 
		[self sendMessage:_textView.text withImage:capturedImage];

    [self destoryPostView];
}

- (void)destoryPostView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel {
        [self destoryPostView];    
}


-(void)updateImageButton
{
    UIButton* imgButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    imgButton.frame = CGRectMake(0, 0, 30, 30); 
    [imgButton setImage:capturedImage forState:UIControlStateNormal];
    [imgButton addTarget:self action:@selector(imageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    imageButton = [[UIBarButtonItem alloc] initWithCustomView:imgButton];
    
}

-(void)updateSendButtonStatus
{
    if (_textView.text.length > 0 || capturedImage) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

-(void)updateCaptureImageButtonStatus
{
    if (textCount > MAX_TEXT_LENGTH ) {
        [cameraButton setEnabled:NO];
        [imageButton setEnabled:NO];
    }
    else{
        [cameraButton setEnabled:YES];
        [imageButton setEnabled:YES];
    }
}

-(void)updateToolbarImageIcon
{
    [self updateImageButton];  
    
    NSMutableArray* newItems = [NSMutableArray arrayWithArray: _postToolbar.items];
    NSInteger index = [newItems indexOfObject:cameraButton];
    
    [newItems replaceObjectAtIndex:index withObject:imageButton];
    
    [_postToolbar setItems:newItems animated:YES];
}

-(void)removeCapturedImage
{
//    [self updateImageButton];  
    
    NSMutableArray* newItems = [NSMutableArray arrayWithArray: _postToolbar.items];
    [newItems replaceObjectAtIndex:IMAGE_ICON_INDEX withObject:cameraButton];
    [_postToolbar setItems:newItems animated:YES];
    
    capturedImage = Nil;
    
    [self updateSendButtonStatus];
}

-(void)removeCameraButton
{
    NSMutableArray* newItems = [NSMutableArray arrayWithArray: _postToolbar.items];
    [newItems removeObject:cameraButton];
    [_postToolbar setItems:newItems animated:YES];
}

-(void)viewCapturedImage
{   
	[self toggleZoom:_postToolbar];
}

-(void) toggleZoom:(UIView*) sender 
{
	if (_hiddenView)
	{					
		// zoomout
		CGRect frame = [sender.window convertRect:_hiddenView.frame fromView:_hiddenView.superview];
		[UIView animateWithDuration:0.3 animations:
		 ^{ sender.frame = frame; sender.alpha = 0.0;[_textView becomeFirstResponder];} 
						 completion:
		 ^(BOOL finished){
			 [_scaleImageView removeFromSuperview];
			 _hiddenView = nil;
			 _scaleImageView = nil;

		 }];
	}
	else
	{					// zoom in		
		_hiddenView = (AsyncImageView*)sender;
		CGRect frame = [sender.window convertRect:sender.frame fromView:sender.superview];
		
		CGRect screenRect = [[UIScreen mainScreen] bounds];
		_scaleImageView = [[MaScaleImageView alloc] initWithFrame:frame];
		_scaleImageView.scaleImageViewDelegate = self;
		[UIView animateWithDuration:0.2 animations:^{ _scaleImageView.frame = screenRect; }];
		
		[_scaleImageView setImage:capturedImage ]; 
		[sender.window addSubview:_scaleImageView];		
	}
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
	[[gestureRecognizer.view superview] removeFromSuperview];
}

-(UIImage*)resizeImage:(UIImage*)inImage
{
    UIImage* resizedImage;
    CGFloat ratio = inImage.size.height / inImage.size.width;
    CGSize newImageSize;
    newImageSize.width = OUTPUT_IMAGE_WIDE_MAX;
    newImageSize.height = OUTPUT_IMAGE_WIDE_MAX * ratio;

  //  inImage = [inImage resizedImage:newImageSize ];
    resizedImage = [inImage resizedImage:newImageSize interpolationQuality:kCGInterpolationMedium];

    return resizedImage;
}

-(UIImage*)textToImage:(NSString*)text
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0,0,420,320)];
    UILabel* lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 420, 320)];
    
    [view addSubview:lable];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.lineBreakMode = NSLineBreakByCharWrapping;//;UILineBreakModeCharacterWrap;
    lable.numberOfLines = 0;

    
    lable.text = text;
    [lable sizeToFit];
    CGRect frame = lable.frame;
    frame.size.height = lable.frame.size.height+40;
    frame.size.width = lable.frame.size.width+40;
    [view setFrame:frame]; 
    
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    /*
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,  YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:@"text.jpg"];
    [fileManager createFileAtPath:fullPath contents:data attributes:nil];
    */
    
    return image;

}

#pragma mark -
#pragma mark ImagePickerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    capturedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self updateToolbarImageIcon];
    [self updateSendButtonStatus];
    [_textView becomeFirstResponder];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [_textView becomeFirstResponder];
}


-(BOOL)isMaxLength:(NSString*)text;
{
    int l=0,a=0,b=0;
    unichar c;
    for (int i=0; i<[text length]; i++)
    {
        c=[text characterAtIndex:i];
            if(isblank(c)){
                b++;
            }else if(isascii(c)){
                a++;
            }else{
                l++;
            }
    }
    if(a==0 && l==0) 
        textCount = 0;
    else 
        textCount = l+(int)ceilf((float)(a+b)/2.0);

//    NSLog(@"Count Methord C, %d",textCount);
         
    if (textCount > MAX_TEXT_LENGTH)
        return YES;
    else
        return NO;
}


@end
