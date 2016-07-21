//
//  MessageModel.h
//  XmppBlog
//
//  Created by TongLi on 16/3/19.
//  Copyright © 2016年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

@interface MessageModel : NSObject
//  声明JID属性的目的就是：用来确认消息发送者的JID
@property (nonatomic, strong)XMPPJID *from;
//  展示消息
@property (nonatomic, copy)NSString *body;
@end
