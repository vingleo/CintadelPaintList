//
//  MainViewController.h
//  CintadelPaintList
//
//  Created by vingleo on 16/1/25.
//  Copyright © 2016年 Vingleo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>//指纹识别

@interface MainViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *md5Label;
@property (weak, nonatomic) IBOutlet UILabel *Base64Label;
@property (weak, nonatomic) IBOutlet UITextField *originalTextField;
@property (weak, nonatomic) IBOutlet UILabel *originalLabel;
@property (weak, nonatomic) IBOutlet UITextView *textboxlabel;
@property (weak, nonatomic) IBOutlet UITextView *origTextview;
- (IBAction)convertText:(id)sender;
- (IBAction)decrypt:(id)sender;
- (IBAction)touchIDClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@end
