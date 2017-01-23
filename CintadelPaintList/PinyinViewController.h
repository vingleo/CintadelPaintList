//
//  PinyinViewController.h
//  CintadelPaintList
//
//  Created by vingleo on 16/9/18.
//  Copyright © 2016年 Vingleo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinyinViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *inputText;
@property (weak, nonatomic) IBOutlet UITextField *outputText;
- (IBAction)convertPinYin:(id)sender;

@end
