//
//  MainViewController.m
//  CintadelPaintList
//
//  Created by vingleo on 16/1/25.
//  Copyright © 2016年 Vingleo. All rights reserved.
//  ** Updated by vingleo 20160912 **
//  Add md5 checksum methods
//  ** Updated by vingleo 20160918 **
//  Add pinYin to latin
//  ** Updated by vingleo 20160919 **
//  Change "self" object name to "_" object name
//  ** Updated by vingleo 20161215 **
//  Change cancel FingerPrint Login  back to black window. 

#import "MainViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "CommonFunc.h"


@interface MainViewController ()

@end

@implementation MainViewController{
    
}

//-(void)applicationFinishedRestoringState{
//    _bgImage.alpha = 1;
//    //添加指纹识别
//    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
//        NSLog(@"不支持指纹识别");
//        return;
//    }else{
//        LAContext *ctx = [[LAContext alloc] init];
//        if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
//            NSLog(@"支持");
//            [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"指纹识别" reply:^(BOOL success, NSError * error) {
//                if (success) {
//                    NSLog(@"识别成功");
//                    [[NSOperationQueue mainQueue]addOperationWithBlock: ^(void)
//                     {
//                         _bgImage.alpha = 0;
//                     }];
//                }else{
//                    NSLog(@"识别失败");
//                    [[NSOperationQueue mainQueue]addOperationWithBlock: ^(void)
//                     {
//                         _bgImage.alpha = 1;
//                     }];
//                }
//            }];
//        }
//    }
//}


-(void)viewWillAppear:(BOOL)animated
{
    _bgImage.alpha = 1;
    //添加指纹识别
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        NSLog(@"不支持指纹识别");
        return;
    }else{
        LAContext *ctx = [[LAContext alloc] init];
        ctx.localizedFallbackTitle = @"使用密码登录";
        if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
            NSLog(@"支持");
            [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"指纹识别" reply:^(BOOL success, NSError * error) {
                if (success) {
                    NSLog(@"识别成功");
                    [[NSOperationQueue mainQueue]addOperationWithBlock: ^(void)
                     {
                         _bgImage.alpha = 0;
                     }];
                } else {
                    NSLog(@"识别失败");
                    switch (error.code) {
                        case LAErrorSystemCancel:
                            NSLog(@"系统取消指纹认证");
                            break;
                        case LAErrorUserCancel:
                        {
                            NSLog(@"用户取消指纹认证");
                            
                            [[NSOperationQueue mainQueue]addOperationWithBlock: ^(void)
                             {
                                 //_bgImage.alpha = 0.5;
                                 _bgImage.alpha = 1;
                             }];

                            
                            
                        }
                            break;
                        case LAErrorUserFallback:
                            NSLog(@"输入密码");
                            break;
                        case LAErrorPasscodeNotSet:
                            NSLog(@"输入密码");
                            break;
                        case LAErrorTouchIDNotEnrolled:
                            NSLog(@"没有设置touchID");
                            break;
                        case LAErrorTouchIDLockout:
                            NSLog(@"touchID被锁定");
                            break;
                        case LAErrorAppCancel:
                            NSLog(@"应用取消");
                            break;
                        case LAErrorInvalidContext:
                            NSLog(@"无效");
                            break;
                        case LAErrorTouchIDNotAvailable:
                            NSLog(@"touchID不可用");
                            break;
                        case LAErrorAuthenticationFailed:
                            NSLog(@"没有正确验证");
                            break;
                        default:
                            NSLog(@"Authentication failed");
                            break;
                    }
            }
            }];
    }
    
    //self.view.backgroundColor = [UIColor blackColor];
}
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //添加指纹识别
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        NSLog(@"不支持指纹识别");
        return;
    }else {
        LAContext *ctx = [[LAContext alloc] init];
        //ctx.localizedFallbackTitle = @"使用密码登录";
        if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
            NSLog(@"支持");
            [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"指纹识别" reply:^(BOOL success, NSError * error) {
                if (success) {
                    NSLog(@"识别成功");
                    
                    [[NSOperationQueue mainQueue]addOperationWithBlock: ^(void)
                    {
                        _bgImage.alpha = 0;
                    }];
                    
                    
                }else{
                    NSLog(@"识别失败");
                    switch (error.code) {
                        case LAErrorSystemCancel:
                            NSLog(@"系统取消指纹认证");
                            break;
                        case LAErrorUserCancel:
                            NSLog(@"用户取消指纹认证");
                            break;
                        case LAErrorUserFallback:
                            NSLog(@"输入密码");
                            break;
                        case LAErrorPasscodeNotSet:
                            NSLog(@"输入密码");
                            break;
                        case LAErrorTouchIDNotEnrolled:
                            NSLog(@"没有设置touchID");
                            break;
                        case LAErrorTouchIDLockout:
                            NSLog(@"touchID被锁定");
                            break;
                        case LAErrorAppCancel:
                            NSLog(@"应用取消");
                            break;
                        case LAErrorInvalidContext:
                            NSLog(@"无效");
                            break;
                        case LAErrorTouchIDNotAvailable:
                            NSLog(@"touchID不可用");
                            break;
                        case LAErrorAuthenticationFailed:
                            NSLog(@"没有正确验证");
                            break;
                        default:
                            NSLog(@"Authentication failed");
                            break;
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    [[NSOperationQueue mainQueue]addOperationWithBlock: ^(void)
                     {
                    _bgImage.alpha = 1;
                         
                    }];
                    
                    
                    
                    
                    
                    
                    
                    
                }
            }];
        }
    }
    //[self initTouchIDBtn];
    
    
    
    
    
    _origTextview.delegate = self;
    _textboxlabel.delegate = self;
    
    
    
    
    
    

    [self checkTime:self];
    
    // 以下代码为分页视图部分代码
