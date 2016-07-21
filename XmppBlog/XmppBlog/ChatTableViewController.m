//
//  ChatTableViewController.m
//  XmppBlog
//
//  Created by TongLi on 16/3/19.
//  Copyright © 2016年 lanouhn. All rights reserved.
//

#import "ChatTableViewController.h"
#import "XMPPManager.h"
#import "MessageModel.h"
#import "MyChatTableViewCell.h"
#import "FriendChatTableViewCell.h"
@interface ChatTableViewController ()<XMPPStreamDelegate>
@property (nonatomic,strong)NSMutableArray *messageArr;

@end

@implementation ChatTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messageArr = [NSMutableArray array];
    //给通信通道添加代理方法
    [[[XMPPManager shareInstance] xmppStream] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self reloadMessages];
   
}
//发起会话
- (IBAction)sendMessageAction:(UIBarButtonItem *)sender {
    //创建消息;参数1：chat就是代表聊天消息，参数2：要发送的对象
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.friendJID];
    //  2.添加消息体
    [message addBody:@"蓝鸥3g学院"];
    //  3.发送消息
    [[[XMPPManager shareInstance] xmppStream] sendElement:message];

}



//检索信息
- (void)reloadMessages{
    //通过coredata把信息取出来
    NSManagedObjectContext *context = [[XMPPManager shareInstance] context ];
    //创建请求
    //底层XMPPMessageArchiving_Message_CoreDataObject表中存放所有的聊天记录
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    //通过 谓词 去筛选
    //bareJIDStr代表的是好友的账号
    //streamBareJidStr代表的是我的账号
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr == %@ and streamBareJidStr == %@",self.friendJID.bare,[[XMPPManager shareInstance] xmppStream].myJID.bare];
    //排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    //设置排序
    [request setSortDescriptors:@[sort]];
    //设置谓词
    [request setPredicate:predicate];
    //用coredata得到了聊天记录
    NSArray *fetchArr = [context executeFetchRequest:request error:nil];
    //将聊天记录封装成MessageModel
    for (XMPPMessageArchiving_Message_CoreDataObject *message in fetchArr) {
        MessageModel *showMessage = [[MessageModel alloc] init];
        //  如果消息是发送出去的，就把showMessage的from赋值为streamBarJID
        if (message.isOutgoing) {
            showMessage.from = [XMPPJID jidWithString:message.streamBareJidStr];
        }else{
            //  封装
            XMPPJID *jid = [XMPPJID jidWithString:message.bareJidStr];
            showMessage.from = jid;
        }
        //  接收本地消息的内容
        showMessage.body = message.body;
        //  添加到数据源中
        [self.messageArr addObject:showMessage];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.messageArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //  从数据源中提取，展示的数据
    MessageModel *message = self.messageArr[indexPath.row];
    XMPPJID *sendJID = message.from;
    if ([[sendJID bareJID] isEqualToJID:[self.friendJID bareJID]]) {
        //  消息来源于当前聊天好友
        FriendChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendMessage" forIndexPath:indexPath];
        //  展示消息的内容
        cell.messageLabel.text = message.body;
        return cell;
    }else{
        MyChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myMessage" forIndexPath:indexPath];
        
        cell.messageLabel.text = message.body;
        return cell;
    }
}

#pragma mark - 发送了消息的代理方法 -
//发送了信息
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
    NSLog(@"发送了信息");
    [self showMessage:message];
}

#pragma mark - 接受了消息的代理方法 -
//接收了信息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    NSLog(@"接受了信息");
    XMPPJID *jid = message.from;
    NSLog(@"%@",jid.bareJID);
    //如果这个信息是这个好友发送的，那么就显示在tableview中
    if ([[self.friendJID bareJID] isEqualToJID:[jid bareJID]]) {
        //  插入数据进行显示
        [self showMessage:message];
    }
}

//  封装向数据源中插入数据，进行显示的方法
- (void)showMessage:(XMPPMessage *)message {
    //  将XMPPMessage转化为我们自己建立的MessageModel，目的就是防止，本地消息类型和收到的远程消息类型不一样
    MessageModel *showMessage = [[MessageModel alloc] init];
    showMessage.body = message.body;
    showMessage.from = message.from;
    //  1.插入数据源
    [self.messageArr addObject:showMessage];
    //  2.插入单元格
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageArr.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    //  自动滚动
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
