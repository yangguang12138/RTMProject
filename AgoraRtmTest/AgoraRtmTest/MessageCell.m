//
//  MessageCell.m
//  AgoraRtmTest
//
//  Created by shy on 2019/8/2.
//  Copyright © 2019 shy. All rights reserved.
//

#import "MessageCell.h"
#import "Masonry.h"
#import "AgoraRtmConfig.h"

@interface MessageCell()

@property(nonatomic,strong)UIView *mLeftHeaderView;
@property(nonatomic,strong)UIView *mLeftContentView;
@property(nonatomic,strong)UILabel *mLeftNameLabel;
@property(nonatomic,strong)UILabel *mLeftContentLabel;
@property(nonatomic,strong)UIView *mRightHeaderView;
@property(nonatomic,strong)UIView *mRightContentView;
@property(nonatomic,strong)UILabel *mRightNameLabel;
@property(nonatomic,strong)UILabel *mRightContentLabel;
@property(nonatomic,strong)UILabel *mSystemContentLabel;

@end

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    self.backgroundColor = RGBACOLOR(239, 239, 239, 239);
    
    self.mSystemContentLabel = [[UILabel alloc]init];
    self.mSystemContentLabel.font = [UIFont boldSystemFontOfSize:12];
    self.mSystemContentLabel.textColor = [UIColor grayColor];
    self.mSystemContentLabel.textAlignment = NSTextAlignmentCenter;
    self.mSystemContentLabel.hidden = YES;
    [self.contentView addSubview:self.mSystemContentLabel];
    [self.mSystemContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(30);
    }];
    
    CGFloat height = 40;
    self.mLeftHeaderView = [[UIView alloc]init];
    self.mLeftHeaderView.layer.cornerRadius = height/2.0f;
    self.mLeftHeaderView.backgroundColor = RGBACOLOR(0, 145, 234,1);
    [self.contentView addSubview:self.mLeftHeaderView];
    [self.mLeftHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(15);
        make.top.equalTo(self).mas_offset(5);
        make.width.mas_equalTo(height);
        make.height.mas_equalTo(height);
    }];
    
    self.mLeftNameLabel = [[UILabel alloc]init];
    self.mLeftNameLabel.font = [UIFont boldSystemFontOfSize:18];
    self.mLeftNameLabel.textAlignment = NSTextAlignmentCenter;
    self.mLeftNameLabel.textColor = [UIColor whiteColor];
    [self.mLeftHeaderView addSubview:self.mLeftNameLabel];
    [self.mLeftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.mLeftHeaderView);
        make.width.mas_equalTo(height -10);
        make.height.mas_equalTo(height - 10);
    }];
    
    
    self.mLeftContentView = [[UIView alloc]init];
    self.mLeftContentView.backgroundColor = [UIColor clearColor];
    self.mLeftContentView.layer.cornerRadius = 5;
    [self.contentView addSubview:self.mLeftContentView];
    [self.mLeftContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mLeftHeaderView.mas_right).with.mas_offset(5);
        make.top.mas_equalTo(self.contentView).with.mas_offset(5);
        make.height.mas_greaterThanOrEqualTo(40);
    }];
    
    UIImage *leftImage = [[UIImage imageNamed:@"chat_in"] resizableImageWithCapInsets: UIEdgeInsetsMake(28, 18, 8, 8) resizingMode: UIImageResizingModeStretch];
    UIImageView *leftBubbleIV = [[UIImageView alloc]initWithImage:leftImage];
    [self.mLeftContentView addSubview:leftBubbleIV];
    [leftBubbleIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.mLeftContentView);
        make.top.and.bottom.equalTo(self.mLeftContentView);
    }];
    
    self.mLeftContentLabel = [[UILabel alloc]init];
    self.mLeftContentLabel.font = [UIFont systemFontOfSize:15];
    self.mLeftContentLabel.numberOfLines = 0;
    self.mLeftContentLabel.text = @"";
    self.mLeftContentLabel.textAlignment = NSTextAlignmentLeft;
    self.mLeftContentLabel.textColor = [UIColor blackColor];
    [self.mLeftContentView addSubview:self.mLeftContentLabel];
    [self.mLeftContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mLeftContentView).mas_offset(15);
        make.top.equalTo(self.mLeftContentView).mas_offset(5);
        make.width.mas_lessThanOrEqualTo(CGRectGetWidth(self.frame) - 80);
        make.bottom.equalTo(self.mLeftContentView).mas_equalTo(-5);
    }];
    
    [self.mLeftContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mLeftContentLabel.mas_right).mas_offset(5);
        make.bottom.mas_equalTo(self.mLeftContentLabel.mas_bottom).mas_offset(5);
    }];
    
    
    self.mRightHeaderView = [[UIView alloc]init];
    self.mRightHeaderView.layer.cornerRadius = height/2.0f;
    self.mRightHeaderView.backgroundColor = RGBACOLOR(0, 145, 234,1);
    [self.contentView addSubview:self.mRightHeaderView];
    [self.mRightHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-15);
        make.top.equalTo(self).mas_offset(5);
        make.width.mas_equalTo(height);
        make.height.mas_equalTo(height);
    }];
    
    self.mRightNameLabel = [[UILabel alloc]init];
    self.mRightNameLabel.font = [UIFont boldSystemFontOfSize:20];
    self.mRightNameLabel.textAlignment = NSTextAlignmentCenter;
    self.mRightNameLabel.textColor = [UIColor whiteColor];
    [self.mRightHeaderView addSubview:self.mRightNameLabel];
    [self.mRightNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.mRightHeaderView);
        make.width.mas_equalTo(height -10);
        make.height.mas_equalTo(height - 10);
    }];
    
    self.mRightContentView = [[UIView alloc]init];
    self.mRightContentView.backgroundColor = [UIColor clearColor];
    self.mRightContentView.layer.cornerRadius = 5;
    [self.contentView addSubview:self.mRightContentView];
    [self.mRightContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mRightHeaderView.mas_left).mas_offset(-5);
        make.top.mas_equalTo(self.contentView).with.mas_offset(5);
        make.height.mas_greaterThanOrEqualTo(40);
    }];
    
    UIImage *rightImage = [[UIImage imageNamed:@"chat_out"] resizableImageWithCapInsets: UIEdgeInsetsMake(28, 8, 8, 18) resizingMode: UIImageResizingModeStretch];
    UIImageView *rightBubbleIV = [[UIImageView alloc]initWithImage:rightImage];
    [self.mRightContentView addSubview:rightBubbleIV];
    [rightBubbleIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.mRightContentView);
        make.top.and.bottom.equalTo(self.mRightContentView);
    }];
    
    self.mRightContentLabel = [[UILabel alloc]init];
    self.mRightContentLabel.font = [UIFont systemFontOfSize:15];
    self.mRightContentLabel.numberOfLines = 0;
    self.mRightContentLabel.textAlignment = NSTextAlignmentRight;
    self.mRightContentLabel.textColor = [UIColor whiteColor];
    [self.mRightContentView addSubview:self.mRightContentLabel];
    [self.mRightContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mRightContentView.mas_right).mas_offset(-15);
        make.top.equalTo(self.mRightContentView).mas_offset(5);
        make.width.mas_lessThanOrEqualTo(CGRectGetWidth(self.frame) - 80);
        make.bottom.equalTo(self.mRightContentView).mas_equalTo(-5);
    }];

    [self.mRightContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mRightContentLabel.mas_left).with.mas_offset(-5);
        make.bottom.mas_equalTo(self.mRightContentLabel.mas_bottom).mas_offset(5);
    }];
    
}

