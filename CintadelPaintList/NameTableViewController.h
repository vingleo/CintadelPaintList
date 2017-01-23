//
//  NameTableViewController.h
//  CintadelPaintList
//
//  Created by vingleo on 16/1/25.
//  Copyright © 2016年 Vingleo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NameTableViewController : UITableViewController<NSXMLParserDelegate,UISearchResultsUpdating, UISearchControllerDelegate>

@property(nonatomic,strong)NSMutableDictionary *dictData;
@property(nonatomic,strong)NSMutableArray *marrXMLData;
@property(nonatomic,strong)NSMutableString *mstrXMLString;
@property(nonatomic,strong)NSMutableDictionary *mdictXMLPart;

@property(nonatomic,strong)NSArray *baseResults;
@property(nonatomic,strong)NSArray *dryResults;
@property(nonatomic,strong)NSArray *glazeResults;
@property(nonatomic,strong)NSArray *layerResults;
@property(nonatomic,strong)NSArray *shadeResults;
@property(nonatomic,strong)NSArray *technicalResults;
@property(nonatomic,strong)NSArray *textureResults;


@property(nonatomic,strong)NSString *categoryText;
@property(nonatomic,strong)NSString *nameEnText;
@property(nonatomic,strong)NSString *nameCnText;
@property(nonatomic,strong)NSString *imagePathText;
@property(nonatomic,strong)NSString *priceText;


//For SearchBar
@property(nonatomic,strong) UISearchController *searchController;
@property(nonatomic,strong) UITableViewController *resultController;
@property(nonatomic,strong) NSMutableArray *fiterResults;
@property(nonatomic,strong) NSMutableArray *searchResults;
@property(nonatomic,strong) NSString *searchText;

@end
