//
//  TimeViewController.m
//  AibUnifiedReports
//
//  Created by John Stone on 7/25/15.
//  Copyright (c) 2015 John Stone. All rights reserved.
//

#import "TimeViewController.h"
#import "OperationsViewController.h"


@interface TimeViewController ()

@end

@implementation TimeViewController
@synthesize firstCheckSpinner;
@synthesize secondCheckSpinner;


- (void) setTimeDefualts:(NSArray *)passedArray{
    
    NSArray  *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *filename = [NSString stringWithFormat:@"%@-Def-times",self.reportName ];
    
    NSString *directoryPath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:filename]];
    //NSData *data = UIImagePNGRepresentation(image);
    
    bool test=  [passedArray writeToFile:directoryPath atomically:YES ];
    
    
}

- (void)viewWillDisappear:(BOOL)animated    {
    if (self.defTime.isOn){
        NSString *firstCheck = [NSString stringWithFormat:@"%f",self.firstCheckSpinner.value];
        NSString *secondCheck = [NSString stringWithFormat:@"%f",self.secondCheckSpinner.value];
        
        NSArray * timeArray = [NSArray arrayWithObjects:firstCheck ,secondCheck, nil];
        
        [self setTimeDefualts:timeArray];
    }
    
    NSArray * passArray = [NSArray arrayWithObjects: self.firstCheckTime.text,self.secondCheckTime.text  , nil];
    
    [self.presentingViewController performSelector:@selector(setCheckTime:) withObject:passArray ];
    
    
}

-(void) viewWillAppear:(BOOL)animated   {
    
    self.preferredContentSize = CGSizeMake(250.00, 200.0);
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 //   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  //  NSString *defHour = [defaults objectForKey:@"defualtFirstCheck"];
//    self.firstCheckSpinner.value = defHour.integerValue;
//    NSString *defSecondHour = [defaults objectForKey:@"defualtSecondCheck"];
//self.secondCheckSpinner.value = defSecondHour.integerValue;
    self.firstCheckSpinner.value = self.firstCheckValue;
    self.secondCheckSpinner.value = self.secondCheckValue;
    [self timeCheckClick:nil];
    
}

- (IBAction)timeCheckClick:(id)sender {
    
    int tmpFirstCheck =  self.firstCheckSpinner.value;
    if (tmpFirstCheck < 12){
        self.firstCheckTime.text = [NSString stringWithFormat:@"%d AM",(int) tmpFirstCheck];
    }else if (tmpFirstCheck == 12){
        self.firstCheckTime.text = [NSString stringWithFormat:@"%d Noon",(int) tmpFirstCheck];
    } else if(tmpFirstCheck ==24) {
        tmpFirstCheck -= 12;
        self.firstCheckTime.text = [NSString stringWithFormat:@"%d Midnight",(int) tmpFirstCheck];
        
    }else {
        tmpFirstCheck -= 12;
        self.firstCheckTime.text = [NSString stringWithFormat:@"%d PM",(int) tmpFirstCheck];
    }
    
    int tmpSecondCheck =  self.secondCheckSpinner.value;
    if (tmpSecondCheck <12){
        self.secondCheckTime.text = [NSString stringWithFormat:@"%d AM",(int) tmpSecondCheck];
    }else if (tmpSecondCheck == 12 ){
        
        self.secondCheckTime.text = [NSString stringWithFormat:@"%d Noon",(int) tmpSecondCheck];
    }else if(tmpSecondCheck == 24){
        tmpSecondCheck -= 12;
        self.secondCheckTime.text = [NSString stringWithFormat:@"%d Midnight",(int) tmpSecondCheck];
        
    }else {
        tmpSecondCheck -= 12;
        
        self.secondCheckTime.text = [NSString stringWithFormat:@"%d PM",(int) tmpSecondCheck];
        
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
