//
//  MaSubItemController.m
//  MoreCafe
//
//  Created by Thunder on 12/30/12.
//  Copyright (c) 2012 MagicApp. All rights reserved.
//

#import "MaSubItemController.h"
#import "UIBarButtonItem+StyledButton.h"

@interface MaSubItemController ()

@end

@implementation MaSubItemController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	UIImage *image = [UIImage imageNamed:@"backButtom"];
	self.navigationItem.leftBarButtonItem = [UIBarButtonItem styledBackBarImgButtonItemWithTarget:self selector:@selector(dismissViewController) buttomImage:image];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dismissViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
