//
//  NameTableViewController.m
//  CintadelPaintList
//
//  Created by vingleo on 16/1/25.
//  Copyright © 2016年 Vingleo. All rights reserved.
//  **Updated by vingleo 2016.09.05 **
//  TableViewCell split groups
//  **Updated by vingleo 2016.09.09 **
//  Add Search function
//  ** Updated by vingleo 20160919 **
//  Change "self" object name to "_" object name
//  ** Updated by vingleo 20161019 **
//  Add function for Chinese Text input filter

#import "NameTableViewController.h"
#import "DetailViewController.h"
#import "PinyinViewController.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface NameTableViewController ()

@end

@implementation NameTableViewController
@synthesize dictData,marrXMLData,mstrXMLString,mdictXMLPart;


-(void)startParsing {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"CitadelPaintList" ofType:@"xml"];
    NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    [xmlParser setDelegate:self];
    [xmlParser parse];
    
    if (marrXMLData.count != 0) {
        [self.tableView reloadData];
    }
    
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    if ([elementName isEqualToString:@"Root"]) {
        marrXMLData = [[NSMutableArray alloc]init];
    }
    if ([elementName isEqualToString:@"Row"]) {
        mdictXMLPart = [[NSMutableDictionary alloc]init];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!mstrXMLString) {
        mstrXMLString  = [[NSMutableString alloc]initWithString:string];
    }
    else {
        [mstrXMLString appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:@"Category"]||
        [elementName isEqualToString:@"CategoryNew"]||
        [elementName isEqualToString:@"IncludeSetName"]||
        [elementName isEqualToString:@"ImageName"]||
        [elementName isEqualToString:@"ImageFullPath"]||
        [elementName isEqualToString:@"NameEn"]||
        [elementName isEqualToString:@"NameZh"]||
        [elementName isEqualToString:@"Price"]||
        [elementName isEqualToString:@"StoreName"]||
        [elementName isEqualToString:@"isStored"]){
        [mdictXMLPart setObject:mstrXMLString forKey:elementName];
    }
    if ([elementName isEqualToString:@"Row"]) {
        [marrXMLData addObject:mdictXMLPart];
    }
    mstrXMLString = nil;
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"Error Message : %@", [parser description]);
}


