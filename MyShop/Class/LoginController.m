
//
//  LoginController.m
//  MyShop
//
//  Created by SilverStar on 8/1/14.
//  Copyright (c) 2014 SilverStar. All rights reserved.
//

#import "LoginController.h"

#import "BZGFormField.h"

@interface LoginController ()<BZGFormFieldDelegate>

@property (assign, nonatomic) BOOL m_bValidEmail;
@property (assign, nonatomic) BOOL m_bValidPassword;

@property (strong, nonatomic) IBOutlet BZGFormField *emailField;
@property (strong, nonatomic) IBOutlet BZGFormField *passwordField;

@end

@implementation LoginController

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

    self.m_bValidEmail = NO;
    self.m_bValidPassword = NO;
    
    __weak LoginController *weakSelf = self;

    self.emailField.textField.placeholder = @"Email";
    [self.emailField.textField setKeyboardType:UIKeyboardTypeEmailAddress];
    [self.emailField setTextValidationBlock:^BOOL(NSString *text) {
        // from https://github.com/benmcredmond/DHValidation/blob/master/DHValidation.m
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailTest evaluateWithObject:text]) {
            weakSelf.emailField.alertView.title = @"Invalid email address";
            
            weakSelf.m_bValidEmail = NO;
            return NO;
        } else {
            weakSelf.m_bValidEmail = YES;
            return YES;
        }
    }];
    self.emailField.delegate = self;
    
    self.passwordField.textField.placeholder = @"Password";
    self.passwordField.textField.secureTextEntry = YES;
    [self.passwordField setTextValidationBlock:^BOOL(NSString *text) {
        if (text.length < 5) {
            weakSelf.passwordField.alertView.title = @"Password is too short";
            weakSelf.m_bValidPassword = NO;
            return NO;
        } else {
            weakSelf.m_bValidPassword = YES;
            return YES;
        }
    }];
    self.passwordField.delegate = self;
    
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

#pragma mark - BZGFormFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (IBAction)onClickForgetPwd:(id)sender {
    
}
- (IBAction)onClickLogin:(id)sender {
    
    NSString * textEmail = self.emailField.textField.text;
    NSString * textPassword = self.passwordField.textField.text;

    if (textEmail.length < 1 || textPassword.length < 1
        || !self.m_bValidEmail || !self.m_bValidPassword) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Warnings!"
                                                        message: @"Please input correct fields!"
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray * arrUsers = [defaults objectForKey:@"user_list"];
    
    if (arrUsers == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Warnings!"
                                                        message: @"That user no exist!"
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    for (NSDictionary *origin in  arrUsers) {
        if ([origin[@"email"] isEqualToString:textEmail]) {
            
            if ([origin[@"password"] isEqualToString:textPassword]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Good!"
                                                                message: @"logged in successfully"
                                                               delegate: nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Warnings"
                                                                message: @"password do not match.\nPlease input correct password"
                                                               delegate: nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
        }
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Warnings"
                                                    message: @"That user no exist"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
    return;
    
}

@end
