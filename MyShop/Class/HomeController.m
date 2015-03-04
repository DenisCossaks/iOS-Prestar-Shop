//
//  HomeController.m
//  MyShop
//
//  Created by SilverStar on 7/25/14.
//  Copyright (c) 2014 SilverStar. All rights reserved.
//

#import "HomeController.h"
#import "ShopListCell.h"

#import "MyUrl.h"

#import "XMLReader.h"
#import "ASIFormDataRequest.h"

#import "MyCacheProduct.h"
#import "Global.h"

#import <MessageUI/MFMailComposeViewController.h>//mail controller

#import "DetailController.h"


#define BTN_IMAGE_ID    2000


@interface HomeController ()<UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, MFMailComposeViewControllerDelegate>
{
    IBOutlet UISearchBar *mSearchBar;
    IBOutlet UICollectionView *mCollectionView;
    
    IBOutlet UIButton *btnList;
    BOOL m_bIsListMode;
    
    NSArray * m_arrAllProducts;
    NSMutableArray * m_arrProducts;
    
    int m_indexDetail;
}

@end

@implementation HomeController

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
    
  
    mSearchBar.delegate = self;
    
    m_bIsListMode = NO;
    
    [self authentication];
//    [self getProductsList];
    
//    [self setCollectionViewMode];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"gotoDetail"])
    {
        // Get reference to the destination view controller
        NSDictionary * shopItem = [m_arrProducts objectAtIndex:m_indexDetail];
        
        DetailController *vc = [segue destinationViewController];
        vc.m_product = [[NSDictionary alloc] initWithDictionary:shopItem];
    }
}


- (void) authentication
{
    [super showLoading:@"Loading..."];
    
    NSString *url = [MyUrl getServerUrl];
    
    __weak ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setUsername:API_KEY];
    [request setPassword:@""];
    [request setCompletionBlock:^ {
//        NSString * responseString = [request responseString];
//        NSLog(@"result = %@", responseString);
        
        [self getProductsList];
    }];
    [request setFailedBlock:^{
        NSError * error = [request error];
        NSLog(@"error + %@", error);
        
        [super showFail];
    }];
    
    [request startAsynchronous];
}

- (void) getProductsList
{
    [NSThread detachNewThreadSelector: @selector(postServer) toTarget:self withObject:nil];
}

-(void) postServer
{
    NSString * urlString = [NSString stringWithFormat:@"%@/api/products", SERVER_URL];
    NSLog(@"url result = %@", urlString);
    
    __weak ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setRequestMethod:@"GET"];
    [request setCompletionBlock:^ {
        NSString * responseString = [request responseString];
        
        NSLog(@"result = %@", responseString);

        NSError * error = nil;
        NSDictionary * result = [XMLReader dictionaryForXMLString:responseString error:&error];
        if (error != nil) {
            NSLog(@"Error = %@", error);
            return;
        }
        
        NSLog(@"result = %@", result);
        
        m_arrAllProducts = result[@"prestashop"][@"products"][@"product"];
        m_arrProducts = [[NSMutableArray alloc] initWithArray:m_arrAllProducts];
        
        [super hideLoading];
        
        if (result != nil) {
            [self performSelectorOnMainThread:@selector(setCollectionViewMode) withObject:nil waitUntilDone:YES];
        }
    }];
    [request setFailedBlock:^{
        NSError * error = [request error];
        NSLog(@"error + %@", error);
        
        [super showFail];
    }];
    [request startAsynchronous];

}


- (IBAction)onClickUser:(id)sender {
}

- (IBAction)onClickListMode:(id)sender {
    
    m_bIsListMode = !m_bIsListMode;
    
    if (m_bIsListMode) {
        [btnList setImage:[UIImage imageNamed:@"btn_grid.png"] forState:UIControlStateNormal];
    } else {
        [btnList setImage:[UIImage imageNamed:@"btn_list.png"] forState:UIControlStateNormal];
    }
    
    [self setCollectionViewMode];
}

