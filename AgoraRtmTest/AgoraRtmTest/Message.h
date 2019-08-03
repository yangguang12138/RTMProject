//
//  Message.h
//  AgoraRtmTest
//
//  Created by shy on 2019/8/2.
//  Copyright © 2019 shy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum{
    ContentMode_Left,
    ContentMode_Center,
    ContentMode_Right,
}ContentMode;

@interface Message : NSObject

@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,assign)ContentMode type;

@end

NS_ASSUME_NONNULL_END
