//
//  PageContentViewController.h
//  AibUnifiedReports
//
//  Created by John Stone on 6/30/15.
//  Copyright (c) 2015 John Stone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *reportHeading;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateHeading;
@property (weak, nonatomic) IBOutlet UILabel *shiftHeading;
@property (weak, nonatomic) IBOutlet UILabel *shiftLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstCheckHeading;
@property (weak, nonatomic) IBOutlet UILabel *secondCheckHeading;
@property (weak, nonatomic) IBOutlet UILabel *firstCheckTime;
@property (weak, nonatomic) IBOutlet UILabel *secondCheckTime;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (nonatomic) bool reportAvail;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property UIImage *imageFile;
@end
