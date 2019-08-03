//
//  MainTabBarController.m
//  AgoraRtmTest
//
//  Created by shy on 2019/8/3.
//  Copyright © 2019 shy. All rights reserved.
//

#import "MainTabBarController.h"
#import "ChatPeerViewController.h"
#import "MineViewController.h"
#import "ChannelViewController.h"

@implementation MainTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTabBar];
}

- (void)setupTabBar
{
    NSArray *titleArray = @[@"聊天",@"频道",@"我的"];
    NSMutableArray *controllers = [NSMutableArray array];
    for(NSInteger i = 0;i < titleArray.count;i++)
    {
        UIViewController *controller = nil;
        if (i == 0)
        {
            UIViewController *chatPeerVC = [[ChatPeerViewController alloc]init];
            controller = [[UINavigationController alloc]initWithRootViewController:chatPeerVC];
            
            
        }else if(i == 2)
        {
            UIViewController *mineVC = [[MineViewController alloc]init];
            controller = [[UINavigationController alloc]initWithRootViewController:mineVC];
        }else
        {
            UIViewController *channelVC = [[ChannelViewController alloc]init];
            controller = [[UINavigationController alloc]initWithRootViewController:channelVC];
        }
        controller.title = titleArray[i];
        [controllers addObject:controller];
    }
    
    self.viewControllers = controllers;
    self.selectedIndex = 0;
    
    NSArray *tabBars = self.tabBar.items;
    for (int i = 0;i <tabBars.count;i++)
    {
        UITabBarItem *item = tabBars[i];
        NSString *imageName = [NSString stringWithFormat: @"icon_home_nav_%d_normal", i];
        NSString *hlImageName = [NSString stringWithFormat: @"icon_home_nav_%d_selected",i];
        UIImage *normalImage = [UIImage imageNamed:imageName];
        UIImage *selectedImage = [UIImage imageNamed:hlImageName];
        normalImage = [normalImage imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        selectedImage = [selectedImage imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        [item setImage:normalImage];
        [item setSelectedImage:selectedImage];
    }
}

@end
