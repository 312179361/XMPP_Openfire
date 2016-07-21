//
//  ViewController.m
//  XmppBlog
//
//  Created by TongLi on 16/3/19.
//  Copyright © 2016年 lanouhn. All rights reserved.
//

#import "ViewController.h"
#import "RegisterViewController.h"
#import "XMPPManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *myNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
//登录
- (IBAction)loginAvtion:(UIButton *)sender {
    
    if (![self.myNameTextField.text isEqualToString:@""] && ![self.passwordTextField.text isEqualToString:@""]) {
        XMPPManager *manager = [XMPPManager shareInstance];
        [manager loginWithUserID:self.myNameTextField.text withPassword:self.passwordTextField.text withLoginResult:^(NSString *loginResult) {
            
            if ([loginResult isEqualToString:@"loginSuccess"]) {
                //登录成功
                [self performSegueWithIdentifier:@"toFriendVC" sender:sender];
                

            }
        }];

    }
    
    
    
}
//注册
//- (IBAction)registerAction:(UIButton *)sender {
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
}

@end
