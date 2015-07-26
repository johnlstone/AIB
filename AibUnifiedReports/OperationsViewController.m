//
//  OperationsViewController.m
//  AibUnifiedReports
//
//  Created by John Stone on 6/27/15.
//  Copyright (c) 2015 John Stone. All rights reserved.
//

#import "OperationsViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "PageContentViewController.h"

@import CloudKit;

@interface OperationsViewController ()

@end

@implementation OperationsViewController

@synthesize reportName;
@synthesize reportTitle;
@synthesize reportShift;


- (NSMutableArray *) simplifyWorkDates {
    NSMutableArray *simpleWorkDates = [[NSMutableArray alloc]init] ;
    NSString * simpleString;
    
    for (NSDate *date  in  _workDates){
        
        simpleString = [[NSString stringWithFormat:@"%@",date]substringToIndex:10] ;
        [simpleWorkDates addObject:simpleString];
        
    }
    
    return simpleWorkDates;
}

#pragma mark - Display report

- (void) newDateSelected:(id )sentDate {
    
    NSMutableArray *simpleDates = [self simplifyWorkDates];
    NSString * simpleSentDate = [[NSString stringWithFormat:@"%@",sentDate] substringToIndex:10];
    NSUInteger indexOfTheObject = [simpleDates indexOfObject: simpleSentDate];
    
    if (indexOfTheObject == NSNotFound){
        
        NSLog(@"ERROR not found");
        AudioServicesPlayAlertSound (1005);
        
    }else{
        
        AudioServicesPlayAlertSound (1105);
        [self flipToPage:[NSString stringWithFormat:@"%ld",indexOfTheObject] ];
        
    }
}

- (void) flipToPage:(NSString * )index {
    
    int indexIntValue = [index intValue];
    PageContentViewController *firstViewController = [self viewControllerAtIndex:indexIntValue];
    NSArray *viewControllers = [NSArray arrayWithObjects:firstViewController, nil];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
}

- (UIImage *) getReportImageForDate:(NSString *)date {
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *filename = [NSString stringWithFormat:@"%@-%@",reportName,[date substringToIndex:10]];
    NSString *directoryPath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:filename]];
    UIImage * image = [UIImage imageWithContentsOfFile:directoryPath];
    
    return image;
    
}


#pragma mark - Render and save report
- (void) setCheckTime:(NSArray *)passedArray{
    
    PageContentViewController * pageController = [[[[self childViewControllers] firstObject ]childViewControllers]firstObject];
    
    pageController.firstCheckTime.text = [passedArray firstObject];
    pageController.secondCheckTime.text = [passedArray objectAtIndex:1];
    
}

- (void) saveReport:(NSArray *)passedArray{
    
    // passed array format is @[signatureImage,date,nil];
    // UIImage *signImage = [passedArray objectAtIndex:0];
    
    // Remove Time Portion of NSDate for simple index search. returns "yyyy-MM-dd".
    NSDate  *sentDate  = [passedArray objectAtIndex:1];
    NSMutableArray *simpleDates = [self simplifyWorkDates];
    NSString * simpleSentDate   = [[NSString stringWithFormat:@"%@",sentDate] substringToIndex:10];
    NSUInteger indexOfTheObject = [simpleDates indexOfObject: simpleSentDate];
    
    // Call to Generate actual report PNG (ex. BagRoomAm-2015-07-01.png) and save to file system.
    [self generateReportForDay:passedArray];
    
    [self flipToPage :[NSString stringWithFormat:@"%ld",indexOfTheObject+1] ];
}

