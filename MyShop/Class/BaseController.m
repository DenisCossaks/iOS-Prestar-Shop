//
//  BaseController.m
//  MyShop
//
//  Created by SilverStar on 8/1/14.
//  Copyright (c) 2014 SilverStar. All rights reserved.
//

#import "BaseController.h"


#import "MBProgressHUD.h"


@interface BaseController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@end

@implementation BaseController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) showLoading : (NSString*) label
{
    if (self.navigationController.view == nil) {
        return;
    }
    
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
    }
    HUD.labelText = label;
    
    HUD.delegate = self;
	
    [HUD show:YES];
    
	// Show the HUD while the provided method executes in a new thread
    //	[HUD showWhileExecuting:@selector(myTask) onTarget:nil withObject:nil animated:YES];
}
-(void)  showChangeLabel:(NSString*) label
{
    HUD.labelText = label;
}

- (void) showFail {
    
    [self showFail:@"Network Communication Issue!"];
    
}
- (void) showFail:(NSString*) label {
    
    if (self.navigationController.view == nil) {
        return;
    }
    
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        
        HUD.delegate = self;
        
        [HUD show:YES];
    }
    
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = label;
    
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    
}


- (void)showWithCustomView:(NSString * ) label {
    if (self.navigationController.view == nil) {
        return;
    }
    
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
    }
	
	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	
	// Set custom view mode
	HUD.mode = MBProgressHUDModeCustomView;
	
	HUD.delegate = self;
	HUD.labelText = label;
	
	[HUD show:YES];
    
    //	[HUD hide:YES afterDelay:3];
	[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    
}
-(void) myTask {
    sleep(2);
}

- (void) hideLoading
{
    [HUD hide:YES];
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

@end
