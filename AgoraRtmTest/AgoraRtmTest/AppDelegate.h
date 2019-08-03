//
//  AppDelegate.h
//  AgoraRtmTest
//
//  Created by shy on 2019/8/2.
//  Copyright © 2019 shy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgoraRtmConfig.h"
#import <AgoraRtmKit/AgoraRtmKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)AgoraRtmKit *kit;

AppDelegate *App();

- (void)loginOut;
@end

