//
//  PinyinViewController.m
//  CintadelPaintList
//
//  Created by vingleo on 16/9/18.
//  Copyright © 2016年 Vingleo. All rights reserved.
//  Update by Vingelo on 16/10/17
//  去除第56行中文转拼音中的空格语句注释
//  Update by Vingleo on 16/12/15
//  增加转化拼音后字母中的空格


#import "PinyinViewController.h"

@interface PinyinViewController ()

@end

@implementation PinyinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)convertPinYin:(id)sender {
    _outputText.text = [self pinYinWithString: _inputText.text];
    
}


-(NSString *)pinYinWithString:(NSString *)chinese {
    NSString *pinYinStr = [NSString string];
    if (chinese.length) {
        NSMutableString *pinYin = [[NSMutableString alloc]initWithString:chinese];
        if (CFStringTransform((__bridge CFMutableStringRef)pinYin, 0, kCFStringTransformMandarinLatin, NO)) {
            NSLog(@"pinYin:%@",pinYin);
            
            
            pinYinStr = [NSString stringWithString:pinYin];
            pinYinStr = [pinYinStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@" " withString:@" "]; //Insert white space between pinyin charectors
        }
        
//        if (CFStringTransform((__bridge CFMutableStringRef)pinYin, 0, kCFStringTransformStripDiacritics, NO)) {
//            NSLog(@"pinYin:%@",pinYin);
//            
//            
//            
//            
//            
//            
//        }
        
        
    }
    return pinYinStr;
}



@end
