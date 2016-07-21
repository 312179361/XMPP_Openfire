//
//  ChatTableViewController.h
//  XmppBlog
//
//  Created by TongLi on 16/3/19.
//  Copyright © 2016年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
@interface ChatTableViewController : UITableViewController
//属性传值，要把选中的那个好友JID传到会话列表中
@property (nonatomic,strong)XMPPJID *friendJID;
@end
