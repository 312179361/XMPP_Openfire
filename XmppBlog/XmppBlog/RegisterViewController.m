//
//  RegisterViewController.m
//  XmppBlog
//
//  Created by TongLi on 16/3/20.
//  Copyright © 2016年 lanouhn. All rights reserved.
//

#import "RegisterViewController.h"
#import "XMPPManager.h"
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *registerIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)enterRegisterAction:(UIButton *)sender {
    
    if (![self.registerIDTextField.text isEqualToString:@""] && ![self.passwordTextField.text isEqualToString:@""]) {
        
        [[XMPPManager shareInstance] registerWithUserID:self.registerIDTextField.text withPassword:self.passwordTextField.text withRegisterResult:^(NSString *RegisterResult) {
            if ([RegisterResult isEqualToString:@"registerSuccess"]) {
                //返回登录界面
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                NSLog(@"注册失败");
            }
        }];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
