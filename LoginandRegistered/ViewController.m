//
//  ViewController.m
//  LoginandRegistered
//
//  Created by 于潘洋 on 2020/3/23.
//  Copyright © 2020 爱吃肉肉的李小胖. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *aView = [[UIView alloc] init];
    aView.frame = CGRectMake(10, 10, kScreen_WIDTH, 10);
    [self.view addSubview:aView];
    
    // 确认注册
    UIButton *registeredBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self buttonName:registeredBtn thebottomView:self.view TheaboveControls:aView setTitle:@"登录"];
    [registeredBtn addTarget:self action:@selector(registeredBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)registeredBtnClick:(UIButton*)sender
{
    [self presentViewController:[[LoginViewController alloc] init] animated:YES completion:nil];
}
/**按钮*/
-(void)buttonName:(UIButton*)bt thebottomView:(UIView*)view TheaboveControls:(UIView*)controls setTitle:(NSString*)string
{
    [view addSubview:bt];
    [bt mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(controls.mas_bottom).with.offset(35);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(263, 54));
    }];
    [bt setBackgroundImage:ImageNamed(@"pink") forState:UIControlStateNormal];
    [bt setBackgroundImage:ImageNamed(@"pink") forState:UIControlStateHighlighted];
    [bt setTitle:string forState:(UIControlStateNormal)];
}

@end
