//
//  SignUpController.m
//  MyShop
//
//  Created by SilverStar on 8/1/14.
//  Copyright (c) 2014 SilverStar. All rights reserved.
//

#import "SignUpController.h"

#import "BZGFormField.h"

@interface SignUpController ()<BZGFormFieldDelegate>

@property (assign, nonatomic) BOOL m_bValidEmail;
@property (assign, nonatomic) BOOL m_bValidPassword;
@property (assign, nonatomic) BOOL m_bValidConfirmPassword;

@property (weak, nonatomic) IBOutlet BZGFormField *nameField;
@property (weak, nonatomic) IBOutlet BZGFormField *emailField;
@property (weak, nonatomic) IBOutlet BZGFormField *passwordField;
@property (weak, nonatomic) IBOutlet BZGFormField *passwordConfirmField;

@end

@implementation SignUpController

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
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.m_bValidEmail = NO;
    self.m_bValidPassword = NO;
    self.m_bValidConfirmPassword = NO;
    
    
    __weak SignUpController *weakSelf = self;

    self.nameField.textField.placeholder = @"Name";

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
    
    self.passwordConfirmField.textField.placeholder = @"Confirm Password";
    self.passwordConfirmField.textField.secureTextEntry = YES;
    [self.passwordConfirmField setTextValidationBlock:^BOOL(NSString *text) {
        if (![text isEqualToString:self.passwordField.textField.text]) {
            weakSelf.passwordConfirmField.alertView.title = @"Password confirm doesn't match";
            weakSelf.m_bValidConfirmPassword = NO;
            return NO;
        } else {
            weakSelf.m_bValidConfirmPassword = YES;
            return YES;
        }
    }];
    self.passwordConfirmField.delegate = self;
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
- (IBAction)onClickSignUP:(id)sender {
    
    NSString * textName = self.nameField.textField.text;
    NSString * textEmail = self.emailField.textField.text;
    NSString * textPassword = self.passwordField.textField.text;
    
    if (textName.length < 1
        || textEmail.length < 1 || textPassword.length < 1
        || !self.m_bValidEmail || !self.m_bValidPassword || !self.m_bValidConfirmPassword) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Warnings!"
                                                        message: @"Please input correct fields!"
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    NSMutableDictionary * userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     textName, @"name",
                                     textEmail, @"email",
                                     textPassword, @"password",
                                     nil];
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray * arrUsers = [defaults objectForKey:@"user_list"];
    
    if (arrUsers == nil) {
        arrUsers = [[NSMutableArray alloc] init];
    }
    [arrUsers addObject:userInfo];
    
    [defaults setValue:arrUsers  forKey:@"user_list"];
    [defaults synchronize];
    
    [super showWithCustomView:@"Created successfully"];
}

@end
