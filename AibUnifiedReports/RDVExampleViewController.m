// RDVExampleViewController.m
// RDVCalendarView
//
// Copyright (c) 2013 Robert Dimitrov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RDVExampleViewController.h"
#import "RDVExampleDayCell.h"
#import "OperationsViewController.h"

@interface RDVExampleViewController ()
@property (nonatomic) NSString *currentYear;

@end

@implementation RDVExampleViewController

@synthesize myNewVC;
@synthesize signDates = _signDates;
@synthesize holidayDates = _holidayDates;
@synthesize mySelectedDate;
@synthesize lastKnownSelectedDate;

-(NSArray *)getHolidays{
    NSMutableArray *dateArray = [[NSMutableArray alloc]init] ;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *urlRoot = [defaults objectForKey:@"url_preference"];
    NSString *str= [NSString stringWithFormat: @"%@BagRoomAm/getHolidaysJson.php",urlRoot];
    

    NSURL *url=[NSURL URLWithString:str];
    
    NSData *data=[NSData dataWithContentsOfURL:url];
    
    NSError *error=nil;
    if(data){
        id response=[NSJSONSerialization JSONObjectWithData:data options:
                 NSJSONReadingMutableContainers error:&error];
    
   //  NSLog(@"Your JSON Object: %@ ", response);
    
    for (NSDictionary *itemDict in response)
    {
        NSString *tempDate = (NSString*)[itemDict objectForKey:@"date"];
        
        [dateArray addObject:tempDate ];
    }
    return dateArray;
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet connection"
                                                        message:@"Go to Settings to enable wifi."
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    return Nil;
    
}

-(NSArray *)getDates{
    NSMutableArray *dateArray = [[NSMutableArray alloc]init] ;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *urlRoot = [defaults objectForKey:@"url_preference"];
    NSString *str= [NSString stringWithFormat: @"%@BagRoomAm/getDatesJson.php",urlRoot];
    

       
    NSURL *url=[NSURL URLWithString:str];
    
    NSData *data=[NSData dataWithContentsOfURL:url];
    
    NSError *error=nil;
    if(data){
    id response=[NSJSONSerialization JSONObjectWithData:data options:
                 NSJSONReadingMutableContainers error:&error];
       // NSLog(@"Your JSON Object: %@ ", response);
    
    for (NSDictionary *itemDict in response)
    {
        NSString *tempDate = (NSString*)[itemDict objectForKey:@"checkDate"];
        
        [dateArray addObject:tempDate ];
    }
        
    return dateArray;
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No active network connection."
                                                        message:@"Go to Settings to enable wifi.."
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
        [alert show];

    }
    return Nil;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:false];
    [[self calendarView] setCurrentDayColor: [UIColor colorWithRed:(41.0/255.0) green:(128.0/255.0) blue:(185.0/255.0) alpha:1.0]];
    [[self calendarView] setSelectedDayColor: [UIColor colorWithRed:(41.0/255.0) green:(128.0/255.0) blue:(185.0/255.0) alpha:1.0]];
    //[self calendarView  didSelectDate:[NSDate ]];
    
//    NSDateFormatter * formater=[[NSDateFormatter alloc]init];
//    [formater setDateFormat:@"yyyy-MM-dd"];
//    
//    NSDate *earlier = [formater dateFromString:@"2015-02-02"];
//    
//    NSLog(@"formater:%@",earlier);
    lastKnownSelectedDate = mySelectedDate;
    
    
    [[self calendarView] setSelectedDate:mySelectedDate];
    [[self calendarView ]reloadData  ];
    
   // self.signDates =[self getDates];  //  NSArray *signDates = [self getDates];
   // self.holidayDates =[self getHolidays];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [[self.navigationController navigationBar] setTranslucent:NO];
    
    [[self calendarView] registerDayCellClass:[RDVExampleDayCell class]];
    
    UIBarButtonItem *todayButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Today", nil)
                style:UIBarButtonItemStylePlain
               target:[self calendarView]
               action:@selector(showCurrentMonth)];
    [self.navigationItem setRightBarButtonItem:todayButton];
    
    [self.navigationItem setTitle:@"Bag Room First Shift"];
    NSDate *currDate = [[self calendarView] dateForIndex:0 ];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currDate]; // Get necessary date components
    
       self.currentYear = [NSString stringWithFormat:@"%ld",(long)[components year] ] ;
                         
    
}

-(void)calendarView:(RDVCalendarView *)calendarView didSelectDate:(NSDate *)date {
    

  [self.presentingViewController performSelector:@selector(newDateSelected:) withObject:date   ];
    
    //[self dismissPopoverAnimated:YES];
 //    [self performSegueWithIdentifier:@"goSign" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
      // ReportViewController *myvc = segue.destinationViewController;
    
  //  myvc.passedReportDate = self.calendarView.selectedDate;
    
}

-(void)calendarView:(RDVCalendarView *)calendarView configureDayCell:(RDVCalendarDayCell *)dayCell
            atIndex:(NSInteger)index {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *checkDate = [dateFormatter stringFromDate:[calendarView dateForIndex:index]];
    
    bool dayHit = [self.signDates containsObject:checkDate];
    BOOL holidayHit = [self.holidayDates containsObject:checkDate];
    
    RDVExampleDayCell *exampleDayCell = (RDVExampleDayCell *)dayCell;
    
    if (dayHit) {
        [[exampleDayCell notificationView] setBackgroundColor:[UIColor clearColor]];
        [[exampleDayCell notificationView] setHidden:NO];
    }
    if (holidayHit) {
        [[exampleDayCell notificationView] setBackgroundColor:[UIColor colorWithRed:0.251  green:0.251  blue:0.251 alpha:1]];
        [[exampleDayCell notificationView] setHidden:NO];
//       UIView *mtempp =  [[exampleDayCell notificationView] viewWithTag:0];
//        UIImageView * holidayView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greenButton.png"]];
//        [holidayView setFrame:CGRectMake(7.0, 7.0, 90.0, 90.0) ];
//        [mtempp addSubview:holidayView  ];
//        
       
        
    }
}

@end
