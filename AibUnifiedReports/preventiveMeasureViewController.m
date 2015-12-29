//
//  preventiveMeasureViewController.m
//  AibUnifiedReports
//
//  Created by John Stone on 7/27/15.
//  Copyright (c) 2015 John Stone. All rights reserved.
//
#import "OperationsViewController.h"
#import "preventiveMeasureViewController.h"

@interface preventiveMeasureViewController ()

@end

@implementation preventiveMeasureViewController
@synthesize preventiveMeasure;
@synthesize correctiveAction;



- (void) viewWillDisappear:(BOOL)animated {
    
        NSArray * passArray = [NSArray arrayWithObjects: self.correctiveAction.text,self.preventiveMeasure.text    , nil];
    
    
    [self.presentingViewController performSelector:@selector(setEditBoxes:) withObject:passArray ];
    

    
}
- (void) viewWillAppear:(BOOL)animated   {
    
    self.preferredContentSize = CGSizeMake(650.00, 350.0);
    
    NSArray  *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *filename = [NSString stringWithFormat:@"text-%@-%@",self.reportName  , self.dateText];
    
    NSString *directoryPath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:filename]];
    NSArray * retrivedData = [NSMutableArray arrayWithContentsOfFile:directoryPath];
   
    if (retrivedData.count>1) {
        
    
    self.correctiveAction.text = [retrivedData objectAtIndex:0];
    self.preventiveMeasure.text = [ retrivedData objectAtIndex:1];
    }
    
    
    //NSData *data = UIImagePNGRepresentation(image);
 //   [passedArray writeToFile:directoryPath atomically:YES];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [correctiveAction becomeFirstResponder];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dimiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
