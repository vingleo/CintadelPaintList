//
//  DetailViewController.m
//  CintadelPaintList
//
//  Created by vingleo on 16/2/3.
//  Copyright © 2016年 Vingleo. All rights reserved.
//
//  **Updated by vingleo 2016.09.08 **
//  Add Previous and forward buttons
//  **Updated by vingleo 2016.09.09 **
//  Add Search function and modify Pre & forward button function
//  **Updated by vingleo 2016.09.12 **
//  Fix the pre & forward button function display wrong results.
//  ** Updated by vingleo 20160919 **
//  Change "self" object name to "_" object name
//  ** Updated by vingleo 20161213 **
//  Add show alert message function while navigate to first paint & last one.


#import "DetailViewController.h"
#import "NameTableViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"DetailViewController 's SearchResultsModal is : %@",self.searchResultModal);
    
    if (_searchResultModal.count == 0)
    {
        
        _categoryLabel.text = _detailModal[0];
        //NSLog(@"detailModal is : %@",self.detailModal);
        _DetailImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_detailModal[1]]];
        //NSLog(@"%@",[NSString stringWithFormat:@"%@",_detailModal[1]]);
        _nameEnlabel.text = _detailModal[2];
        _nameCnlabel.text = _detailModal[3];
        _priceLabel.text = _detailModal[4];
        self.navigationItem.title = _detailModal[2];
        
        _index = _lastIndexPath.row;
        //NSLog(@"DetailModal is %@",self.detailModal);
    }
    else {
        NSString *categoryText = [[[_searchResultModal objectAtIndex:_lastIndexPath.row] valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(@"The current Category Text is: %@",categoryText);
        
        NSString *nameEnText = [[[_searchResultModal objectAtIndex:_lastIndexPath.row]valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(@"nameEnText is: %@",nameEnText);
        
        NSString *nameCnText = [[[_searchResultModal objectAtIndex:_lastIndexPath.row]valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        NSString *priceText = [[[_searchResultModal objectAtIndex:_lastIndexPath.row]valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(@"price is : %@",priceText);
        
        NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
        
        NSString *path = [[_searchResultModal objectAtIndex:_lastIndexPath.row]valueForKey:@"ImageFullPath"];
        //NSLog(@"Image fule path is: %@",path);
        NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(@"trimmedPath is : %@",trimmedPath);
        
        NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
        NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *imagePathText = string1;
        //NSLog(@"iamgePathText is : %@",imagePathText);
        
        _currentModal = @[categoryText, imagePathText,nameEnText,nameCnText,priceText];
        //NSLog(@"CurrentModel is %@",self.currentModal);
        
        _categoryLabel.text = _currentModal[0];
        _DetailImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_currentModal[1]]];
        //NSLog(@"%@",[NSString stringWithFormat:@"%@",_currentModal[1]]);
        _nameEnlabel.text = _currentModal[2];
        _nameCnlabel.text = _currentModal[3];
        _priceLabel.text = _currentModal[4];
        self.navigationItem.title = _currentModal[2];
      
        
        
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

- (IBAction)preClick:(id)sender {
    
    if (_searchResultModal.count == 0) {
    
        if (_index == 0) {
            NSLog(@"已经是完整第一个！！");
            
            UIAlertController  *alert = [UIAlertController alertControllerWithTitle:@"您浏览的是完整内容" message:@"已经是第一个！！" preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            //取消
            
            UIAlertAction *cacelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:cacelAction];
            
            //确认
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                //NSLog(@"你好啊");
                
            }];
            
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else {
        _index--;
        //self.currentBase = [self.allModal objectAtIndex:self.index];
        _preModal = [_allModal objectAtIndex:_index];
        //NSLog(@"currentBase is : %@",self.preModal);
        
        
        
        NSString *categoryText = [[_preModal valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(@"The current Category Text is: %@",categoryText);
        
        NSString *nameEnText = [[_preModal valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(@"nameEnText is: %@",nameEnText);
        
        NSString *nameCnText = [[_preModal valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        NSString *priceText = [[_preModal valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(@"price is : %@",priceText);
        
        NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
        
        NSString *path = [_preModal valueForKey:@"ImageFullPath"];
        NSLog(@"Image fule path is: %@",path);
        NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"trimmedPath is : %@",trimmedPath);

        NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
        NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *imagePathText = string1;
        NSLog(@"iamgePathText is : %@",imagePathText);
       
        _currentModal = @[categoryText, imagePathText,nameEnText,nameCnText,priceText];
            NSLog(@"preModel is %@",_preModal);
        
        _categoryLabel.text = _currentModal[0];
        _DetailImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_currentModal[1]]];
        NSLog(@"%@",[NSString stringWithFormat:@"%@",_currentModal[1]]);
        _nameEnlabel.text = _currentModal[2];
        _nameCnlabel.text = _currentModal[3];
        _priceLabel.text = _currentModal[4];
        self.navigationItem.title = _currentModal[2];

        
    }

    
    
    
//    self.categoryLabel.text = _preModal[0];
//    NSLog(@"%@",_preModal[0]);
//    self.DetailImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.preModal[1]]];
//    NSLog(@"%@",[NSString stringWithFormat:@"%@",self.preModal[1]]);
//    self.nameEnlabel.text = self.preModal[2];
//    self.nameCnlabel.text = self.preModal[3];
//    self.priceLabel.text = self.preModal[4];
//    
//    self.navigationItem.title = self.preModal[2];
//    [self viewDidLoad];
    
   
    
    
//    self.newrow = [self.lastIndexPath row]-1;
//    
//    self.preModal = [self.allModal objectAtIndex:self.newrow];
//    self.newrow --;
//    
//    
//
//    
//    NSLog(@"CurrentModal is : %@", self.preModal);
//    
//    NSString *currentCategoryText = [[[self.preModal objectAtIndex:self.newrow]valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        NSString *currentNameEnText = [[[self.preModal objectAtIndex:self.newrow]valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        NSString *currentNameCnText = [[[self.preModal objectAtIndex:self.newrow]valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        NSString *currentPriceText = [[[self.preModal objectAtIndex:self.newrow]valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    
//        NSString *currentBundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
//    
//        NSString *currentPath = [[self.preModal objectAtIndex:self.newrow]valueForKey:@"ImageFullPath"];
//        NSString *currentTrimmedPath = [currentPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    
//        NSString *currentFilePath = [currentBundlePath stringByAppendingPathComponent:currentTrimmedPath];
//        NSString *currentTrimmedString = [currentFilePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        NSString *currentString1 = [currentTrimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        NSString *currentImagePathText = currentString1;
//        self.currentModal = @[currentCategoryText, currentImagePathText,currentNameEnText,currentNameCnText,currentPriceText];
//    
//    
//    
    }
    else {
        if (_index == 0) {
            NSLog(@"已经是搜索内容第一个！！");
            
            UIAlertController  *alert = [UIAlertController alertControllerWithTitle:@"您浏览的是搜索内容" message:@"已经是第一个！！" preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            //取消
            
            UIAlertAction *cacelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:cacelAction];
            
            //确认
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                //NSLog(@"你好啊");
                
            }];
            
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
        }
        else {
            _index--;
            //self.currentBase = [self.allModal objectAtIndex:self.index];
            _preModal = [_searchResultModal objectAtIndex:_index];
            //NSLog(@"currentBase is : %@",self.preModal);
            
            
            
            NSString *categoryText = [[_preModal valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //NSLog(@"The current Category Text is: %@",categoryText);
            
            NSString *nameEnText = [[_preModal valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //NSLog(@"nameEnText is: %@",nameEnText);
            
            NSString *nameCnText = [[_preModal valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            
            NSString *priceText = [[_preModal valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //NSLog(@"price is : %@",priceText);
            
            NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
            
            NSString *path = [_preModal valueForKey:@"ImageFullPath"];
            //NSLog(@"Image fule path is: %@",path);
            NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //NSLog(@"trimmedPath is : %@",trimmedPath);
            
            NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
            NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *imagePathText = string1;
            //NSLog(@"iamgePathText is : %@",imagePathText);
            
            _currentModal = @[categoryText, imagePathText,nameEnText,nameCnText,priceText];
            //NSLog(@"preModel is %@",self.preModal);
            
            _categoryLabel.text = _currentModal[0];
            _DetailImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_currentModal[1]]];
            //NSLog(@"%@",[NSString stringWithFormat:@"%@",_currentModal[1]]);
            _nameEnlabel.text = _currentModal[2];
            _nameCnlabel.text = _currentModal[3];
            _priceLabel.text = _currentModal[4];
            self.navigationItem.title = _currentModal[2];
            
            
        }
    }
    
    
}

- (IBAction)forwardClick:(id)sender {
    
    if (_searchResultModal.count == 0)
    {
        if (_index == [_allModal indexOfObject:[_allModal lastObject]]) {
            NSLog(@"已经是完整内容最后一个！！");
            
            UIAlertController  *alert = [UIAlertController alertControllerWithTitle:@"您浏览的是完整内容" message:@"已经是最后一个！！" preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            //取消
            
            UIAlertAction *cacelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:cacelAction];
            
            //确认
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                //NSLog(@"你好啊");
                
            }];
            
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
            
            
            
        }
        else {
            _index++;
            _forwardModal = [_allModal objectAtIndex:_index];
            
            NSString *categoryText = [[_forwardModal valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //NSLog(@"The current Category Text is: %@",categoryText);
            
            NSString *nameEnText = [[_forwardModal valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //NSLog(@"nameEnText is: %@",nameEnText);
            
            NSString *nameCnText = [[_forwardModal valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            
            NSString *priceText = [[_forwardModal valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //NSLog(@"price is : %@",priceText);
            
            NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
            
            NSString *path = [_forwardModal valueForKey:@"ImageFullPath"];
            //NSLog(@"Image fule path is: %@",path);
            NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //NSLog(@"trimmedPath is : %@",trimmedPath);
            
            NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
            NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *imagePathText = string1;
            //NSLog(@"imagePathText is : %@",imagePathText);
            
            _currentModal = @[categoryText, imagePathText,nameEnText,nameCnText,priceText];
            //NSLog(@"preModel is %@",self.forwardModal);
            
            _categoryLabel.text = _currentModal[0];
            _DetailImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_currentModal[1]]];
            //NSLog(@"%@",[NSString stringWithFormat:@"%@",_currentModal[1]]);
            _nameEnlabel.text = _currentModal[2];
            _nameCnlabel.text = _currentModal[3];
            _priceLabel.text = _currentModal[4];
            self.navigationItem.title = _currentModal[2];
        }
    }
    else
        {
            //NSLog(@"搜索有内容");
        if (_index == [_searchResultModal indexOfObject:[_searchResultModal lastObject]]) {
            NSLog(@"已经是搜索内容最后一个！！");
            //self.index = ([self.allModal count]-1);
            
            UIAlertController  *alert = [UIAlertController alertControllerWithTitle:@"您浏览的是搜索内容" message:@"已经是最后一个！！" preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            //取消
            
            UIAlertAction *cacelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:cacelAction];
            
            //确认
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                //NSLog(@"你好啊");
                
            }];
            
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
            
        }
        else {
            //NSLog(@"已经是完整内容非最后一个！！");
            _index++;

            _forwardModal = [_searchResultModal objectAtIndex:_index];
            //NSLog(@"currentBase is : %@",self.preModal);
            
            
            
            NSString *categoryText = [[_forwardModal valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //NSLog(@"The current Category Text is: %@",categoryText);
            
            NSString *nameEnText = [[_forwardModal valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //NSLog(@"nameEnText is: %@",nameEnText);
            
            NSString *nameCnText = [[_forwardModal valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            
            NSString *priceText = [[_forwardModal valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //NSLog(@"price is : %@",priceText);
            
            NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
            
            NSString *path = [_forwardModal valueForKey:@"ImageFullPath"];
            //NSLog(@"Image fule path is: %@",path);
            NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //NSLog(@"trimmedPath is : %@",trimmedPath);
            
            NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
            NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *imagePathText = string1;
            //NSLog(@"imagePathText is : %@",imagePathText);
            
            _currentModal = @[categoryText, imagePathText,nameEnText,nameCnText,priceText];
            //NSLog(@"ForwardModal is %@",self.forwardModal);
            
            _categoryLabel.text = _currentModal[0];
            _DetailImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_currentModal[1]]];
            //NSLog(@"%@",[NSString stringWithFormat:@"%@",_currentModal[1]]);
            _nameEnlabel.text = _currentModal[2];
            _nameCnlabel.text = _currentModal[3];
            _priceLabel.text = _currentModal[4];
            self.navigationItem.title = _currentModal[2];
            

        }
    }
    
    
    
    
}
@end
