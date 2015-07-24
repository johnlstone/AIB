//
//  RDVExampleViewController.h
//  RDVCalendarView
//
//  Created by Robert Dimitrov on 11/1/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import "RDVCalendarViewController.h"

@interface RDVExampleViewController : RDVCalendarViewController
@property (nonatomic, retain) IBOutlet UIView *myNewVC;
@property (nonatomic,strong) NSArray *signDates;
@property  (nonatomic,strong)NSArray *holidayDates;
@property (nonatomic,strong) NSDate *mySelectedDate;
@property (nonatomic, strong) NSDate *lastKnownSelectedDate;


@end