- (void) generateReportForDay:(NSArray *)passedArray{
    
    PageContentViewController * pageController = [[[[self childViewControllers] firstObject ]childViewControllers]firstObject];
    // parse passedArray;
    UIImage  *signatureImage = [passedArray objectAtIndex:0];
    NSString *date      = [[NSString stringWithFormat:@"%@",[passedArray objectAtIndex:1]] substringToIndex:10];
    NSString *dateString;
    NSString *shiftString;
    
    //Begin graphics Context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1275, 1650), NO, 2.0);
    
    // load Defualt Report image as background
    UIImage  *background = [UIImage imageNamed:@"operations.png"];
    [background drawInRect:CGRectMake(0, 0, 1275, 1650) blendMode:kCGBlendModeOverlay alpha:.99f ];
    
    
    //draw report title.
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [UIFont systemFontOfSize:32], NSFontAttributeName,nil];
    [[UIColor blackColor]setStroke];
    [[UIColor blackColor]setFill];
    [reportTitle drawInRect:CGRectIntegral( CGRectMake(225, 30, 900, 300)) withAttributes:dictionary];
    
    //change font szie for rest of report
    [dictionary setObject:[UIFont systemFontOfSize:20] forKey:NSFontAttributeName];
    
    // Draw date and shift in upper left of report
    dateString = [@"Date: " stringByAppendingString :date];
    [dateString     drawInRect:CGRectMake(100, 100, 400, 400)  withAttributes:dictionary];
    
    shiftString = [@"Shift: " stringByAppendingString:reportShift];
    [shiftString drawInRect:CGRectMake(100, 130, 400, 400)  withAttributes:dictionary];
    
    // Draw first and second check time in upper right of report
    
    NSString *firstCheck =  [NSString stringWithFormat:@" First Check: %@", pageController.firstCheckTime.text];
    NSString *secondCheck = [NSString stringWithFormat:@"Second Check: %@", pageController.secondCheckTime.text];
    [firstCheck drawInRect:CGRectMake(1000, 100, 400, 400)  withAttributes:dictionary];
    [secondCheck drawInRect:CGRectMake(975, 130, 400, 400)  withAttributes:dictionary];
    
    // Draw signature in bottom right
    [signatureImage drawInRect:CGRectMake(750,1325, 350, 150) blendMode:kCGBlendModePlusDarker alpha:.99f ];
    
    // gererate report image
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    // generate file name
    NSString * fileName = [NSString stringWithFormat:@"%@-%@.png",reportName,date];
    NSLog(@"Generate Report with name: %@.png",fileName);
    //Wirte image to file system.
    [self writeReportWithFilename:image FileName:fileName];
    [self postReportToCloud:fileName];
    
}

- (void) writeReportWithFilename:(UIImage *)image FileName:(NSString *) name{
    
    NSArray  *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *filename = [NSString stringWithFormat:@"%@",name];
    NSString *directoryPath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:filename]];
    NSData *data = UIImagePNGRepresentation(image);
    
    [data writeToFile:directoryPath atomically:YES];
    
}
- (void) postReportToCloud:(NSString *) file{
    
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docsDir = [dirPaths objectAtIndex:0];
   
    NSString *directoryPath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:file]];
    
    NSURL *url = [[NSURL alloc]initFileURLWithPath:directoryPath];
    
    CKContainer *defaultContainer = [CKContainer containerWithIdentifier:@"iCloud.com.pbok.AibUnifiedReports"];
   
    CKDatabase *publicDatabase = [defaultContainer publicCloudDatabase];
    
    CKAsset *reportI = [[CKAsset alloc ] initWithFileURL:url];
    
    CKRecord *postRecord = [[CKRecord alloc] initWithRecordType:@"ReportImages" ];
   postRecord[@"reportName"] = file;
    //postRecord[@"reportImage"] = reportI;
    [postRecord setObject:reportI forKey:@"reportImage"];
    
    // CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    [publicDatabase saveRecord:postRecord completionHandler:^(CKRecord *record, NSError *error) {
        if(error) {
            NSLog(@"%@", error);
        } else {
            NSLog(@"Saved successfully: %@",record);
        }
    }];
}


- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // _workDates = @[@"06/01/2015", @"06/02/2015", @"06/03/2015", @"06/04/2015"];
    _pageImages = @[@"operations.png",@"operations.png",@"operations.png",@"operations.png"];
    NSMutableArray *simpleDates = [self simplifyWorkDates];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    // [dateFormat setTimeZone:<#(NSTimeZone *)#>]
    [dateFormat setLocale:usLocale];
    NSString *dateString = [dateFormat stringFromDate:today];
    NSString * simpleSentDate = [[NSString stringWithFormat:@"%@",dateString] substringToIndex:10];
    //  NSString * simpleCurrentDate = [[NSString stringWithFormat:@"%@",lastDate] substringToIndex:10];
    
    NSUInteger indexOfTheObject = [simpleDates indexOfObject: simpleSentDate];
    if (indexOfTheObject == NSNotFound){
        indexOfTheObject = 129;
        
        
    }
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:indexOfTheObject];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (index == [self.workDates count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (([self.workDates count] == 0) || (index >= [self.workDates count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    UIImage * reportImage = [self getReportImageForDate:[self.workDates[index] description]];
    
    if (reportImage){
        
        pageContentViewController.reportAvail = YES;
        pageContentViewController.imageFile = reportImage;
        
    }else{
        
        pageContentViewController.imageFile = [UIImage imageNamed:self.pageImages[1]];
        
    }
    
    
    pageContentViewController.reportTitleText = self.reportTitle;
    pageContentViewController.reportShift = self.reportShift;
    
    pageContentViewController.dateText = [self.workDates[index] description]  ;
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

@end
