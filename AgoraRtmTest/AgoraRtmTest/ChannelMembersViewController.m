//
//  ChannelMembersViewController.m
//  AgoraRtmTest
//
//  Created by shy on 2019/8/3.
//  Copyright © 2019 shy. All rights reserved.
//

#import "ChannelMembersViewController.h"
#import <AgoraRtmKit/AgoraRtmKit.h>

@interface ChannelMembersViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *mTableView;

@end

@implementation ChannelMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"用户列表";
    [self setupView];
}

- (void)setupView
{
    self.mTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.tableHeaderView = [[UIView alloc]init];
    self.mTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.mTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mMemberList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    AgoraRtmMember *member = [self.mMemberList objectAtIndex:indexPath.row];
    cell.textLabel.text = member.userId;
    return cell;
}

@end
