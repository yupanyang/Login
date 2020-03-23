


#import "LoginViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LoginViewController ()
{
    UIButton *exitBT;//退出按钮
    NSArray *platformsarray;

}

//登录界面
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic, strong) UITextField *usrName;
@property (nonatomic, strong) UITextField *usrPwd;

//
@property (nonatomic,strong) UIView *loginView;//登录View
@property (nonatomic,strong) UIView *registeredView;//注册View
@property (nonatomic,strong) UILabel *promptLabel;//忘记密码View

//注册界面
@property (nonatomic,strong) UITextField *account;//用户
@property (nonatomic,strong) UITextField *passwordView;//密码
@property (nonatomic,strong) UITextField *passwordagain;//再次输入密码
@property (nonatomic,strong) UITextField *Mobilephone;//手机号

//忘记密码
@property (nonatomic,strong) UIView *forgetView;//忘记密码背景View
@property (nonatomic,strong) UITextField *forgetUser;//用户输入框


//第三方登录
@property (nonatomic,strong) UIView *ThirdpartyloginView;
@end

@implementation LoginViewController
//隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
} 
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //视频蒙版
    [self Videomask];
    
    //登录View
    [self LoginView];
    
    //注册页面
    [self RegisteredView];
    
    //忘记密码页面
    [self Forgotpassword];
    
    //第三方登录View
    [self Thirdpartylogin];
    
}
- (void)runLoopTheMovie:(NSNotification *)notification {
    AVPlayerItem *playerItem = notification.object;
    [playerItem seekToTime:kCMTimeZero];
    [_player play];
}
-(void)Videomask
{
    // 视频
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"mp4"]];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
    _player = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    playerLayer.frame = self.view.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:playerLayer];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(runLoopTheMovie:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    
    // 蒙板
    UIImageView *maskImgView = [[UIImageView alloc] init];
    [self.view addSubview:maskImgView];
    [maskImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    maskImgView.image = ImageNamed(@"black");
    
    //返回按钮
    exitBT = [UIButton buttonWithType:(UIButtonTypeSystem)];
    exitBT.frame = CGRectMake(kScreen_WIDTH/8-30, kScreen_HEIGHT/10, 30, 30);
    [exitBT setImage:[UIImage imageNamed:@"tuichu.png"] forState:(UIControlStateNormal)];
    [exitBT addTarget:self action:@selector(exitbt) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:exitBT];
    
    // 提示文字
    self.promptLabel = [[UILabel alloc] init];
    [self.view addSubview:self.promptLabel];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(SYS_NavigationBar_HEIGHT+5.5);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 36.5));
    }];
    self.promptLabel.font = AppFont(40);
    self.promptLabel.textColor = AppHTMLColor(@"ffffff");
    self.promptLabel.textAlignment = NSTextAlignmentCenter;
    self.promptLabel.text = @"登录";
    
    // 点击空白处收键盘
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
}
// 点击空白处收键盘
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}
#pragma mark - 初始化登录view
- (void)LoginView {
    //登录View
    self.loginView = [[UIView alloc] init];
    self.loginView.userInteractionEnabled = YES;
    [self.view addSubview:self.loginView];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptLabel.mas_bottom).with.offset(91);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(263, 260));
    }];
    
    
    // 请输入用户名
    self.usrName = [[UITextField alloc] init];
    UIView *userView = [[UIImageView alloc] init];
    [self.loginView addSubview:userView];
    [userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptLabel.mas_bottom).with.offset(91);
        make.centerX.equalTo(self.loginView);
        make.size.mas_equalTo(CGSizeMake(263, 54));
    }];
    userView.userInteractionEnabled = YES;
    [self InputboxView:userView leftimage:@"user" TextField:self.usrName placeholder:@"请输入用户名"];
    
    // 请输入密码
    self.usrPwd = [[UITextField alloc] init];
    UIView *passwordView = [[UIImageView alloc] init];
    [self.loginView addSubview:passwordView];
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userView.mas_bottom).with.offset(15);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(263, 54));
    }];
    passwordView.userInteractionEnabled = YES;
    self.usrPwd.secureTextEntry = YES;
    [self InputboxView:passwordView leftimage:@"password" TextField:self.usrPwd placeholder:@"请输入密码"];
    [_player play];

    // 确认
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self buttonName:loginBtn thebottomView:self.loginView TheaboveControls:passwordView setTitle:@"确定登录"];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 注册账号
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self leftButtonName:registerBtn thebottomView:self.loginView TheaboveControls:loginBtn setTitle:@"注册账号"];
    [registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 忘记密码？
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self rightButtonName:resetBtn thebottomView:self.loginView TheaboveControls:loginBtn setTitle:@"忘记密码?"];
    [resetBtn addTarget:self action:@selector(resetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 初始化注册View
-(void)RegisteredView
{
    //注册View
    self.registeredView = [[UIView alloc] init];
    self.registeredView.alpha = 0;
    self.registeredView.userInteractionEnabled = YES;
    [self.view addSubview:self.registeredView];
    [self.registeredView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptLabel.mas_bottom).with.offset(91);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(263, 400));
    }];

    // 请输入用户名
    self.account = [[UITextField alloc] init];
    UIView *userView = [[UIImageView alloc] init];
    [self.registeredView addSubview:userView];
    [userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptLabel.mas_bottom).with.offset(91);
        make.centerX.equalTo(self.registeredView);
        make.size.mas_equalTo(CGSizeMake(263, 54));
    }];
    userView.userInteractionEnabled = YES;
    [self InputboxView:userView leftimage:@"user" TextField:self.account placeholder:@"请输入4-20位账号"];
    
    // 请输入密码
    self.passwordView = [[UITextField alloc] init];
    UIView *passwordView = [[UIImageView alloc] init];
    [self.registeredView addSubview:passwordView];
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userView.mas_bottom).with.offset(15);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(263, 54));
    }];
    passwordView.userInteractionEnabled = YES;
    self.passwordView.secureTextEntry = YES;
    [self InputboxView:passwordView leftimage:@"password" TextField:self.passwordView placeholder:@"请输入4-20位密码"];
    
    //再次输入密码
    self.passwordagain = [[UITextField alloc] init];
    UIView *passwordagain = [[UIImageView alloc] init];
    [self.registeredView addSubview:passwordagain];
    [passwordagain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.mas_bottom).with.offset(15);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(263, 54));
    }];
    passwordagain.userInteractionEnabled = YES;
    self.passwordagain.secureTextEntry = YES;
    [self InputboxView:passwordagain leftimage:@"password" TextField:self.passwordagain placeholder:@"再次输入密码"];
    
    //手机号
    self.Mobilephone = [[UITextField alloc] init];
    UIView *Mobilephone = [[UIImageView alloc] init];
    [self.registeredView addSubview:Mobilephone];
    [Mobilephone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordagain.mas_bottom).with.offset(15);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(263, 54));
    }];
    Mobilephone.userInteractionEnabled = YES;
    [self InputboxView:Mobilephone leftimage:@"youxiang" TextField:self.Mobilephone placeholder:@"请输入邮箱"];
    
    // 确认注册
    UIButton *registeredBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self buttonName:registeredBtn thebottomView:self.registeredView TheaboveControls:Mobilephone setTitle:@"确定注册"];
    [registeredBtn addTarget:self action:@selector(registeredBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 登录账号
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self leftButtonName:loginBtn thebottomView:self.registeredView TheaboveControls:registeredBtn setTitle:@"立即登录"];
    [loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 初始化忘记密码界面
-(void)Forgotpassword
{
    self.forgetView = [[UIView alloc] init];
    self.forgetView.alpha = 0;
    self.forgetView.userInteractionEnabled = YES;
    [self.view addSubview:self.forgetView];
    [self.forgetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptLabel.mas_bottom).with.offset(91);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(263, 400));
    }];
    
    self.forgetUser = [[UITextField alloc] init];
    UIView *forgetUserView = [[UIImageView alloc] init];
    [self.forgetView addSubview:forgetUserView];
    [forgetUserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptLabel.mas_bottom).with.offset(91);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(263, 54));
    }];
    forgetUserView.userInteractionEnabled = YES;
    [self InputboxView:forgetUserView leftimage:@"youxiang" TextField:self.forgetUser placeholder:@"请输入邮箱"];
    
    // 确认修改
    UIButton *registeredBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self buttonName:registeredBtn thebottomView:self.forgetView TheaboveControls:forgetUserView setTitle:@"确定修改"];
    [registeredBtn addTarget:self action:@selector(forgetUserBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 登录账号
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self leftButtonName:loginBtn thebottomView:self.forgetView TheaboveControls:registeredBtn setTitle:@"立即登录"];
    [loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
//第三方登录View
-(void)Thirdpartylogin
{
    self.ThirdpartyloginView = [[UIView alloc] init];
    [self.view addSubview:self.ThirdpartyloginView];
    self.ThirdpartyloginView.userInteractionEnabled = YES;
    [self.ThirdpartyloginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginView.mas_bottom).with.offset(50);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(263, 200));
    }];
    
    // 提示文字
    UILabel *thirdparty = [[UILabel alloc] init];
    [self.ThirdpartyloginView addSubview:thirdparty];
    [thirdparty mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ThirdpartyloginView.mas_top).with.offset(20);
        make.centerX.equalTo(self.ThirdpartyloginView);
        make.size.mas_equalTo(CGSizeMake(263, 5));
    }];
    thirdparty.font = AppFont(15);
    thirdparty.textColor = AppHTMLColor(@"ffffff");
    thirdparty.textAlignment = NSTextAlignmentCenter;
    thirdparty.text = @"—————— 第三方登录 ——————";
    platformsarray = @[@"微信",@"QQ",@"Facebook",@"Twitter"];
    CGFloat w = 50;
    CGFloat x;
    CGFloat centerX = kScreen_WIDTH/4+25;
    if (platformsarray.count % 2 == 0) {
        x =  centerX - platformsarray.count/2*w - (platformsarray.count - 1)*5;
    }
    else
    {
        x =  centerX - (platformsarray.count - 1)/2*w - w/2 - (platformsarray.count - 1)*5;
    }
    for (int i=0; i<platformsarray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.tag = 1 + i;
        [btn setImage:[UIImage imageNamed:platformsarray[i]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(thirdlogin:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(x,50,w,w);
        x+=w+10;
        [self.ThirdpartyloginView addSubview:btn];
    }
}
-(void)thirdlogin:(UIButton *)sender{

    NSInteger tag = sender.tag;

    switch (tag)
    {
        case 1:
            [self setupClickTitle:@"微信登录" Message:@"是否跳转页面"];
            break;
        case 2:
            [self setupClickTitle:@"QQ登录" Message:@"是否跳转页面"];
            break;
        case 3:
            [self setupClickTitle:@"Facebook登录" Message:@"是否跳转页面"];
            break;
        case 4:
            [self setupClickTitle:@"Twitter登录" Message:@"是否跳转页面"];
            break;
        default:
            break;
    }
}
#pragma mark - 登录按钮界面事件
//登录
- (void)loginBtnClick:(UIButton *)sender {
    NSLog(@"=====登录=====");
    NSLog(@"%@",self.usrName.text);
    
}
//注册
- (void)registerBtnClick:(UIButton *)sender {
    NSLog(@"=====注册=====");
    [UIView animateWithDuration:0.5 animations:^{
        self.loginView.alpha = 0;
        self.ThirdpartyloginView.alpha = 0;
        self.registeredView.alpha = 1;
        self.promptLabel.text = @"注册";
    }];
}

//忘记密码
- (void)resetBtnClick:(UIButton *)sender {
    NSLog(@"=====忘记密码=====");
    [UIView animateWithDuration:0.5 animations:^{
        self.loginView.alpha = 0;
        self.ThirdpartyloginView.alpha = 0;
        self.registeredView.alpha = 0;
        self.forgetView.alpha = 1;
        self.promptLabel.text = @"修改密码";
    }];
}

#pragma mark - 注册按钮界面事件
//确定
-(void)registeredBtnClick:(UIButton*)sender
{
    
    NSString *userNameRegex = @"^[A-Za-z0-9]{4,20}+$";//用户名
    NSPredicate *accountpredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL account = [accountpredicate evaluateWithObject:self.account.text];
    
    
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";//密码
    NSPredicate *passwordpredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    BOOL password = [passwordpredicate evaluateWithObject:self.passwordView.text];
    
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL result = [predicate evaluateWithObject:self.Mobilephone.text];
    //判断账号为空
    if ([self.account.text isEqualToString:@""]){[self setupClickDontreturnTitle:@"提示" Message:@"账号不能为空"];}
    else
    {
        if (account == NO){[self setupClickDontreturnTitle:@"提示" Message:@"请输入4-20位账号"];}
        //判断密码为空
        if ([self.passwordView.text isEqualToString:@""])
        {
            [self setupClickDontreturnTitle:@"提示" Message:@"密码不能为空"];
        }
        else
        {
            if (password == NO){[self setupClickDontreturnTitle:@"提示" Message:@"请输入4-20位密码"];}
            
            //确认密码
            if ([self.passwordagain.text isEqualToString:@""])
            {
                [self setupClickDontreturnTitle:@"提示" Message:@"确认密码不能为空"];
            }
            else
            {
                if (password == NO){[self setupClickDontreturnTitle:@"提示" Message:@"请输入4-20位密码"];}
                //邮箱确认
                if ([self.Mobilephone.text isEqualToString:@""])
                {
                    [self setupClickDontreturnTitle:@"提示" Message:@"邮箱不能为空"];
                }
                else
                {
                    if (result == NO){[self setupClickDontreturnTitle:@"提示" Message:@"邮箱格式不正确"];}
                    
                    if ([self.passwordView.text isEqualToString: self.passwordagain.text])
                    {
                        //注册成功
                        NSLog(@"注册成功");
                    }else{[self setupClickDontreturnTitle:@"提示" Message:@"两次密码不一致"];}
                }
            }
        }
    }
}
//登录
-(void)loginClick:(UIButton*)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        self.promptLabel.text = @"登录";
        self.registeredView.alpha = 0;
        self.forgetView.alpha = 0;
        self.ThirdpartyloginView.alpha = 1;
        self.loginView.alpha = 1;
    }];
}
//修改密码
- (void)forgetUserBtnClick:(UIButton *)sender
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL result = [predicate evaluateWithObject:self.forgetUser.text];
    if ([self.forgetUser.text isEqualToString:@""])
    {
        [self setupClickDontreturnTitle:@"提示" Message:@"邮箱不能为空"];
    }
    else
    {
        if (result == YES)
        {
            NSLog(@"邮箱正确");
            [self setupClickTitle:@"提示" Message:@"修改密码链接已发送至邮箱"];
        }
        else
        {
            NSLog(@"邮箱错误");
            [self setupClickDontreturnTitle:@"提示" Message:@"邮箱格式错误"];
        }
    }
    
    
}
-(void)exitbt
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - 方法
/**左边小按钮*/
-(void)leftButtonName:(UIButton*)bt thebottomView:(UIView*)view TheaboveControls:(UIView*)controls setTitle:(NSString*)string
{
    [view addSubview:bt];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(controls.mas_left).with.offset(0);
        make.top.equalTo(controls.mas_bottom).with.offset(30.5);
        make.size.mas_equalTo(CGSizeMake(55, 12.5));
    }];
    [bt setTitle:string forState:UIControlStateNormal];
    NSMutableAttributedString *attrs1 = [[NSMutableAttributedString alloc] initWithString:bt.currentTitle];
    [attrs1 addAttribute:NSFontAttributeName value:AppFont(13) range:[bt.currentTitle rangeOfString:bt.currentTitle]];
    [attrs1 addAttribute:NSForegroundColorAttributeName value:AppHTMLColor(@"f5f5f5") range:[bt.currentTitle rangeOfString:bt.currentTitle]];
    [bt setAttributedTitle:attrs1 forState:UIControlStateNormal];
}
/**右边小按钮*/
-(void)rightButtonName:(UIButton*)bt thebottomView:(UIView*)view TheaboveControls:(UIView*)controls setTitle:(NSString*)string
{
    [view addSubview:bt];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(controls.mas_bottom).with.offset(30.5);
        make.right.equalTo(controls.mas_right).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(70, 12.5));
    }];
    [bt setTitle:string forState:UIControlStateNormal];
    NSMutableAttributedString *attrs2 = [[NSMutableAttributedString alloc] initWithString:bt.currentTitle];
    [attrs2 addAttribute:NSFontAttributeName value:AppFont(13) range:[bt.currentTitle rangeOfString:bt.currentTitle]];
    [attrs2 addAttribute:NSForegroundColorAttributeName value:AppHTMLColor(@"f5f5f5") range:[bt.currentTitle rangeOfString:bt.currentTitle]];
    [bt setAttributedTitle:attrs2 forState:UIControlStateNormal];
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

