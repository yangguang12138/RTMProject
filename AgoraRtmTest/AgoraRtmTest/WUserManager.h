//
//  WUserManager.h
//  AgoraRtmTest
//
//  Created by shy on 2019/8/3.
//  Copyright © 2019 shy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WUserManager : NSObject

+ (instancetype)shareInstance;

- (NSString *)CurrentAccount;

- (void)setCurrentAccount:(NSString *)account;

@end

NS_ASSUME_NONNULL_END