- (void) setCollectionViewMode
{
    mCollectionView.delegate = self;
    mCollectionView.dataSource = self;
    
    [mCollectionView reloadData];
}
- (IBAction)onClickEmail:(id)sender {
    NSString *subject = @"Contact us";
    
    if(![MFMailComposeViewController canSendMail]){
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please configure your mail settings to send email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    MFMailComposeViewController* mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:subject];
//    [mc setToRecipients:emails];
//    [mc setMessageBody:body isHTML:NO];
    
    [self presentViewController:mc animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    switch (result) {
        case MFMailComposeResultSent:
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {

    if (m_arrProducts == nil) {
        return 0;
    }
    
    return [m_arrProducts count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (m_bIsListMode) {
        return CGSizeMake(310, 200);
    } else {
        return CGSizeMake(150, 260);
    }
    
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * cellIdentifier = @"";
    if (m_bIsListMode) {
        cellIdentifier = @"list_cell";
    } else {
        cellIdentifier = @"grid_cell";
    }
    
    ShopListCell *cell = [cv dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    cell.ivThumbnail.tag = BTN_IMAGE_ID + indexPath.row;
    cell.ivThumbnail.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGestureUser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProductDetail:)];
    tapGestureUser.numberOfTapsRequired = 1;
    [cell.ivThumbnail addGestureRecognizer:tapGestureUser];

    
    
    cell.btnAddCart.tag = indexPath.row;
    [cell.btnAddCart addTarget:self action:@selector(onAddCart:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary * dicProduct = [m_arrProducts objectAtIndex:indexPath.row];
    
    NSString * url = dicProduct[@"xlink:href"];
    
    [cell setProduct:url];
    
    return cell;
}

-(void) onProductDetail:(UITapGestureRecognizer*) gesture
{
    UIImageView * imageView = (UIImageView*) gesture.view;
    m_indexDetail = (int)imageView.tag - BTN_IMAGE_ID;
    
    
    [self performSegueWithIdentifier:@"gotoDetail" sender:self];
}

- (void) onAddCart:(UIButton*) sender
{
    int index = (int) sender.tag;
    
    NSDictionary * shopItem = [m_arrProducts objectAtIndex:index];
    
    if ([Global sharedInstance].g_arrShopItem == nil) {
        [Global sharedInstance].g_arrShopItem = [[NSMutableArray alloc] init];
    }
    
    if ([[Global sharedInstance].g_arrShopItem containsObject:shopItem]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Note"
                                                        message: @"That item is already added!"
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else {
        [[Global sharedInstance].g_arrShopItem addObject:shopItem];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Added"
                                                        message: @"That item is added successfully!"
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma SearchBar Delegate
- (void) search:(NSString*) text
{
    if (text.length < 1) {
        m_arrProducts = [[NSMutableArray alloc] initWithArray:m_arrAllProducts];
        [mCollectionView reloadData];
        return;
    }
    
    [m_arrProducts removeAllObjects];
    
    MyCacheProduct * product = [[MyCacheProduct sharedInstance] init];
    
    for (int i = 0 ; i < [m_arrAllProducts count]; i ++) {
        NSDictionary * dicProduct = [m_arrAllProducts objectAtIndex:i];
        NSString * url = dicProduct[@"xlink:href"];
        
        NSDictionary * dic = [product getData:url];
        
        NSString * title = dic[@"name"][@"language"][@"text"];
        NSString * description = dic[@"description_short"][@"language"][@"text"];
        
        NSString * fullText = [NSString stringWithFormat:@"%@ %@", title, description];
        
        NSLog(@"fullText = %@", fullText);
        if ([fullText rangeOfString:text].location != NSNotFound) {
            [m_arrProducts addObject:[m_arrAllProducts objectAtIndex:i]];
        }
    }
    
    [mCollectionView reloadData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    mSearchBar.showsCancelButton = YES;
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"search = %@", searchText);
    
    [self search:searchText];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    mSearchBar.showsCancelButton = NO;
    [mSearchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    mSearchBar.text = @"";
    [self search:@""];
    
    mSearchBar.showsCancelButton = NO;
    [mSearchBar resignFirstResponder];
    
    
}

@end
