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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSArray  *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *filename = [NSString stringWithFormat:@"%@-Def-times",self.reportName ];
    
    NSString *directoryPath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:filename]];
    //NSData *data = UIImagePNGRepresentation(image);
    //[passedArray writeToFile:directoryPath atomically:YES];
    NSArray *passedArray = [NSArray arrayWithContentsOfFile:directoryPath   ];
    self.fistCheckValue =[[passedArray objectAtIndex:0] integerValue];
    self.secondCheckValue =[[passedArray objectAtIndex:1]integerValue];
    
    
    
    NSString *defHour = [passedArray objectAtIndex:0];
    self.firstCheckTime.text = [self timeLabelTextFromInt:defHour.integerValue ];
    NSString *defSecondHour = [passedArray objectAtIndex:1];
    self.secondCheckTime.text = [self timeLabelTextFromInt:defSecondHour.integerValue ];
    self.reportHeading.text = self.reportTitleText;
    self.shiftLabel.text = self.reportShift;
    
    self.backgroundImageView.image = self.imageFile;
    [[self dateLabel]   setText: [self.dateText substringToIndex:10 ]] ;
    
    if (self.reportAvail){
        
        [[self reportHeading]      setHidden:YES];
        [[self dateLabel]          setHidden:YES];
        [[self dateHeading]        setHidden:YES];
        [[self shiftHeading]       setHidden:YES];
        [[self shiftLabel]         setHidden:YES];
        [[self firstCheckHeading]  setHidden:YES];
        [[self firstCheckTime]     setHidden:YES];
        [[self secondCheckHeading] setHidden:YES];
        [[self secondCheckTime]    setHidden:YES];
        [[self correctiveAction]   setHidden:YES];
        [[self preventiveMeasure]  setHidden:YES];
        
        [[self doneButton]         setHidden:YES];
    
    }else{
        
        [[self doneButton] setTitle: @"SIGN" forState:UIControlStateNormal];
    
    }
    
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
        
        NSLog(@"%@",sender);
    }
    
    
    return YES;
}

- (IBAction)showPreventiveMeasure:(id)sender {
   // [preventiveMeasure becomeFirstResponder];
}

- (IBAction)show2:(id)sender {
    
    
}
@end
