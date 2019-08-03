//
//  ViewController.m
//  AgoraRtmTest
//
//  Created by shy on 2019/8/2.
//  Copyright © 2019 shy. All rights reserved.
//

#import "ViewController.h"
#import <AgoraRtmKit/AgoraRtmKit.h>
#import "AgoraRtmConfig.h"
#import "WHToast.h"
#import "ChatPeerViewController.h"
#import "AppDelegate.h"
#import "WUserManager.h"
#import "MainTabBarController.h"

@interface ViewController ()

@property(nonatomic,strong)UITextField *mTextField;
@property(nonatomic,strong)UIButton *mLoginBtn;
@property(nonatomic,strong)AgoraRtmKit *mKit;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpView];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.mKit = appDelegate.kit;
    
    [App() loginOut];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)closeKeyboard
{
    [self.mTextField resignFirstResponder];
}

- (void)setUpView
{
    CGRect rect = CGRectMake(15.0f,100.0f,CGRectGetWidth(self.view.frame)- 30, 40.0f);
    self.mTextField = [[UITextField alloc]initWithFrame:rect];
    self.mTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.mTextField.layer.borderWidth = 1;
    self.mTextField.layer.cornerRadius = 5.0f;
    self.mTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.mTextField.placeholder = @"输入账号";
    [self.view addSubview:self.mTextField];
    
    rect = CGRectMake(15.0f, CGRectGetMaxY(self.mTextField.frame)+ 30.0f,CGRectGetWidth(self.mTextField.frame), 40.0f);
    self.mLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mLoginBtn.frame = rect;
    self.mLoginBtn.layer.cornerRadius = 5.0f;
    self.mLoginBtn.backgroundColor = RGBACOLOR(0, 145, 234, 1);
    [self.mLoginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.mLoginBtn addTarget:self action:@selector(handleLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mLoginBtn];
    
}

- (void)handleLoginBtn:(UIButton *)sender
{
    [self closeKeyboard];
    NSString *account = self.mTextField.text;
    if (account == nil || account.length <= 0)
    {
        [WHToast showMessage:@"请输入账号" duration:ToastShowDuration finishHandler:nil];
        return;
    }
    
    [self loginWithAccount:account];
    
    
    
}

- (void)loginWithAccount:(NSString *)account
{
    [self.mKit loginByToken:nil user:account completion:^(AgoraRtmLoginErrorCode errorCode) {
        if (errorCode != AgoraRtmLoginErrorOk)
        {
            [WHToast showMessage:@"登录失败" duration:ToastShowDuration finishHandler:nil];
        }else
        {
            [[WUserManager shareInstance] setCurrentAccount:account];
            MainTabBarController *mainVC = [[MainTabBarController alloc]init];
            UIWindow *window = (UIWindow *)[UIApplication sharedApplication].keyWindow;
            window.rootViewController = mainVC;
        }
    }];
}




@end