//    NSMutableArray *viewControllerArray = [NSMutableArray array];
//    UIViewController *firtstVC = [[UIViewController alloc]init];
//    firtstVC.view.backgroundColor = [UIColor greenColor];
//    firtstVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Red" image:[UIImage imageNamed:@"title.home.png"] tag:1000];
//    [viewControllerArray addObject:firtstVC];
//    
//    UIViewController *secondVC =[[UIViewController alloc]init];
//    secondVC.view.backgroundColor = [UIColor blueColor];
//    secondVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"blue" image:[UIImage imageNamed:@"title_exit.png"] tag:2000];
//    [viewControllerArray addObject:secondVC];
    
    
//    // Create NSData object
//    NSData *dataTake2 =
//    [@"iOS Developer Tips" dataUsingEncoding:NSUTF8StringEncoding];
//    
//    // Convert to Base64 data
//    NSData *base64Data = [dataTake2 base64EncodedDataWithOptions:0];
//    NSLog(@"%@", [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding]);
//    
//    
//    
//    // Now convert back from Base64
//    NSData *nsdataDecoded = [base64Data initWithBase64EncodedData:base64Data options:0];
//    NSString *str = [[NSString alloc] initWithData:nsdataDecoded encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", str);
    //给UITextView加边框
    _origTextview.layer.backgroundColor = [[UIColor clearColor]CGColor];
    //self.origTextview.layer.borderColor = [[UIColor blueColor]CGColor];
    
    _origTextview.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1]  CGColor];
    _origTextview.layer.borderWidth = 1.0f;
    _origTextview.layer.cornerRadius = 6.0f;
    
    //self.origTextview.layer.borderWidth = 1.0;
    [_origTextview.layer setMasksToBounds:YES];
    
    NSString *oriCN = [NSString stringWithFormat:@"华冠科技有限公司"];
    NSString *pinyin = [self transformToPinyin:oriCN];
    NSLog(@"拼音是:%@",pinyin);
    
    //将字符串所有字母大写
    NSString *upStr = [pinyin uppercaseString];
    //截取首字母
    NSString *firstStr = [upStr substringToIndex:1];
    NSLog(@"首字母是:%@",firstStr);
    
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


#pragma mark - Encrypt methods
-(NSString *)md5:(NSString *)input {
    const char *cstr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cstr, StrLength(cstr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH *2];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x",digest[i]];
    }
    return output;
    
    
}





- (IBAction)convertText:(id)sender {
    if ([self deptNameInputShouldChinese]) {
        NSLog(@"只能是中文");
    }
    
    NSString *origiText = _originalTextField.text;
    
    
    
    NSString *cryptText = [self md5:origiText];
    
    NSString *base64Text = [CommonFunc base64StringFromText:origiText];
    
    NSLog(@"Original Text is : %@",origiText);
    NSLog(@"crypto Text is : %@",cryptText);
    NSLog(@"Base64 Text is : %@",base64Text);
    
    if (origiText != NULL) {
        _md5Label.text = cryptText;
    }
    else {
        _md5Label.text = @"";
    }
    _Base64Label.text = base64Text;
    
    
    //ios7已经自带base64编解码
    // 1.convert NSString to NSData
    NSData *dataFromString = [_origTextview.text dataUsingEncoding:NSUTF8StringEncoding];
    // 2.Base64 encrypt
    NSString *encryptText = [dataFromString base64EncodedStringWithOptions:1];
    NSLog(@"Encrypt Text is : %@",encryptText);
    
    _textboxlabel.text = encryptText;
    
}

