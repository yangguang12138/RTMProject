//
//  ChatPeerViewController.m
//  AgoraRtmTest
//
//  Created by shy on 2019/8/2.
//  Copyright © 2019 shy. All rights reserved.
//

#import "ChatPeerViewController.h"
#import "AppDelegate.h"
#import "WHToast.h"
#import "AgoraRtmConfig.h"
#import "ViewController.h"
#import "ChatViewController.h"

@interface ChatPeerViewController ()

@property(nonatomic,strong)UITextField *mTextField;
@property(nonatomic,strong)UIButton *mLoginBtn;

@end

@implementation ChatPeerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"聊天";
    
    [self setUpView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)closeKeyboard
{
    [self.mTextField resignFirstResponder];
}

- (void)setUpView
{
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect rect = CGRectMake(15.0f,100.0f,CGRectGetWidth(self.view.frame)- 30, 40.0f);
    self.mTextField = [[UITextField alloc]initWithFrame:rect];
    self.mTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.mTextField.layer.borderWidth = 1;
    self.mTextField.layer.cornerRadius = 5.0f;
    self.mTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.mTextField.placeholder = @"好友的账号";
    [self.view addSubview:self.mTextField];
    
    rect = CGRectMake(15.0f, CGRectGetMaxY(self.mTextField.frame)+ 30.0f,CGRectGetWidth(self.mTextField.frame), 40.0f);
    self.mLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mLoginBtn.frame = rect;
    self.mLoginBtn.layer.cornerRadius = 5.0f;
    self.mLoginBtn.backgroundColor =RGBACOLOR(0, 145, 234, 1);
    [self.mLoginBtn setTitle:@"发消息" forState:UIControlStateNormal];
    [self.mLoginBtn addTarget:self action:@selector(handleLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mLoginBtn];
}

- (void)handleLoginBtn:(UIButton *)sender
{
    [self closeKeyboard];
    NSString *account = self.mTextField.text;
    if (account == nil || account.length <= 0)
    {
        [WHToast showMessage:@"请输入好友的账号" duration:ToastShowDuration finishHandler:nil];
        return;
    }
    
    ChatViewController *chatVC = [[ChatViewController alloc]init];
    chatVC.userName = self.mTextField.text;
    chatVC.chatType = ChatType_Single;
    [self.navigationController pushViewController:chatVC animated:YES];
}

@end
