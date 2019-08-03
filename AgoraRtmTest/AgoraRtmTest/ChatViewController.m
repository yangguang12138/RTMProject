//
//  ChatViewController.m
//  AgoraRtmTest
//
//  Created by shy on 2019/8/2.
//  Copyright © 2019 shy. All rights reserved.
//

#import "ChatViewController.h"
#import "AppDelegate.h"
#import <AgoraRtmKit/AgoraRtmKit.h>
#import "WHToast.h"
#import "AgoraRtmConfig.h"
#import "MessageCell.h"
#import "Message.h"
#import "Masonry.h"
#import "WUserManager.h"
#import "ViewController.h"
#import "ChannelMembersViewController.h"

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UITextFieldDelegate,AgoraRtmDelegate,AgoraRtmChannelDelegate>

@property(nonatomic,strong)UITableView *mTableView;
@property(nonatomic,strong)UITextField *mInputField;
@property(nonatomic,strong)NSMutableArray *mDataList;
@property(nonatomic,strong)UIView *mInputViewBg;
@property(nonatomic,strong)AgoraRtmChannel *mRtmChannel;

@end

@implementation ChatViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setHidesBottomBarWhenPushed:YES];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(239, 239, 239, 239);
    
    self.title = self.userName;
    
    self.mDataList = [NSMutableArray array];
    
    [self setUpView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    if (self.chatType == ChatType_Single)
    {
        App().kit.agoraRtmDelegate = self;
    }else
    {
        [self createChannel:self.userName];
    }
    
    
}

- (void)setUpView
{
    self.mInputViewBg = [[UIView alloc]init];
    self.mInputViewBg.backgroundColor = RGBACOLOR(248, 248, 248, 248);
    [self.view addSubview:self.mInputViewBg];
    [self.mInputViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    self.mInputField = [[UITextField alloc]init];
    self.mInputViewBg.backgroundColor = [UIColor whiteColor];
    self.mInputField.borderStyle = UITextBorderStyleRoundedRect;
    self.mInputField.placeholder = @"输入账号";
    self.mInputField.returnKeyType = UIReturnKeySend;
    self.mInputField.delegate = self;
    [self.mInputViewBg addSubview:self.mInputField];
    [self.mInputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mInputViewBg).with.mas_offset(15);
        make.right.equalTo(self.mInputViewBg).with.mas_offset(-15);
        make.centerY.equalTo(self.mInputViewBg);
        make.height.mas_equalTo(40);
    }];
    
    self.mTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.mTableView.backgroundColor = RGBACOLOR(239, 239, 239, 239);
    self.mTableView.estimatedRowHeight = 155;
    self.mTableView.rowHeight = UITableViewAutomaticDimension;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.separatorColor = [UIColor clearColor];
    
    if (@available(iOS 11.0, *)) {
        self.mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.mTableView];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mInputViewBg.mas_top);
        make.top.mas_equalTo(80);
        make.left.and.right.equalTo(self.view);
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard:)];
    
    [self.mTableView addGestureRecognizer:tapGesture];
    tapGesture.delegate = self;
    
    if (self.chatType == ChatType_Group)
    {
        UIImage *image = [UIImage imageNamed:@"icon_home_nav_1_selected"];
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(showMemberListView)];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
}

- (void)showMemberListView
{
    __weak ChatViewController *weakSelf = self;
    [self.mRtmChannel getMembersWithCompletion:^(NSArray<AgoraRtmMember *> * _Nullable members, AgoraRtmGetMembersErrorCode errorCode) {
        if (errorCode == AgoraRtmGetMembersErrorOk)
        {
            ChannelMembersViewController *channelMembersVC = [[ChannelMembersViewController alloc]init];
            channelMembersVC.mMemberList = members;
            [weakSelf.navigationController pushViewController:channelMembersVC animated:YES];
        }
    }];
}

- (void)closeKeyboard:(UITapGestureRecognizer *)tap
{
    [self.mInputField resignFirstResponder];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self.mInputViewBg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSValue *endKeyboardFrameValue = (NSValue *)userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect endKeyboardFrame = endKeyboardFrameValue.CGRectValue;

    float offsetY = (self.mInputViewBg.frame.origin.y + self.mInputViewBg.frame.size.height) - endKeyboardFrame.origin.y;
    if (offsetY <=0)
    {
        return;
    }
    [self.mInputViewBg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.mas_offset(-offsetY);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mDataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndenfier = @"cellIndenfier";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier];
    if (cell == nil)
    {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier];
    }
    
    Message *message = [self.mDataList objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:message];
    
    return cell;
}