- (void)viewDidLoad {
    //for search bar
    
    
    _resultController.tableView.dataSource = self;
    _resultController.tableView.delegate = self;
    
    _searchController = [[UISearchController alloc]initWithSearchResultsController:_resultController];
    self.tableView.tableHeaderView = _searchController.searchBar;
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = false;
    self.definesPresentationContext = YES;
    
    _searchController.delegate = self;
    [_searchController.searchBar sizeToFit];
    
//    //for search bar display
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
//    label.backgroundColor = [UIColor greenColor];
//    label.text = @"\n搜搜";
//    label.numberOfLines = 0;
//    label.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:label];
//    
//    
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
//    self.tableView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:self.tableView];
    
//    // UISearchController初始化
        //self.searchController = [[UISearchController alloc] initWithSearchResultsController:self];//这里如果不用self用nil的话 ，会导致返回上一个view出现报错：”Attempting to load the view of a view controller while it is deallocating is not allowed and may result in undefined behavior (<UISearchController: 0x7f89c2000900>)“。必须点击一下搜索栏才不会。
    
//    self.searchController.searchResultsUpdater = self;
//    //self.searchController.delegate = self;
//    self.searchController.searchBar.frame = CGRectMake(0, 100, WIDTH, 44);
//    self.searchController.searchBar.barTintColor = [UIColor yellowColor];
//    //self.searchController.tableHeaderView = self.searchController.searchBar;
    
    
    
    
    [super viewDidLoad];
    [self startParsing];
    NSLog(@"mdictXMLPart count is %lu",(unsigned long)[mdictXMLPart count]);

    
    
    //NSLog(@"%@",[marrXMLData description]);
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    _categoryText = [[[marrXMLData objectAtIndex:indexPath.row]valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSLog(@"marrXMLData array count is:%lu",(unsigned long)[marrXMLData count]);
    NSLog(@"marrXMLData array is %@",marrXMLData);
    
    NSPredicate *basePredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@", @"Base"];
    NSArray *baseResults = [marrXMLData filteredArrayUsingPredicate:basePredicate];
        NSLog(@"Base Array count is:%lu",(unsigned long)[baseResults count]);
    
    NSPredicate *dryPredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@", @"Dry"];
    NSArray *dryResults = [marrXMLData filteredArrayUsingPredicate:dryPredicate];
        NSLog(@"Dry Array count is:%lu",(unsigned long)[dryResults count]);
    
    NSPredicate *glazePredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@",@"Glaze"];
    NSArray *glazeResults = [marrXMLData filteredArrayUsingPredicate:glazePredicate];
        NSLog(@"Glaze Array count is:%lu",(unsigned long)[glazeResults count]);
    
    NSPredicate *layerPredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@",@"Layer"];
    NSArray *layerResults = [marrXMLData filteredArrayUsingPredicate:layerPredicate];
        NSLog(@"Layer Array count is:%lu",(unsigned long)[layerResults count]);
    
    NSPredicate *shadePredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@",@"Shade"];
    NSArray *shadeResults = [marrXMLData filteredArrayUsingPredicate:shadePredicate];
    NSLog(@"Shade Array count is:%lu",(unsigned long)[shadeResults count]);

    NSPredicate *technicalPredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@",@"Technical"];
    NSArray *technicalResults = [marrXMLData filteredArrayUsingPredicate:technicalPredicate];
    NSLog(@"Technical Array count is:%lu",(unsigned long)[technicalResults count]);
    
    NSPredicate *texturePredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@",@"Technical"];
    NSArray *textureResults = [marrXMLData filteredArrayUsingPredicate:texturePredicate];
    NSLog(@"Texture Array count is:%lu",(unsigned long)[textureResults count]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    NSInteger result = 0;
//    NSArray *sectionArray = [mdictXMLPart objectForKey:@"Category"];
//    result = [sectionArray count];
//        return result;
    if (_fiterResults.count == 0)
    {
        return 7;
    }
    else
    {
        return  1;
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //return [marrXMLData count];
    
    if (_fiterResults.count == 0)
    {
        NSPredicate *basePredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@", @"Base"];
        NSPredicate *shadePredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@",@"Shade"];
        NSPredicate *dryPredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@",@"Dry"];
        NSPredicate *layerPredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@",@"Layer"];
        NSPredicate *texturePredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@",@"Texture"];
        NSPredicate *technicalPredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@",@"Technical"];
        NSPredicate *glazePredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@",@"Glaze"];

        
        

        
                                       
        _baseResults = [marrXMLData filteredArrayUsingPredicate:basePredicate];
        _shadeResults = [marrXMLData filteredArrayUsingPredicate:shadePredicate];
        _dryResults = [marrXMLData filteredArrayUsingPredicate:dryPredicate];
        _layerResults = [marrXMLData filteredArrayUsingPredicate:layerPredicate];
        _textureResults = [marrXMLData filteredArrayUsingPredicate:texturePredicate];
        _technicalResults  = [marrXMLData filteredArrayUsingPredicate:technicalPredicate];
        _glazeResults= [marrXMLData filteredArrayUsingPredicate:glazePredicate];

        switch (section) {
            case 0:
            {
                //NSLog(@"Base Results count is %ld",[self.baseResults count]);
                return [_baseResults count];
                break;
            }
            case 1:
            {
                return [_shadeResults count];
                break;
            }
            case 2:
            {
                return [_dryResults count];
                break;
            }
            case 3:
            {
                return [_layerResults count];
                break;
            }
            case 4:
            {
                return [_textureResults count];
                break;
            }
            case 5:
            {
                return [_technicalResults count];
                break;
            }
            case 6:
            {
                return [_glazeResults count];
                break;
            }
            default:
                return 1;
                break;
        }
        
    }
    else {
        return _fiterResults.count;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (_fiterResults.count == 0)
    {
        if (section == 0) {
            return @"Base";
        }
        else if(section == 1){
            return  @"Shade";
        }
        else if(section == 2){
            return @"Dry";
        }
        else if(section == 3) {
            return @"Layer";
        }
        else if(section == 4) {
            return @"Texture";
        }
        else if(section == 5){
            return @"Technical";
        }
        else {
            return @"Glaze";
        }
    }
    
    else {
        return @"Filtered Paint";
    }
    
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //if (self.fiterResults.count == 0)
    if (_fiterResults.count == 0)
    {
        //NSLog(@"没有选中搜索框");
        if (indexPath.section == 0) {
            
            NSPredicate *basePredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@", @"Base"];
            NSArray *baseResults = [marrXMLData filteredArrayUsingPredicate:basePredicate];
            
            
            static NSString *cellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            
            
            
            cell.textLabel.text = [[[baseResults objectAtIndex:indexPath.row]valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cell.detailTextLabel.text = [[[baseResults objectAtIndex:indexPath.row]valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //self.categoryText = cell.textLabel.text;
            //self.nameEnText = cell.detailTextLabel.text;
            _nameCnText = [[[baseResults objectAtIndex:indexPath.row]valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            _priceText = [[[baseResults objectAtIndex:indexPath.row]valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            
            NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
            
            NSString *path = [[baseResults objectAtIndex:indexPath.row]valueForKey:@"ImageFullPath"];
            NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
            NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",string1]];
            //NSLog(@"%@",string1);
            
            return cell;
            
            
            
        }
        
        else if (indexPath.section == 1) {
            NSPredicate *shadePredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@", @"Shade"];
            NSArray *shadeResults = [marrXMLData filteredArrayUsingPredicate:shadePredicate];
            
            static NSString *cellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            
            cell.textLabel.text = [[[shadeResults objectAtIndex:indexPath.row]valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cell.detailTextLabel.text = [[[shadeResults objectAtIndex:indexPath.row]valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //self.categoryText = cell.textLabel.text;
            //self.nameEnText = cell.detailTextLabel.text;
            _nameCnText = [[[shadeResults objectAtIndex:indexPath.row]valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            _priceText = [[[shadeResults objectAtIndex:indexPath.row]valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
            
            NSString *path = [[shadeResults objectAtIndex:indexPath.row]valueForKey:@"ImageFullPath"];
            NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
            NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",string1]];
            //NSLog(@"%@",string1);
            
            
            return cell;
            
            
        }
        
        else if (indexPath.section == 2) {
            NSPredicate *dryPredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@", @"Dry"];
            NSArray *dryResults = [marrXMLData filteredArrayUsingPredicate:dryPredicate];
            
            static NSString *cellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            
            cell.textLabel.text = [[[dryResults objectAtIndex:indexPath.row]valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cell.detailTextLabel.text = [[[dryResults objectAtIndex:indexPath.row]valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //self.categoryText = cell.textLabel.text;
            //self.nameEnText = cell.detailTextLabel.text;
            _nameCnText = [[[dryResults objectAtIndex:indexPath.row]valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            _priceText = [[[dryResults objectAtIndex:indexPath.row]valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
            
            NSString *path = [[dryResults objectAtIndex:indexPath.row]valueForKey:@"ImageFullPath"];
            NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
            NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",string1]];
            //NSLog(@"%@",string1);
            
            
            return cell;
            
            
        }
        
        
        
        else if (indexPath.section == 3)
        {
            
            NSPredicate *layerPredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@",@"Layer"];
            NSArray *layerResults = [marrXMLData filteredArrayUsingPredicate:layerPredicate];
            
            static NSString *cellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.textLabel.text = [[[layerResults objectAtIndex:indexPath.row]valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cell.detailTextLabel.text = [[[layerResults objectAtIndex:indexPath.row]valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //self.categoryText = cell.textLabel.text;
            //self.nameEnText = cell.detailTextLabel.text;
            _nameCnText = [[[layerResults objectAtIndex:indexPath.row]valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            _priceText = [[[layerResults objectAtIndex:indexPath.row]valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
            
            NSString *path = [[layerResults objectAtIndex:indexPath.row]valueForKey:@"ImageFullPath"];
            NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
            NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",string1]];
            //NSLog(@"%@",string1);
            
            
            return cell;
            
        }
        
        else if (indexPath.section == 4)
        {
            
            NSPredicate *texturePredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@",@"Texture"];
            NSArray *textureResults = [marrXMLData filteredArrayUsingPredicate:texturePredicate];
            
            static NSString *cellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.textLabel.text = [[[textureResults objectAtIndex:indexPath.row]valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cell.detailTextLabel.text = [[[textureResults objectAtIndex:indexPath.row]valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //self.categoryText = cell.textLabel.text;
            //self.nameEnText = cell.detailTextLabel.text;
            _nameCnText = [[[textureResults objectAtIndex:indexPath.row]valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            _priceText = [[[textureResults objectAtIndex:indexPath.row]valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
            
            NSString *path = [[textureResults objectAtIndex:indexPath.row]valueForKey:@"ImageFullPath"];
            NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
            NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",string1]];
            //NSLog(@"%@",string1);
            
            
            return cell;
            
        }
        
        else if (indexPath.section == 5)
        {
            
            NSPredicate *technicalPredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@",@"Technical"];
            NSArray *technicalResults = [marrXMLData filteredArrayUsingPredicate:technicalPredicate];
            
            static NSString *cellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.textLabel.text = [[[technicalResults objectAtIndex:indexPath.row]valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cell.detailTextLabel.text = [[[technicalResults objectAtIndex:indexPath.row]valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //self.categoryText = cell.textLabel.text;
            //self.nameEnText = cell.detailTextLabel.text;
            _nameCnText = [[[technicalResults objectAtIndex:indexPath.row]valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            _priceText = [[[technicalResults objectAtIndex:indexPath.row]valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
            
            NSString *path = [[technicalResults objectAtIndex:indexPath.row]valueForKey:@"ImageFullPath"];
            NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
            NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",string1]];
            //NSLog(@"%@",string1);
            
            
            return cell;
            
        }
        
        else if (indexPath.section == 6)
        {
            
            NSPredicate *glazePredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@",@"Glaze"];
            NSArray *glazeResults = [marrXMLData filteredArrayUsingPredicate:glazePredicate];
            
            static NSString *cellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.textLabel.text = [[[glazeResults objectAtIndex:indexPath.row]valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cell.detailTextLabel.text = [[[glazeResults objectAtIndex:indexPath.row]valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //self.categoryText = cell.textLabel.text;
            //self.nameEnText = cell.detailTextLabel.text;
            _nameCnText = [[[glazeResults objectAtIndex:indexPath.row]valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            _priceText = [[[glazeResults objectAtIndex:indexPath.row]valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
            
            NSString *path = [[glazeResults objectAtIndex:indexPath.row]valueForKey:@"ImageFullPath"];
            NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
            NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",string1]];
            //NSLog(@"%@",string1);
            
            
            return cell;
            
        }
        
        else {
            
            static NSString *cellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.textLabel.text = [[[marrXMLData objectAtIndex:indexPath.row]valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cell.detailTextLabel.text = [[[marrXMLData objectAtIndex:indexPath.row]valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //self.categoryText = cell.textLabel.text;
            //self.nameEnText = cell.detailTextLabel.text;
            _nameCnText = [[[marrXMLData objectAtIndex:indexPath.row]valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            _priceText = [[[marrXMLData objectAtIndex:indexPath.row]valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
            
            NSString *path = [[marrXMLData objectAtIndex:indexPath.row]valueForKey:@"ImageFullPath"];
            NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
            NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",string1]];
            //NSLog(@"%@",string1);
            
            
            return cell;
            
        }
    }
    
    
    else {
        //NSLog(@"选中了搜索框");
        //NSLog(@"Search Results array is :%@",self.fiterResults);
        static NSString *cellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        if (cell==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        
        
        
        cell.textLabel.text = [[[_fiterResults objectAtIndex:indexPath.row]valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        cell.detailTextLabel.text = [[[_fiterResults objectAtIndex:indexPath.row]valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //self.categoryText = cell.textLabel.text;
        //self.nameEnText = [[[self.fiterResults objectAtIndex:indexPath.row]valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //self.nameCnText = [[[self.fiterResults objectAtIndex:indexPath.row]valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //self.priceText = [[[self.fiterResults objectAtIndex:indexPath.row]valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
        
        NSString *path = [[_fiterResults objectAtIndex:indexPath.row]valueForKey:@"ImageFullPath"];
        NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
        NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",string1]];
        //NSLog(@"%@",string1);
        
        //self.imagePathText = string1;
        ///////////////////////////******************************/////////////////////
        //self.searchResults = [@[self.categoryText, self.imagePathText,self.nameEnText,self.nameCnText,self.priceText]mutableCopy];
        //NSLog(@"NameTableViewController 's searchResults Array is : %@ ",self.searchResults);
        
        return cell;
        
        
    }
    
    
    
    
    
 //use img directory
  
//    NSString *imgPath = [[marrXMLData objectAtIndex:indexPath.row]valueForKey:@"ImageName"];
//    NSString *trimmedString = [imgPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    
//    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",string1]];

    
    //NSLog(@"%@",imgPath);

//    //Use bundle
//    NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
//    
//    NSString *path = [[marrXMLData objectAtIndex:indexPath.row]valueForKey:@"ImageFullPath"];
//    NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    
//    NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
//    NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
// 
//    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",string1]];
//    //NSLog(@"%@",string1);
//    
//    
//    return cell;

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        DetailViewController *detailView = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        if (_fiterResults.count == 0)
        {
            //** Sorted detail data array
            if (indexPath.section == 0)
            {
                
                NSPredicate *basePredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@", @"Base"];
                NSArray *baseResults = [marrXMLData filteredArrayUsingPredicate:basePredicate];
                
                
                static NSString *cellIdentifier = @"Cell";
                UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                if (cell==nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                
                _categoryText = [[[baseResults objectAtIndex:indexPath.row]valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                _nameEnText = [[[baseResults objectAtIndex:indexPath.row]valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                _nameCnText = [[[baseResults objectAtIndex:indexPath.row]valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                _priceText = [[[baseResults objectAtIndex:indexPath.row]valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
                
                NSString *path = [[baseResults objectAtIndex:indexPath.row]valueForKey:@"ImageFullPath"];
                NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
                NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                _imagePathText = string1;
                detailView.detailModal = @[_categoryText, _imagePathText, _nameEnText,_nameCnText,_priceText];
                
                detailView.allModal = baseResults;
                detailView.lastIndexPath = indexPath;
            }
            
            if (indexPath.section == 1) {
                
                NSPredicate *shadePredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@", @"Shade"];
                NSArray *shadeResults = [marrXMLData filteredArrayUsingPredicate:shadePredicate];
                
                
                static NSString *cellIdentifier = @"Cell";
                UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                if (cell==nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                
                _categoryText = [[[shadeResults objectAtIndex:indexPath.row]valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                _nameEnText = [[[shadeResults objectAtIndex:indexPath.row]valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                _nameCnText = [[[shadeResults objectAtIndex:indexPath.row]valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                _priceText = [[[shadeResults objectAtIndex:indexPath.row]valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
                
                NSString *path = [[shadeResults objectAtIndex:indexPath.row]valueForKey:@"ImageFullPath"];
                NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
                NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                _imagePathText = string1;
                
                detailView.detailModal = @[_categoryText, _imagePathText, _nameEnText, _nameCnText,_priceText];
                
                detailView.allModal = shadeResults;
                detailView.lastIndexPath = indexPath;
                
                
                
                
                
            }
            
            
            if (indexPath.section == 2) {
                
                NSPredicate *dryPredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@", @"Dry"];
                NSArray *dryResults = [marrXMLData filteredArrayUsingPredicate:dryPredicate];
                
                
                static NSString *cellIdentifier = @"Cell";
                UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                if (cell==nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                
                _categoryText = [[[dryResults objectAtIndex:indexPath.row]valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                _nameEnText = [[[dryResults objectAtIndex:indexPath.row]valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                _nameCnText = [[[dryResults objectAtIndex:indexPath.row]valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                _priceText = [[[dryResults objectAtIndex:indexPath.row]valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
                
                NSString *path = [[dryResults objectAtIndex:indexPath.row]valueForKey:@"ImageFullPath"];
                NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
                NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                _imagePathText = string1;
                detailView.detailModal = @[_categoryText, _imagePathText, _nameEnText, _nameCnText, _priceText];
                
                detailView.allModal = dryResults;
                detailView.lastIndexPath = indexPath;
                
                
                
            }
            
            if (indexPath.section == 3) {
                
                NSPredicate *layerPredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@", @"Layer"];
                NSArray *layerResults = [marrXMLData filteredArrayUsingPredicate:layerPredicate];
                
                
                static NSString *cellIdentifier = @"Cell";
                UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                if (cell==nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                
                _categoryText = [[[layerResults objectAtIndex:indexPath.row]valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                _nameEnText = [[[layerResults objectAtIndex:indexPath.row]valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                _nameCnText = [[[layerResults objectAtIndex:indexPath.row]valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                _priceText = [[[layerResults objectAtIndex:indexPath.row]valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
                
                NSString *path = [[layerResults objectAtIndex:indexPath.row]valueForKey:@"ImageFullPath"];
                NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
                NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                _imagePathText = string1;
                
                detailView.detailModal = @[_categoryText, _imagePathText, _nameEnText, _nameCnText,_priceText];
                
                detailView.allModal = layerResults;
                detailView.lastIndexPath = indexPath;
                
            }
            
            
            
            if (indexPath.section == 4) {
                
                NSPredicate *texturePredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@", @"Texture"];
                NSArray *textureResults = [marrXMLData filteredArrayUsingPredicate:texturePredicate];
                
                
                static NSString *cellIdentifier = @"Cell";
                UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                if (cell==nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                
                _categoryText = [[[textureResults objectAtIndex:indexPath.row]valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                _nameEnText = [[[textureResults objectAtIndex:indexPath.row]valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                _nameCnText = [[[textureResults objectAtIndex:indexPath.row]valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                _priceText = [[[textureResults objectAtIndex:indexPath.row]valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
                
                NSString *path = [[textureResults objectAtIndex:indexPath.row]valueForKey:@"ImageFullPath"];
                NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
                NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                _imagePathText = string1;
                
                
                detailView.detailModal = @[_categoryText,_imagePathText,_nameEnText,_nameCnText,_priceText];
                detailView.allModal = textureResults;
                detailView.lastIndexPath = indexPath;
                
            }
            
            if (indexPath.section == 5) {
                
                NSPredicate *technicalPredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@", @"Technical"];
                NSArray *technicalResults = [marrXMLData filteredArrayUsingPredicate:technicalPredicate];
                
                
                static NSString *cellIdentifier = @"Cell";
                UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                if (cell==nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                
                _categoryText = [[[technicalResults objectAtIndex:indexPath.row]valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                _nameEnText = [[[technicalResults objectAtIndex:indexPath.row]valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                _nameCnText = [[[technicalResults objectAtIndex:indexPath.row]valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                _priceText = [[[technicalResults objectAtIndex:indexPath.row]valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
                
                NSString *path = [[technicalResults objectAtIndex:indexPath.row]valueForKey:@"ImageFullPath"];
                NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
                NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                _imagePathText = string1;
                
                
                detailView.detailModal = @[_categoryText, _imagePathText,_nameEnText,_nameCnText,_priceText];
                detailView.allModal = technicalResults;
                detailView.lastIndexPath = indexPath;
                
            }
            
            
            
            if (indexPath.section == 6) {
                
                NSPredicate *glazePredicate = [NSPredicate predicateWithFormat:@"Category CONTAINS %@", @"Glaze"];
                NSArray *glazeResults = [marrXMLData filteredArrayUsingPredicate:glazePredicate];
                
                
                static NSString *cellIdentifier = @"Cell";
                UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                if (cell==nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                
                _categoryText = [[[glazeResults objectAtIndex:indexPath.row]valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                _nameEnText = [[[glazeResults objectAtIndex:indexPath.row]valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                _nameCnText = [[[glazeResults objectAtIndex:indexPath.row]valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                _priceText = [[[glazeResults objectAtIndex:indexPath.row]valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
                
                NSString *path = [[glazeResults objectAtIndex:indexPath.row]valueForKey:@"ImageFullPath"];
                NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
                NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                _imagePathText = string1;
                
                
                detailView.detailModal = @[_categoryText, _imagePathText,_nameEnText,_nameCnText,_priceText];
                
                detailView.allModal = glazeResults;
                detailView.lastIndexPath = indexPath;
            }
        }
        
        
        else {
            //NSLog(@"NameTableViewContrller 's filterResults is : %@",self.fiterResults);
            static NSString *cellIdentifier = @"Cell";
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            //NSLog(@"Filted Results is :%@",self.fiterResults);
            
            _categoryText = [[[_fiterResults objectAtIndex:indexPath.row]valueForKey:@"Category"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            _nameEnText = [[[_fiterResults objectAtIndex:indexPath.row]valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            _nameCnText = [[[_fiterResults objectAtIndex:indexPath.row]valueForKey:@"NameZh"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            _priceText = [[[_fiterResults objectAtIndex:indexPath.row]valueForKey:@"Price"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"PaintImg" ofType:@"bundle"];
            
            NSString *path = [[_fiterResults objectAtIndex:indexPath.row]valueForKey:@"ImageFullPath"];
            NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *filePath = [bundlePath stringByAppendingPathComponent:trimmedPath];
            NSString *trimmedString = [filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *string1 = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            _imagePathText = string1;
            
            
            //detailView.searchResultModal = @[self.categoryText, self.imagePathText,self.nameEnText,self.nameCnText,self.priceText];
            detailView.searchResultModal = _fiterResults;
            //NSLog(@"DetailTableViewController's SearchResultModal is %@",detailView.searchResultModal);
            detailView.lastIndexPath = indexPath;
            detailView.index = indexPath.row;
        }
        
    
        
    }
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return marrXMLData;
//}




#pragma mark - For SearchBar
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    // Filter through the marrXMLData
    [_fiterResults removeAllObjects];
    
    
    
    // 增加判断搜索栏输入是否为英文
    
    NSString *regexChineseCharector = @"[\u4e00-\u9fa5]+";
    NSPredicate *predChinese = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexChineseCharector];
    
    if (![predChinese evaluateWithObject:_searchController.searchBar.text]) {

        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"NameEn CONTAINS[cd] %@", [_searchController.searchBar.text lowercaseString]];
        _fiterResults = [[marrXMLData filteredArrayUsingPredicate:searchPredicate] mutableCopy];
        NSLog(@"Search filterResults : %@ ", self.fiterResults);
    }
    else {
        //NSLog(@"必须输入英文！");
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"NameZh CONTAINS[cd] %@",_searchController.searchBar.text];
        _fiterResults = [[marrXMLData filteredArrayUsingPredicate:searchPredicate]mutableCopy];
        NSLog(@"Search filterResults : %@ ",self.fiterResults);

        
        
    }
    
  
    // Update the results TableView
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];  //此处要注意用 tableView 而不是 resultController.tableview。不然会搜索无结果
    });
    
    
    
    
    
//    if (self.searchText)
//    {
//        
//        //NSLog(@"filter Category is %@",cell.textLabel.text);
//
//    }
    


    
//    
//        if ([[[marrXMLData objectAtIndex:indexPath.row]valueForKey:@"NameEn"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].lowercaseString.containsString ]){
//            return true;
//        }
//        else
//        {
//            return false;
//            
//        }
//    }
    

    
    
    
    
    
    
    
    
}


@end
