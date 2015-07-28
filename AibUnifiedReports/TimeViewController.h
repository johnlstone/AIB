//
//  TimeViewController.h
//  AibUnifiedReports
//
//  Created by John Stone on 7/25/15.
//  Copyright (c) 2015 John Stone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *firstCheckTime;
@property (weak, nonatomic) IBOutlet UIStepper *firstCheckSpinner;
@property (weak, nonatomic) IBOutlet UITextField *secondCheckTime;
@property (weak, nonatomic) IBOutlet UIStepper *secondCheckSpinner;
@property (weak, nonatomic) IBOutlet UISwitch *defTime;
@property   (weak,nonatomic) NSString * reportName;
@property NSInteger firstCheckValue;
@property NSInteger secondCheckValue;



@end
