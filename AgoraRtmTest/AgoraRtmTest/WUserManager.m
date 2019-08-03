//
//  WUserManager.m
//  AgoraRtmTest
//
//  Created by shy on 2019/8/3.
//  Copyright © 2019 shy. All rights reserved.
//

#import "WUserManager.h"

@interface WUserManager()

@property(nonatomic,strong)NSString *mCurrentAccount;

@end

@implementation WUserManager

+ (instancetype)shareInstance
{
    static WUserManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WUserManager alloc]init];
    });
    
    return instance;
}

- (NSString *)CurrentAccount
{
    return self.mCurrentAccount;
}

- (void)setCurrentAccount:(NSString *)account
{
    self.mCurrentAccount = account;
}

@end
