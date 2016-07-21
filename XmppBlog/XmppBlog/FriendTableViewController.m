//
//  FriendTableViewController.m
//  XmppBlog
//
//  Created by TongLi on 16/3/19.
//  Copyright © 2016年 lanouhn. All rights reserved.
//

#import "FriendTableViewController.h"
#import "XMPPManager.h"
#import "ChatTableViewController.h"
@interface FriendTableViewController ()

@end

@implementation FriendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //刷新列表
    XMPPManager *manager = [XMPPManager shareInstance];
    manager.refresh = ^(){
        [self.tableView reloadData];
    };
    
  
}
- (IBAction)addFriendAction:(UIBarButtonItem *)sender {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"添加好友" preferredStyle:UIAlertControllerStyleAlert];
    //带输入框
    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //添加好友，向服务器发送添加好友的请求
        //获取输入框中的文字
        NSString *textStr = [alertC.textFields lastObject].text;
        
        //调用添加好友方法
        [[XMPPManager shareInstance] addFriendActionWithFriendName:textStr];
    }];
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertAction1];
    [alertC addAction:alertAction2];
    [self presentViewController:alertC animated:YES completion:nil];
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
    return [[XMPPManager shareInstance] friendArr].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendListCell" forIndexPath:indexPath];
    
    XMPPManager *manager = [XMPPManager shareInstance];
    XMPPJID *jid = manager.friendArr[indexPath.row];
    cell.textLabel.text = jid.user;
    // Configure the cell...
    
    return cell;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    XMPPManager *manager = [XMPPManager shareInstance];
    NSMutableArray *tempFriendArr = manager.friendArr;

    //属性传值到聊天页面
    ChatTableViewController *chatTableVC = segue.destinationViewController;
    //1.找到要点击的cell
    UITableViewCell *cell = sender;
    //2.通过cell找到IndexPath
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    //从数组中取出好友的JID
    XMPPJID *JID = [tempFriendArr objectAtIndex:indexPath.row];
    //把JID传到下一个界面
    chatTableVC.friendJID = JID;

}


@end
