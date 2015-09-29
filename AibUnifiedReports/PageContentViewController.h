//
//  PageContentViewController.h
//  AibUnifiedReports
//
//  Created by John Stone on 6/30/15.
//  Copyright (c) 2015 John Stone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *ehFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *ehSecondLabel;
@property (weak, nonatomic) IBOutlet UILabel *mhFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *mhSecondLabel;
@property (weak, nonatomic) IBOutlet UILabel *pcFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *pcSecondLabel;
@property (weak, nonatomic) IBOutlet UILabel *ohFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *ohSecondLabel;

@property (weak, nonatomic) IBOutlet UISwitch *ehFirstCheck;
@property (weak, nonatomic) IBOutlet UISwitch *ehSecondCheck;
@property (weak, nonatomic) IBOutlet UISwitch *mhFirstCheck;
@property (weak, nonatomic) IBOutlet UISwitch *mhSecondCheck;
@property (weak, nonatomic) IBOutlet UISwitch *pcFirstCheck;
@property (weak, nonatomic) IBOutlet UISwitch *pcSecondCheck;
@property (weak, nonatomic) IBOutlet UISwitch *ohFirstCheck;
@property (weak, nonatomic) IBOutlet UISwitch *ohSecondCheck;

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
@property (weak, nonatomic) IBOutlet UISwitch *employ;
@property (weak, nonatomic) IBOutlet UITextView *correctiveAction;
@property (weak, nonatomic) IBOutlet UITextView *preventiveMeasure;
- (IBAction)showPreventiveMeasure:(id)sender;
- (IBAction)show2:(id)sender;
@property NSString *reportName;
@property NSString *reportTitleText;
@property NSString *reportShift;
@property (nonatomic) bool reportAvail;
@property NSUInteger pageIndex;
@property NSString *dateText;
@property UIImage *imageFile;
@property (nonatomic)NSInteger  fistCheckValue;
@property (nonatomic)NSInteger  secondCheckValue;

@end
