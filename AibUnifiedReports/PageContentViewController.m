//
//  PageContentViewController.m
//  AibUnifiedReports
//
//  Created by John Stone on 6/30/15.
//  Copyright (c) 2015 John Stone. All rights reserved.
//
#import "PageContentViewController.h"
#import "RDVExampleViewController.h"
#import "PPSSignatureView.h"
#import "SIgnPadViewController.h"
#import "preventiveMeasureViewController.h"
#import "TimeViewController.h"

@interface PageContentViewController ()
@property NSArray *checkControlArray;

@end

@implementation PageContentViewController
@synthesize preventiveMeasure;
@synthesize reportAvail;


-(NSString *) timeLabelTextFromInt:(NSInteger)tmpFirstCheck{
    
    NSString *timeString;
    
    if (tmpFirstCheck < 12){
       timeString = [NSString stringWithFormat:@"%d AM",(int) tmpFirstCheck];
    }else if (tmpFirstCheck == 12){
        timeString = [NSString stringWithFormat:@"%d Noon",(int) tmpFirstCheck];
    } else if(tmpFirstCheck ==24) {
        tmpFirstCheck -= 12;
        timeString = [NSString stringWithFormat:@"%d Midnight",(int) tmpFirstCheck];
        
    }else {
        tmpFirstCheck -= 12;
        timeString = [NSString stringWithFormat:@"%d PM",(int) tmpFirstCheck];
    }
    
    
    
    return timeString;
}
- (void)viewWillDisappear:(BOOL)animated{
    
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
   
  // Can this be delted?
    self.checkControlArray  = [NSArray arrayWithObjects:
                               @"employeeHygieneFirstCheck",
                               @"employeeHygieneSecondCheck",
                               @"materialHandlingFirstCheck",
                               @"materialHandlingSecondCheck",
                               @"polyContactSurfacesFirstCheck",
                               @"polyContactSurfacesSecondCheck",
                               @"overheadAndTrashFirstCheck",
                               @"overheadAndTrashSecondCheck",
                               nil];
    
    
    NSArray  *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *filename = [NSString stringWithFormat:@"%@-Def-times",self.reportName ];
    
    NSString *directoryPath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:filename]];
    NSArray *passedArray = [NSArray arrayWithContentsOfFile:directoryPath   ];
    self.fistCheckValue =[[passedArray objectAtIndex:0] integerValue];
    self.secondCheckValue =[[passedArray objectAtIndex:1]integerValue];
    
    filename = [NSString stringWithFormat:@"signature-%@-%@",self.reportName  , [self.dateText substringToIndex:10]];
    
    directoryPath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:filename]];
   UIImage *signImage = [UIImage imageWithContentsOfFile:directoryPath ];
  [self.signaturePad setImage:signImage];
    
    
    //NSArray  *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *docsDir = [dirPaths objectAtIndex:0];
    filename = [NSString stringWithFormat:@"text-%@-%@",self.reportName  , [self.dateText substringToIndex:10]];
    
    directoryPath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:filename]];
    NSArray * retrivedData = [NSMutableArray arrayWithContentsOfFile:directoryPath];
    if (retrivedData.count > 1){
    self.correctiveAction.text = [retrivedData objectAtIndex:0];
    self.preventiveMeasure.text = [ retrivedData objectAtIndex:1];
    }
 // switch states
    filename = [NSString stringWithFormat:@"switchState-%@-%@",self.reportName  , [self.dateText substringToIndex:10]];
    
    directoryPath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:filename]];
    NSArray * retrivedSwitchState = [NSMutableArray arrayWithContentsOfFile:directoryPath];
    NSString * switchState =  [retrivedSwitchState objectAtIndex:0];
    if (switchState.integerValue & 1<<0){ self.ehFirstCheck.on = NO;};
    if (switchState.integerValue & 1<<1){ self.ehSecondCheck.on = NO;};
    if (switchState.integerValue & 1<<2){ self.mhFirstCheck.on = NO;};
    if (switchState.integerValue & 1<<3){ self.mhSecondCheck.on = NO;};
    if (switchState.integerValue & 1<<4){ self.pcFirstCheck.on = NO;};
    if (switchState.integerValue & 1<<5){ self.pcSecondCheck.on = NO;};
    if (switchState.integerValue & 1<<6){ self.ohFirstCheck.on = NO;};
    if (switchState.integerValue & 1<<7){ self.ohSecondCheck.on = NO;};
    
    
    
    
    
    NSString *defHour = [passedArray objectAtIndex:0];
    self.firstCheckTime.text = [self timeLabelTextFromInt:defHour.integerValue ];
    NSString *defSecondHour = [passedArray objectAtIndex:1];
    self.secondCheckTime.text = [self timeLabelTextFromInt:defSecondHour.integerValue ];
    self.reportHeading.text = self.reportTitleText;
    self.shiftLabel.text = self.reportShift;
    
    self.backgroundImageView.image = self.imageFile;
    [[self dateLabel]   setText: [self.dateText substringToIndex:10 ]] ;
    
    if (self.reportAvail){
        //[[self correctiveAction]   setText:@"**** Debug marker ****"];
        
      //  [[self reportHeading]      setHidden:YES];
     //   [[self dateLabel]          setHidden:YES];
     //   [[self dateHeading]        setHidden:YES];
    //    [[self shiftHeading]       setHidden:YES];
   //     [[self shiftLabel]         setHidden:YES];
   //     [[self firstCheckHeading]  setHidden:YES];
      //    [[self firstCheckTime]     setHidden:YES];
    //    [[self secondCheckHeading] setHidden:YES];
        //  [[self secondCheckTime]    setHidden:YES];
 //       [[self correctiveAction]   setHidden:YES];
 //       [[self preventiveMeasure]  setHidden:YES];
//        [[self ehFirstCheck]       setHidden:YES];
//        [[self ehSecondCheck]      setHidden:YES];
//        [[self mhFirstCheck]       setHidden:YES];
//        [[self mhSecondCheck]      setHidden:YES];
//        [[self pcFirstCheck]       setHidden:YES];
//        [[self pcSecondCheck]      setHidden:YES];
//        [[self ohFirstCheck]       setHidden:YES];
//        [[self ohSecondCheck]      setHidden:YES];
//        [[self ehFirstLabel]       setHidden:YES];
//        [[self ehSecondLabel]      setHidden:YES];
//        [[self mhFirstLabel]       setHidden:YES];
//        [[self mhSecondLabel]      setHidden:YES];
//        [[self pcFirstLabel]       setHidden:YES];
//        [[self pcSecondLabel]      setHidden:YES];
//        [[self ohFirstLabel]       setHidden:YES];
//        [[self ohSecondLabel]     setHidden:YES];
//        
        [[self doneButton]         setHidden:YES];
        
        
    }else{
        
        [[self doneButton] setTitle: @"SIGN" forState:UIControlStateNormal];
        
    }
    
}
- (int) getSwitchState {
    int val=0;
    if (![[self ehFirstCheck]  isOn]) {val = val +1;}
    if (![[self ehSecondCheck]  isOn]) {val = val +2;}
    if (![[self mhFirstCheck]  isOn]) {val = val +4;}
    if (![[self mhSecondCheck]  isOn]) {val = val +8;}
    if (![[self pcFirstCheck]  isOn]) {val = val +16;}
    if (![[self pcSecondCheck]  isOn]) {val = val +32;}
    if (![[self ohFirstCheck]  isOn]) {val = val +64;}
    if (![[self ohSecondCheck]  isOn]) {val = val +128;}
    
    
    return val;
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"checkTimeSegue"]){
        TimeViewController *myvc = [segue destinationViewController];
        myvc.reportName = self.reportName;
        myvc.firstCheckValue =self.fistCheckValue   ;
        myvc.secondCheckValue = self.secondCheckValue ;
        
        
        
    }
    
    if ([segue.identifier isEqualToString:@"datePopover"]){
        
        NSDateFormatter *tempFormatter1 = [[NSDateFormatter alloc]init];
        [tempFormatter1 setDateFormat:@"yyyy-MM-dd"];
        NSDate *sentDate = [tempFormatter1 dateFromString:[self.dateLabel.text substringToIndex:10]];
        
        RDVExampleViewController *myvc = segue.destinationViewController;
        myvc.mySelectedDate = sentDate;
        
    }
    
    if ([segue.identifier isEqualToString:@"signaturepopover"] ){

        NSDateFormatter *tempFormatter1 = [[NSDateFormatter alloc]init];
        [tempFormatter1 setDateFormat:@"yyyy-MM-dd"];
        NSDate *sentDate = [tempFormatter1 dateFromString:[self.dateLabel.text substringToIndex:10]];
        SIgnPadViewController *myvc = segue.destinationViewController;
        myvc.signDate = sentDate;
        [[self doneButton] setHidden:NO];
        
    }
    if ([segue.identifier isEqualToString:@"showEditBox"]){
        preventiveMeasureViewController *myvc = segue.destinationViewController;
        myvc.reportName = self.reportName;
        myvc.dateText   = self.dateLabel.text;
        
    }
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"showEditBox"]){
        // preventiveMeasureViewController *myvc = segue.destinationViewController;
        if([sender isKindOfClass:[UISwitch class]]){
            NSLog(@"%@",sender);
            if ([sender isOn]){
                return NO;
            }else{
                return YES;
            }
        }
    }
    return YES;
}

- (IBAction)showPreventiveMeasure:(id)sender {
    int switchSate = [self getSwitchState];
    NSArray  *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *filename = [NSString stringWithFormat:@"switchState-%@-%@",self.reportName  ,self.dateLabel.text];
    
    NSString *directoryPath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:filename]];
    NSArray *passedArray = [NSArray arrayWithObject:[NSString stringWithFormat:@"%ld",(long)switchSate]];
    [passedArray writeToFile:directoryPath atomically:YES];
    

  
    if([sender isKindOfClass:[UISwitch class]]){
        NSLog(@"%@",sender);
        if ([sender isOn]){
           // return NO;
        }else{
            [self performSegueWithIdentifier:@"showEditBox" sender:sender];
        }
    }
    
}

@end