- (void)sendSingleMessage:(NSString *)text
{
    [self.mInputField resignFirstResponder];
    __weak ChatViewController *weakSelf = self;
    AgoraRtmMessage *message = [[AgoraRtmMessage alloc]initWithText:text];
    [App().kit sendMessage:message toPeer:self.userName completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
        if (errorCode == AgoraRtmSendPeerMessageErrorOk)
        {
            NSString *currentAccount = [[WUserManager shareInstance] CurrentAccount];
            [weakSelf appendMessage:text user:currentAccount];
        }else
        {
            [WHToast showMessage:@"发送失败" duration:ToastShowDuration finishHandler:nil];
        }
    }];
}

- (void)sendGroupMessage:(NSString *)text
{
    [self.mInputField resignFirstResponder];
    __weak ChatViewController *weakSelf = self;
    AgoraRtmMessage *message = [[AgoraRtmMessage alloc]initWithText:text];
    [self.mRtmChannel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
        if (errorCode == AgoraRtmSendPeerMessageErrorOk)
        {
            NSString *currentAccount = [[WUserManager shareInstance] CurrentAccount];
            [weakSelf appendMessage:text user:currentAccount];
        }else
        {
            [WHToast showMessage:@"发送失败" duration:ToastShowDuration finishHandler:nil];
        }
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self leaveChannel];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer.view == self.mTableView)
    {
        [self.mInputField resignFirstResponder];
    }
    return YES;
}

- (void)appendMessage:(NSString *)text user:(NSString *)user
{
    
    Message *msg = [[Message alloc]init];
    msg.userName = user;
    msg.content = text;
    NSString *currentAccount = [WUserManager shareInstance].CurrentAccount;
    BOOL isSelf = [currentAccount isEqualToString:user];
    msg.type =user == nil||user.length<=0?ContentMode_Center:(isSelf?ContentMode_Right:ContentMode_Left);
    [self.mDataList addObject:msg];
    if (self.mDataList.count > MessageHistoryCount)
    {
        [self.mDataList removeObjectAtIndex:0];
    }
    
    NSIndexPath *bottomIndexPath = [NSIndexPath indexPathForRow:self.mDataList.count - 1 inSection:0];
    __weak ChatViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.mTableView reloadData];
        [weakSelf.mTableView scrollToRowAtIndexPath:bottomIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}

- (void)createChannel:(NSString *)channel
{
    self.mRtmChannel = [App().kit createChannelWithId:self.userName delegate:self];
    if (self.mRtmChannel == nil)
    {
        [WHToast showMessage:@"创建频道失败" duration:ToastShowDuration finishHandler:nil];
        return;
    }
    
    [self.mRtmChannel joinWithCompletion:^(AgoraRtmJoinChannelErrorCode errorCode) {
        if (errorCode != AgoraRtmJoinChannelErrorOk)
        {
            [WHToast showMessage:@"创建频道失败" duration:ToastShowDuration finishHandler:nil];
        }
    }];
    
}

- (void)leaveChannel
{
    if (self.chatType == ChatType_Single)
    {
        return;
    }
    
    [self.mRtmChannel leaveWithCompletion:^(AgoraRtmLeaveChannelErrorCode errorCode) {
        
    }];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *text = textField.text;
    if (text == nil || text.length <= 0)
    {
        return YES;
    }
    if (self.chatType == ChatType_Single)
    {
        [self sendSingleMessage:text];
    }else
    {
        [self sendGroupMessage:text];
    }
    
    return YES;
}

#pragma mark AgoraRtmDelegate
- (void)rtmKit:(AgoraRtmKit *)kit connectionStateChanged:(AgoraRtmConnectionState)state reason:(AgoraRtmConnectionChangeReason)reason
{
    NSString *message = [NSString stringWithFormat:@"connection state changed: %ld", state];
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (reason == AgoraRtmConnectionChangeReasonRemoteLogin)
        {
            ViewController *VC = [[ViewController alloc]init];
            UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:VC];
            UIWindow *window = (UIWindow *)[UIApplication sharedApplication].keyWindow;
            window.rootViewController = navigationController;
        }
    }];
    [alertView addAction:action];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)rtmKit:(AgoraRtmKit *)kit messageReceived:(AgoraRtmMessage *)message fromPeer:(NSString *)peerId
{
    [self appendMessage:message.text user:peerId];
}

#pragma mark - AgoraRtmChannelDelegate
- (void)channel:(AgoraRtmChannel *)channel memberJoined:(AgoraRtmMember *)member {
    NSString *user = member.userId;
    NSString *text = [user stringByAppendingString:@" 加入"];
    [self appendMessage:text user:@""];;
}

- (void)channel:(AgoraRtmChannel *)channel memberLeft:(AgoraRtmMember *)member {
    NSString *user = member.userId;
    NSString *text = [user stringByAppendingString:@" 退出"];
    [self appendMessage:text user:@""];
}

- (void)channel:(AgoraRtmChannel *)channel messageReceived:(AgoraRtmMessage *)message fromMember:(AgoraRtmMember *)member {
    [self appendMessage:message.text user:member.userId];
}



@end
