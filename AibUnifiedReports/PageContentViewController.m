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

@interface PageContentViewController ()

@end

@implementation PageContentViewController

@synthesize reportAvail;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backgroundImageView.image = self.imageFile;
    [[self dateLabel]   setText: [self.titleText substringToIndex:10 ]] ;
    
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
        [[self doneButton]         setHidden:YES];
    
    }else{
        
        [[self doneButton] setTitle: @"SIGN" forState:UIControlStateNormal];
    
    }
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
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
}

@end
