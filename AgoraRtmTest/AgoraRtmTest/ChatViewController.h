//
//  ChatViewController.h
//  AgoraRtmTest
//
//  Created by shy on 2019/8/2.
//  Copyright © 2019 shy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum{
    ChatType_Single,
    ChatType_Group,
}ChatType;

@interface ChatViewController : UIViewController

@property(nonatomic,strong)NSString *userName;
@property(nonatomic,assign)ChatType chatType;

@end

NS_ASSUME_NONNULL_END
