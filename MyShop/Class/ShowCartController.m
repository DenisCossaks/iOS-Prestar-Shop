//
//  ShowCartController.m
//  MyShop
//
//  Created by SilverStar on 7/31/14.
//  Copyright (c) 2014 SilverStar. All rights reserved.
//

#import "ShowCartController.h"

#import "Global.h"
#import "ViewCartCell.h"
#import "DLImageLoader.h"
#import "MyCacheProduct.h"


#define BTN_COMMENT_ID 1000
#define TOOLBAR_HEIGHT  64

@interface ShowCartController ()<UITableViewDataSource, UITableViewDelegate>
{
    
    IBOutlet UITableView *mTableView;
    IBOutlet UILabel *lbTotalPrice;
    
    int nSelItem ;
    int nSelTextField;
    
    BOOL    keyboardVisible;

}

@end

@implementation ShowCartController

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
    
    mTableView.delegate = self;
    mTableView.dataSource = self;
    
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [mTableView addGestureRecognizer:gestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidShow:) name: UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidHide:) name: UIKeyboardDidHideNotification object:nil];
    
    nSelTextField = -1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void) onRemove:(UIButton*) sender {
    
    nSelItem = (int)sender.tag - BTN_COMMENT_ID;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Note!"
                                                    message: @"Do you want to remove that item on Cart?"
                                                   delegate: self
                                          cancelButtonTitle:@"YES"
                                          otherButtonTitles:@"NO", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) { // YES
        [[Global sharedInstance].g_arrShopItem removeObjectAtIndex:nSelItem];
        
        [mTableView reloadData];
    }
}

#pragma mark --------------- Table view ---------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = (int)[[Global sharedInstance].g_arrShopItem count];
    return count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ViewCartCell";
    
    ViewCartCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary * shopItem = [[Global sharedInstance].g_arrShopItem objectAtIndex:indexPath.row];
    NSString * url = shopItem[@"xlink:href"];
    
    
    MyCacheProduct * cacheProduct = [[MyCacheProduct sharedInstance] init];
    
    NSDictionary * product = [cacheProduct getData:url];
    
    
    
    NSString * title = product[@"name"][@"language"][@"text"];
    cell.lbTitle.text = [[Global sharedInstance] correctString:title];
    
    float price = [[[Global sharedInstance] correctString:product[@"price"][@"text"]] floatValue];
    cell.lbPrice.text = [NSString stringWithFormat:@"$%.2f", price];
    
    
    NSString * urlImage = product[@"id_default_image"][@"xlink:href"];
    
    [DLImageLoader loadImageFromURL:urlImage
                          completed:^(NSError *error, NSData *imgData) {
                              if (error == nil) {
                                  // if we have no errors
                                  UIImage * image = [UIImage imageWithData:imgData];
                                  [cell.imgPhoto setImage:image];
                              }
                              else {
                              }
                              
                          }];
    
    cell.btnX.tag = BTN_COMMENT_ID + indexPath.row;
    [cell.btnX addTarget:self action:@selector(onRemove:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.tfQuantity addTarget:self action:@selector(myNumberValueBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    cell.tfQuantity.tag = 100 + indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)hideKeyboard{
    if (nSelTextField == -1) {
        return;
    }
    
    ViewCartCell * cell = (ViewCartCell*)[mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:nSelTextField inSection:0]];
    [cell.tfQuantity resignFirstResponder];
}

-(void)myNumberValueBeginEditing:(UITextField *)sender
{
    //    ViewCartCell * cell = (ViewCartCell*) sender.superview;
    nSelTextField = (int)sender.tag - 100;
    
    //    nSelTextField = [sender.superview.superview tag];
    //    UITextField *cellTemp = (UITextField*)[(UITableViewCell *)sender.superview viewWithTag:200+row];
    //    cellTemp.delegate = self;
    //    [cellTemp becomeFirstResponder];
}

#pragma mark ---------- Key board
-(void) keyboardDidShow: (NSNotification *)notif
{
    if (keyboardVisible)
	{
		return;
	}
	
	// Get the size of the keyboard.
	NSDictionary* info = [notif userInfo];
	NSValue* aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
	CGSize keyboardSize = [aValue CGRectValue].size;
	
    mTableView.frame = CGRectMake(mTableView.frame.origin.x, mTableView.frame.origin.y, mTableView.frame.size.width, mTableView.frame.size.height-keyboardSize.height+TOOLBAR_HEIGHT);
    
	// Keyboard is now visible
	keyboardVisible = YES;
    
    if (nSelTextField != 0) {
        [mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:nSelTextField inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(void) keyboardDidHide: (NSNotification *)notif
{
	// Is the keyboard already shown
	if (!keyboardVisible)
	{
		return;
	}
    
    NSDictionary* info = [notif userInfo];
	NSValue* aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
	CGSize keyboardSize = [aValue CGRectValue].size;
    
    mTableView.frame = CGRectMake(mTableView.frame.origin.x, mTableView.frame.origin.y, mTableView.frame.size.width, mTableView.frame.size.height+keyboardSize.height-TOOLBAR_HEIGHT);
    
	// Keyboard is no longer visible
	keyboardVisible = NO;
}
@end
