//
//  MessageCell.h
//  AgoraRtmTest
//
//  Created by shy on 2019/8/2.
//  Copyright © 2019 shy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

NS_ASSUME_NONNULL_BEGIN


@interface MessageCell : UITableViewCell

- (void)setCellDataWithModel:(Message *)message;

@end

NS_ASSUME_NONNULL_END
