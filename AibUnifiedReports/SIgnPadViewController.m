//
//  SIgnPadViewController.m
//  AibUnifiedReports
//
//  Created by John Stone on 7/18/15.
//  Copyright (c) 2015 John Stone. All rights reserved.
//

#import "SIgnPadViewController.h"
#import "PPSSignatureView.h"
#import "OperationsViewController.h"

@interface SIgnPadViewController ()

@end

@implementation SIgnPadViewController

@synthesize signPad;

- (void)viewWillDisappear:(BOOL)animated    {
    
    if ([[self signPad] hasSignature]){
        
        NSArray * passArray = [NSArray arrayWithObjects: [[self signPad]signatureImage], [self signDate], nil];
        [self.presentingViewController performSelector:@selector(saveReport:) withObject:passArray ];
    
    }
}

-(void) viewWillAppear:(BOOL)animated   {
    
    self.preferredContentSize = CGSizeMake(420.00, 160.0);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.]
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
