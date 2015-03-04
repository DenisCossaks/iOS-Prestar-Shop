//
//  DetailController.m
//  MyShop
//
//  Created by SilverStar on 7/31/14.
//  Copyright (c) 2014 SilverStar. All rights reserved.
//

#import "DetailController.h"

#import "Global.h"
#import "DLImageLoader.h"
#import "MyCacheProduct.h"


@interface DetailController ()
{
    IBOutlet UIImageView *ivPhoto;
    IBOutlet UIScrollView *mScrollView;
    IBOutlet UILabel *lbPrice;
    IBOutlet UITextView *tvDescription;
    
    NSArray * arrSubImages;
    int m_nSelectSubImage;
}

@end

@implementation DetailController

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
    
    
    NSString * url = self.m_product[@"xlink:href"];
    
    MyCacheProduct * cacheProduct = [[MyCacheProduct sharedInstance] init];
    
    NSDictionary * product = [cacheProduct getData:url];
    
    
    float price = [[[Global sharedInstance] correctString:product[@"price"][@"text"]] floatValue];
    lbPrice.text = [NSString stringWithFormat:@"$%.2f", price];
    
    
    NSString * description = product[@"description"][@"language"][@"text"];
    tvDescription.text = [[Global sharedInstance] correctString:description];
    
    arrSubImages = product[@"associations"][@"images"][@"image"];
    m_nSelectSubImage = 0;
    
    NSString * urlImage = [arrSubImages objectAtIndex:0][@"xlink:href"];
    [DLImageLoader loadImageFromURL:urlImage
                          completed:^(NSError *error, NSData *imgData) {
                              if (error == nil) {
                                  // if we have no errors
                                  UIImage * image = [UIImage imageWithData:imgData];
                                  [ivPhoto setImage:image];
                              }
                              else {
                              }
                              
                          }];
    
    
    [self refreshSubImage];
}

- (void) refreshSubImage
{
    for (UIView *v in [mScrollView subviews]) {
        [v removeFromSuperview];
    }
    
    int posx = 0;
    for (int i = 0; i < (int)[arrSubImages count]; i ++) {
        posx = 85 * i;
        int posy = 0;
        
        UIView * viewThumb = [[UIView alloc] initWithFrame:CGRectMake(posx, posy, 80, 80)];
        
        viewThumb.layer.borderColor = [UIColor grayColor].CGColor;
        if (m_nSelectSubImage == i) {
            viewThumb.layer.borderWidth = 3;
        } else {
            viewThumb.layer.borderWidth = 1;
        }
        viewThumb.backgroundColor = [UIColor clearColor];
        
        UIImageView * ivThumb = [[UIImageView alloc] initWithFrame:CGRectMake(posx, posy, 80, 80)];
        ivThumb.tag = 3000 + i;
        
        NSString * thumbUrl = [arrSubImages objectAtIndex:i][@"xlink:href"];
        
        [DLImageLoader loadImageFromURL:thumbUrl
                              completed:^(NSError *error, NSData *imgData) {
                                  if (error == nil) {
                                      // if we have no errors
                                      UIImage * image = [UIImage imageWithData:imgData];
                                      
                                      UIImageView *imageView = (UIImageView*)[mScrollView viewWithTag:3000+i];
                                      [imageView setImage:image];
                                  }
                              }];

        viewThumb.tag = 5000 + i;
        viewThumb.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapGestureUser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectThumb:)];
        tapGestureUser.numberOfTapsRequired = 1;
        [viewThumb addGestureRecognizer:tapGestureUser];
     
        [mScrollView addSubview:ivThumb];
        [mScrollView addSubview:viewThumb];
    }
    
    [mScrollView setContentSize:CGSizeMake(posx + 80, 80)];

}

-(void) onSelectThumb:(UITapGestureRecognizer*) gesture
{
    UIView * imageView = (UIView*) gesture.view;
    m_nSelectSubImage = (int)imageView.tag - 5000;

    NSString * urlImage = [arrSubImages objectAtIndex:m_nSelectSubImage][@"xlink:href"];
    
    [DLImageLoader loadImageFromURL:urlImage
                          completed:^(NSError *error, NSData *imgData) {
                              if (error == nil) {
                                  // if we have no errors
                                  UIImage * image = [UIImage imageWithData:imgData];
                                  [ivPhoto setImage:image];
                              }
                              else {
                              }
                          }];
    
    [self refreshSubImage];
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
- (IBAction)onClickAddCart:(id)sender {
    if ([Global sharedInstance].g_arrShopItem == nil) {
        [Global sharedInstance].g_arrShopItem = [[NSMutableArray alloc] init];
    }
    
    if ([[Global sharedInstance].g_arrShopItem containsObject:self.m_product]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Note"
                                                        message: @"That item is already added!"
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else {
        [[Global sharedInstance].g_arrShopItem addObject:self.m_product];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Added"
                                                        message: @"That item is added successfully!"
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (IBAction)onClickShareFb:(id)sender {
}
- (IBAction)onClickShareTw:(id)sender {
}
- (IBAction)onClickShareEmail:(id)sender {
}
- (IBAction)onClickShareSMS:(id)sender {
}

@end
