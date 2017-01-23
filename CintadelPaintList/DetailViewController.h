//
//  DetailViewController.h
//  CintadelPaintList
//
//  Created by vingleo on 16/2/3.
//  Copyright © 2016年 Vingleo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *DetailImageView;
@property(strong,nonatomic)  NSIndexPath *lastIndexPath;
@property NSUInteger index;

@property (strong,nonatomic) NSArray *detailModal;
@property (strong,nonatomic) NSArray *allModal;
@property (strong,nonatomic) NSArray *currentModal;
@property (strong,nonatomic) NSArray *preModal;
@property (strong,nonatomic) NSArray *forwardModal;
@property (strong,nonatomic) NSArray *searchResultModal;

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameEnlabel;
@property (weak, nonatomic) IBOutlet UILabel *nameCnlabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
- (IBAction)preClick:(id)sender;
- (IBAction)forwardClick:(id)sender;

@end
