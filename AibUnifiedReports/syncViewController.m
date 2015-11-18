//
//  syncViewController.m
//  AibUnifiedReports
//
//  Created by John Stone on 7/4/15.
//  Copyright (c) 2015 John Stone. All rights reserved.
//

#import "syncViewController.h"
@import CloudKit;
@interface syncViewController ()

@end

@implementation syncViewController
@synthesize workDates;


-(void)retriveWorkDates{
    
    CKContainer *defaultContainer = [CKContainer defaultContainer];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    CKDatabase *publicDatabase = [defaultContainer publicCloudDatabase];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"workDays" predicate:predicate];
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        if (!error) {
            workDates = [[results objectAtIndex:0] objectForKey:@"workDates"];
            NSLog(@"%@", workDates);
            NSLog(@"%@",@"retriveWorkDates completionHandler returns with !error");
            
            
        } else {
            NSLog(@"%@", error);
            NSLog(@"%@",@"retriveWorkDates completionHandler returns with  errorS");
            
        }
               
[self performSegueWithIdentifier:@"main" sender:self];
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self retriveWorkDates];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController respondsToSelector:@selector(setWorkDates:)]) {
        [segue.destinationViewController performSelector:@selector(setWorkDates:)
                                              withObject:workDates];
    }
}


@end
