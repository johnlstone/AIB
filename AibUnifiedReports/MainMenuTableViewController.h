//
//  MainMenuTableViewController.h
//  AibUnifiedReports
//
//  Created by John Stone on 6/26/15.
//  Copyright (c) 2015 John Stone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate >;

@property (nonatomic, strong) NSMutableArray *reportType;
@property (nonatomic, strong) NSMutableArray *reportsData;
@property (nonatomic, strong) NSMutableArray *responsibleData;
@property (nonatomic, strong) NSMutableArray *reportNames;
@property (nonatomic, strong) NSMutableArray *reportTitles;

@property (nonatomic, strong) NSMutableArray *adminEntries;
@property (strong, nonatomic) NSArray *workDates;
@property (strong,nonatomic) NSString *reportName;

@property (strong,nonatomic) NSString *reportTitle;

@end
