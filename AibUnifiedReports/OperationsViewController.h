//
//  OperationsViewController.h
//  AibUnifiedReports
//
//  Created by John Stone on 6/27/15.
//  Copyright (c) 2015 John Stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface OperationsViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray  *workDates;
@property (strong, nonatomic) NSArray  *pageImages;
@property (strong,nonatomic ) NSString *reportName;
@property (strong,nonatomic ) NSString *reportTitle;

- (void) saveReport:(NSArray *)passedArray;

- (void) newDateSelected:(id )sentDate;

@end