- (IBAction)decrypt:(id)sender {
    _origTextview.delegate = self;//设置它的委托方法
    _origTextview.scrollEnabled = YES;//是否可以拖动
    _origTextview.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    //[self.view addSubview: self.origTextview];//加入到整个页面中
    
    NSLog(@"内容为 %@",_origTextview.text);
    
    
    //ios7已经自带base64编解码
    // 1.convert NSString to NSData
    NSData *dataFromBase64String = [[NSData alloc]initWithBase64EncodedString:_origTextview.text options:1];
    // 2.Base64 decrypt
    NSString *base64DecodedStr = [[NSString alloc]initWithData:dataFromBase64String encoding:NSUTF8StringEncoding];
    NSLog(@"Decrypt Text is : %@",base64DecodedStr);
    
    //ios7已经自带base64编解码，无需自行写类，故以下注释
    //NSString *decryptText = [CommonFunc textFromBase64String:self.originalTextField.text];
    //NSLog(@"Original Text is : %@",origiText);
    //NSLog(@"Decrypt Text is : %@",decryptText);
    
//    if (origiText != NULL) {
//        self.md5Label.text = decryptText;
//    }
//    else {
//        self.md5Label.text = @"";
//    }
//    self.originalLabel.text = [NSString stringWithFormat:@"%@",decryptText];
//    
//    self.textboxlabel.text = [NSString stringWithFormat:@"%@",decryptText];
    
    _textboxlabel.text = base64DecodedStr;
    
}

- (IBAction)touchIDClick:(id)sender {
    [self OnTouchIDBtn:sender];
}

- (BOOL) deptNameInputShouldChinese
{
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![pred evaluateWithObject:_originalTextField.text]) {
        return YES;
        }
    return NO;
}

-(void)checkTime:(id)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    //[df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    [df setDateFormat:@"yyyy-MM-dd h:mm:ss a"];
    _timeLabel.text = [df stringFromDate:[NSDate date]];
    [self performSelector:@selector(checkTime:) withObject:self afterDelay:1.0]; //每秒update一次
    
}


-(NSString *)transformToPinyin:(NSString *)inputCN
{
    NSMutableString *mutableString = [NSMutableString  stringWithString:inputCN];
    
    if (inputCN.length) {
        NSMutableString *pinyin = [[NSMutableString alloc]initWithString:inputCN];
        
        if (CFStringTransform((__bridge CFMutableStringRef)pinyin,0,kCFStringTransformMandarinLatin,NO)) {
            NSLog(@"pinyin:%@",pinyin);
        }
            
        
        
    }
    
    
    
    
    CFStringTransform((CFMutableStringRef)mutableString,NULL,kCFStringTransformToLatin,false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    
 
    
    
    
    return mutableString;
    
    
}

//- (NSString *)transformToPinyin {
//    NSMutableString *mutableString = [NSMutableString stringWithString:self];
//    BOOL isNeedTransform = ![self isAllEngNumAndSpecialSign];
//    if (isNeedTransform) {
//        CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
//        CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, false);
//    }
//    return mutableString;
//}
//
//- (BOOL)isAllEngNumAndSpecialSign {
//    NSString *regularString = @"^[A-Za-z0-9\\p{Z}\\p{P}]+$";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularString];
//    return [predicate evaluateWithObject:self];
//}

// 点击空白处收起键盘，对UITextView和UITextField有效
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    if (![touch.view isKindOfClass: [UITextField class]] || ![touch.view isKindOfClass: [UITextView class]])
    {
        
    [self.view endEditing:YES];
        
    }
    
}

#pragma mark - 使键盘消失的方法
//方法1和方法2 只能二选一，并且都需要在ViewDidLoad方法中添加UITextView控件的delege为self
//方法1 －－ 点击Done 关闭键盘的方法， 但是会令换行失效
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    // Any new character added is passed in as the "text" parameter
//    if ([text isEqualToString:@"\n"]) {
//        // Be sure to test for equality using the "isEqualToString" message
//        [textView resignFirstResponder];
//        
//        // Return FALSE so that the final '\n' character doesn't get added
//        return FALSE;
//    }
//    // For any other character return TRUE so that the text gets added to the view
//    return TRUE;
//}


//方法2 －－ 通过添加右侧导航按钮Done 来关闭键盘。
- (void)textViewDidBeginEditing:(UITextView *)textView {
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)] ;
    self.navigationItem.rightBarButtonItem = done;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)doneEditing{
    [_origTextview resignFirstResponder];
    [_textboxlabel resignFirstResponder];
}


#pragma mark - Touch ID Auth
//=============指纹识别==================
//-(void)initTouchIDBtn{
//    UIButton *touchIDBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    touchIDBtn.frame = CGRectMake(50, 300, 60, 40);
//    [touchIDBtn setTitle:@"指纹" forState:UIControlStateNormal];
//    [touchIDBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [touchIDBtn addTarget:self action:@selector(OnTouchIDBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:touchIDBtn];
//}

-(void)OnTouchIDBtn:(UIButton *)sender{
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        NSLog(@"不支持指纹识别");
        return;
    }else{
        LAContext *ctx = [[LAContext alloc] init];
        if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
            NSLog(@"支持");
            [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"指纹识别" reply:^(BOOL success, NSError * error) {
                if (success) {
                    NSLog(@"识别成功");
                }else{
                    NSLog(@"识别失败");
                }
            }];
        }
    }
}



@end