/**输入框*/
-(void)InputboxView:(UIView*)userView leftimage:(NSString*)leftimage TextField:(UITextField*)textField placeholder:(NSString*)placeholder
{
    UIImageView *bgImgView1 = [[UIImageView alloc] init];
    [userView addSubview:bgImgView1];
    [bgImgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userView.mas_left).with.offset(0);
        make.top.equalTo(userView.mas_top).with.offset(0);
        make.right.equalTo(userView.mas_right).with.offset(0);
        make.bottom.equalTo(userView.mas_bottom).with.offset(0);
    }];
    bgImgView1.image = ImageNamed(@"box");
    
    UIImageView *iconImgView1 = [[UIImageView alloc] init];
    [userView addSubview:iconImgView1];
    [iconImgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userView.mas_left).with.offset(50.5);
        make.centerY.equalTo(userView);
        make.size.mas_equalTo(CGSizeMake(15.5, 18));
    }];
    iconImgView1.image = ImageNamed(leftimage);
    
//    textField = [[UITextField alloc] init];
    [userView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView1.mas_right).with.offset(26.5);
        make.right.equalTo(userView.mas_right).with.offset(-26.5);
        make.centerY.equalTo(userView);
        make.height.mas_equalTo(14);
    }];
    textField.font = AppFont(15);
    textField.textColor = AppHTMLColor(@"ffffff");
    textField.textAlignment = NSTextAlignmentLeft;
    NSString *placeholder1 = placeholder;
    NSMutableAttributedString *attrsPlaceholder1 = [[NSMutableAttributedString alloc] initWithString:placeholder1];
    [attrsPlaceholder1 addAttribute:NSForegroundColorAttributeName value:AppHTMLColor(@"e5e5e5") range:NSMakeRange(0, placeholder1.length)];
    textField.attributedPlaceholder = attrsPlaceholder1;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

//**弹出框(点击版 返回)*/
- (void)setupClickTitle:(NSString*)title Message:(NSString*)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self exitbt];
    }];
    UIAlertAction *actionConfirm1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:actionConfirm];
    [alert addAction:actionConfirm1];
    
    [self presentViewController:alert animated:YES completion:nil];
}
//**弹出框(点击版 不返回)*/
- (void)setupClickDontreturnTitle:(NSString*)title Message:(NSString*)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self exitbt];
    }];
    UIAlertAction *actionConfirm1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:actionConfirm];
    [alert addAction:actionConfirm1];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end
