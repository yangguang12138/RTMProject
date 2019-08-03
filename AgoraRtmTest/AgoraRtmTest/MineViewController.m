//
//  MineViewController.m
//  AgoraRtmTest
//
//  Created by shy on 2019/8/3.
//  Copyright © 2019 shy. All rights reserved.
//

#import "MineViewController.h"
#import "Masonry.h"
#import "WUserManager.h"
#import "AgoraRtmConfig.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "WHToast.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *mTableView;
@property(nonatomic,strong)UIButton *mLogoutBtn;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的";
    
    self.mLogoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mLogoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    self.mLogoutBtn.backgroundColor = RGBACOLOR(0, 145, 234, 1);
    self.mLogoutBtn.layer.cornerRadius = 5;
    [self.mLogoutBtn addTarget:self action:@selector(handleLogoutBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mLogoutBtn];
    [self.mLogoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.mas_offset(15);
        make.right.equalTo(self.view).with.mas_offset(-15);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.view).mas_equalTo(-100);
    }];
    
    self.mTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.scrollEnabled = NO;
    self.mTableView.tableHeaderView = [[UIView alloc]init];
    self.mTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.mTableView];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.mas_offset(100);
        make.bottom.equalTo(self.mLogoutBtn.mas_top).with.mas_offset(-50);
        make.left.and.right.equalTo(self.view);
    }];

}

- (void)handleLogoutBtn:(UIButton *)sender
{
    [self handleLogout];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"用户名";
        NSString *userName = [WUserManager shareInstance].CurrentAccount;
        cell.detailTextLabel.text = userName;
    }else if(indexPath.row == 1)
    {
        cell.textLabel.text = @"版本";
        NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey: @"CFBundleShortVersionString"];
        cell.detailTextLabel.text = version;
    }
    
    return cell;
}

- (void)handleLogout
{
    [App().kit logoutWithCompletion:^(AgoraRtmLogoutErrorCode errorCode) {
        if (errorCode == AgoraRtmLogoutErrorOk)
        {
            ViewController *VC = [[ViewController alloc]init];
            UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:VC];
            UIWindow *window = (UIWindow *)[UIApplication sharedApplication].keyWindow;
            window.rootViewController = navigationController;
        }else
        {
            [WHToast showMessage:@"退出失败" duration:ToastShowDuration finishHandler:nil];
        }
    }];
}


@end
