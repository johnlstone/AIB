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
    // This currently just check file system on device. needs to check for cloudkit too.
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *filename = [NSString stringWithFormat:@"%@-%@",reportName,[date substringToIndex:10]];
    NSString *directoryPath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:filename]];
    UIImage * image = [UIImage imageWithContentsOfFile:directoryPath];
    
    return image;
    
}


#pragma mark - Render and save report
- (void) setEditBoxes:(NSArray *)passedArray{
    PageContentViewController *pageController = [[[[self childViewControllers] firstObject]childViewControllers]firstObject];
    pageController.correctiveAction.text = [passedArray objectAtIndex:0];
    pageController.preventiveMeasure.text = [passedArray objectAtIndex:1];
    
    NSArray  *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *filename = [NSString stringWithFormat:@"text-%@-%@",self.reportName  ,pageController.dateLabel.text];
    
    NSString *directoryPath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:filename]];
    //NSData *data = UIImagePNGRepresentation(image);
    [passedArray writeToFile:directoryPath atomically:YES];
  
    
}

- (void) setCheckTime:(NSArray *)passedArray{
    
    PageContentViewController * pageController = [[[[self childViewControllers] firstObject ]childViewControllers]firstObject];
    
    pageController.firstCheckTime.text = [passedArray firstObject];
    pageController.secondCheckTime.text = [passedArray objectAtIndex:1];
    
}

- (void) saveReport:(NSArray *)passedArray{
    
    // passed array format is @[signatureImage,date,nil];
    UIImage *signImage = [passedArray objectAtIndex:0];
    NSString *signDate =[NSString stringWithFormat:@"%@", [passedArray objectAtIndex:1]];
    
    NSArray  *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *filename = [NSString stringWithFormat:@"signature-%@-%@",self.reportName  ,[signDate substringToIndex:10]];
    NSString *directoryPath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:filename]];
    NSData *data = UIImagePNGRepresentation(signImage);
    
    [data writeToFile:directoryPath atomically:YES];
    
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

    // draw Check Boxes and Labels;
    //draw EMPLOYEE HYGIENE FIRST CHECK
    NSMutableDictionary *checkMarkAttr = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [UIFont systemFontOfSize:48], NSFontAttributeName,nil];
    [[UIColor blackColor]setStroke];
    [[UIColor blackColor]setFill];
    //
    NSString *checkMark = @"X";
    NSString *okColumnLabel = @"OK";
    NSString *defColummLabel = @"Defciency";
    [okColumnLabel drawAtPoint:CGPointMake(995, 190) withAttributes:dictionary];
    [defColummLabel drawAtPoint:CGPointMake(1070, 190) withAttributes:dictionary];
// eh check
    NSString *CheckLabel = [NSString stringWithFormat:@"First Check: %@", @""];
    [CheckLabel drawInRect:CGRectMake(800, 275, 400, 400)  withAttributes:dictionary];
    if ( pageController.ehFirstCheck.isOn){
        [checkMark drawAtPoint:CGPointMake(1000, 255) withAttributes:checkMarkAttr];
    }else{
        [checkMark drawAtPoint:CGPointMake(1100, 255) withAttributes:checkMarkAttr];
    }
    
    CheckLabel = [NSString stringWithFormat:@"Second Check: %@", @""];
    [CheckLabel drawInRect:CGRectMake(780, 375, 400, 400)  withAttributes:dictionary];
    if ( pageController.ehSecondCheck.isOn){
        [checkMark drawAtPoint:CGPointMake(1000, 355) withAttributes:checkMarkAttr];
    }else{
        [checkMark drawAtPoint:CGPointMake(1100, 355) withAttributes:checkMarkAttr];
    }
// MH Check
    CheckLabel = [NSString stringWithFormat:@"First Check: %@", @""];
    [CheckLabel drawInRect:CGRectMake(800, 440, 400, 400)  withAttributes:dictionary];
    if ( pageController.mhFirstCheck.isOn){
        [checkMark drawAtPoint:CGPointMake(1000, 420) withAttributes:checkMarkAttr];
    }else{
        [checkMark drawAtPoint:CGPointMake(1100, 420) withAttributes:checkMarkAttr];
        
    }
    CheckLabel = [NSString stringWithFormat:@"Second Check: %@", @""];
    [CheckLabel drawInRect:CGRectMake(780, 540, 400, 400)  withAttributes:dictionary];
    if ( pageController.mhSecondCheck.isOn){
        
        [checkMark drawAtPoint:CGPointMake(1000, 520) withAttributes:checkMarkAttr];
    }else{
        [checkMark drawAtPoint:CGPointMake(1100, 520) withAttributes:checkMarkAttr];
    }
//PC CHECK
    CheckLabel = [NSString stringWithFormat:@"First Check: %@", @""];
    [CheckLabel drawInRect:CGRectMake(800, 605, 400, 400)  withAttributes:dictionary];
    if ( pageController.pcFirstCheck.isOn){
        [checkMark drawAtPoint:CGPointMake(1000, 585) withAttributes:checkMarkAttr];
    }else{
        [checkMark drawAtPoint:CGPointMake(1100, 585) withAttributes:checkMarkAttr];
        
    }
    CheckLabel = [NSString stringWithFormat:@"Second Check: %@", @""];
    [CheckLabel drawInRect:CGRectMake(780, 700, 400, 400)  withAttributes:dictionary];
    
    if ( pageController.pcSecondCheck.isOn){
        
        [checkMark drawAtPoint:CGPointMake(1000, 680) withAttributes:checkMarkAttr];
    }else{
        [checkMark drawAtPoint:CGPointMake(1100, 680) withAttributes:checkMarkAttr];}