- (void)setCellDataWithModel:(Message *)message
{
    NSString *userName = @"";
    if (message.type == ContentMode_Center)
    {
        self.mLeftHeaderView.hidden = YES;
        self.mLeftContentView.hidden = YES;
        
        self.mRightHeaderView.hidden = YES;
        self.mRightContentView.hidden = YES;
        self.mSystemContentLabel.hidden = NO;
    }else
    {
        self.mLeftHeaderView.hidden = message.type != ContentMode_Left;
        self.mLeftContentView.hidden = message.type != ContentMode_Left;
        
        self.mRightHeaderView.hidden = message.type != ContentMode_Right;
        self.mRightContentView.hidden = message.type != ContentMode_Right;
        self.mSystemContentLabel.hidden = YES;
        userName = [message.userName substringToIndex:1];
    }
    
    if (message.type == ContentMode_Left)
    {
        self.mLeftNameLabel.text = userName;
        self.mLeftContentLabel.text = message.content;
            [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.mLeftContentView.mas_bottom).with.mas_offset(5);
                make.top.mas_equalTo(self.mLeftHeaderView.mas_top).with.mas_offset(-5);
            }];
    }else if(message.type == ContentMode_Right)
    {
        self.mRightNameLabel.text = userName;
        self.mRightContentLabel.text = message.content;
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mRightContentView.mas_bottom).with.mas_offset(5);
            make.top.mas_equalTo(self.mRightHeaderView.mas_top).with.mas_offset(-5);
        }];
    }else
    {
        self.mSystemContentLabel.text = message.content;
    }
}

@end