//OH Check
    CheckLabel = [NSString stringWithFormat:@"First Check: %@", @""];
    [CheckLabel drawInRect:CGRectMake(800, 770, 400, 400)  withAttributes:dictionary];
    
    if ( pageController.ohFirstCheck.isOn){
        [checkMark drawAtPoint:CGPointMake(1000, 750) withAttributes:checkMarkAttr];
    }else{
        [checkMark drawAtPoint:CGPointMake(1100, 750) withAttributes:checkMarkAttr];
    }
    CheckLabel = [NSString stringWithFormat:@"Second Check: %@", @""];
    [CheckLabel drawInRect:CGRectMake(780, 860, 400, 400)  withAttributes:dictionary];
    
    if ( pageController.ohSecondCheck.isOn){
        
        [checkMark drawAtPoint:CGPointMake(1000, 840) withAttributes:checkMarkAttr];
    }else{
        [checkMark drawAtPoint:CGPointMake(1100, 840) withAttributes:checkMarkAttr];
    }
    
    // draw corrective action text box
    NSString * correctiveAction = pageController.correctiveAction.text;
    [correctiveAction drawInRect:CGRectMake(120, 950, 950, 300) withAttributes:dictionary];
    NSString * preventiveMeasure = pageController.preventiveMeasure.text;
    [preventiveMeasure drawInRect:CGRectMake(120, 1190, 950, 300) withAttributes:dictionary];
    
    
    // Draw signature in bottom right
    [signatureImage drawInRect:CGRectMake(750,1320, 350, 150) blendMode:kCGBlendModePlusDarker alpha:.99f ];

    // gererate report image
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    // generate file name
    NSString * fileName = [NSString stringWithFormat:@"%@-%@.png",reportName,date];
    NSLog(@"Generate Report with name: %@.png",fileName);
    //Wirte image to file system.
    [self writeReportWithFilename:image FileName:fileName];
    [self postReportToCloud:fileName];
    
}
-(NSInteger *) getStateOFSwitchs {
    return 0;
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
    
     PageContentViewController * pageController = [[[[self childViewControllers] firstObject ]childViewControllers]firstObject];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docsDir = [dirPaths objectAtIndex:0];
   
    NSString *directoryPath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:file]];
    
    NSURL *url = [[NSURL alloc]initFileURLWithPath:directoryPath];
    
    CKContainer *defaultContainer = [CKContainer containerWithIdentifier:@"iCloud.com.pbok.AibUnifiedReports"];
   
    CKDatabase *publicDatabase = [defaultContainer publicCloudDatabase];
    //check for existing file
  //  NSPredicate *fileNamePredicate = [NSPredicate predicateWithFormat: @"name BEGINSWITH 'm'"];
    CKRecordID *reportImageId = [[CKRecordID alloc] initWithRecordName:@"ReportImages"];
    
    [publicDatabase fetchRecordWithID:reportImageId completionHandler:^(CKRecord *fetchedPlace, NSError *error) {
        // handle errors here
    }];
    
    CKAsset *reportI = [[CKAsset alloc ] initWithFileURL:url];
    
    CKRecord *postRecord = [[CKRecord alloc] initWithRecordType:@"ReportImages" ];
    postRecord[@"reportName"] = file;
    postRecord[@"reportDate"]=[[NSString stringWithFormat:@"%@", pageController.dateText] substringToIndex:10];
    postRecord[@"correctiveAction"] = pageController.correctiveAction.text;
    postRecord[@"preventiveMeasure"] = pageController.preventiveMeasure.text;
    postRecord[@"firstCheck"] = pageController.firstCheckTime.text;
    postRecord[@"secondCheck"] = pageController.secondCheckTime.text;
    
    
    
    postRecord[@"discrepancy"]=@"discrepancy test Field";
    
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

- (NSString *) getTodayDate {
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:usLocale];
    NSString *dateString = [dateFormat stringFromDate:today];
    NSString * simpleSentDate = [[NSString stringWithFormat:@"%@",dateString] substringToIndex:10];
    
    
    return simpleSentDate;
    
}

- (void) viewDidLoad {
    [super viewDidLoad];
    //static list of pdfs backgrounds
    _pageImages = @[@"operatios.png",@"operations.png",@"operations.png",@"operations.png"];
    
    // get todays date
    NSMutableArray *simpleDates = [self simplifyWorkDates];
    NSString *simpleSentDate = [self getTodayDate];
    
    // What to do about weekends
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
     //   pageContentViewController.imageFile = reportImage;
        pageContentViewController.imageFile = [UIImage imageNamed:self.pageImages[1]];
        
    }else{
        
        pageContentViewController.imageFile = [UIImage imageNamed:self.pageImages[1]];
        
    }
    pageContentViewController.reportName = self.reportName;
    
    
    pageContentViewController.reportTitleText = self.reportTitle;
    pageContentViewController.reportShift = self.reportShift;
    
    pageContentViewController.dateText = [self.workDates[index] description]  ;
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

@end
