//
//  MainMenuTableViewController.m
//  AibUnifiedReports
//
//  Created by John Stone on 6/26/15.
//  Copyright (c) 2015 John Stone. All rights reserved.
//

#import "MainMenuTableViewController.h"
#import "OperationsViewController.h"
@import CloudKit;

@interface MainMenuTableViewController ()

@end

@implementation MainMenuTableViewController
@synthesize reportsData;
@synthesize responsibleData;
@synthesize reportNames;
@synthesize reportType;
@synthesize adminEntries;
@synthesize workDates;
@synthesize reportName;
@synthesize reportTitles;
@synthesize reportTitle;
@synthesize reportShifts;
@synthesize reportShift;



- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITableView appearance] setBackgroundColor:[UIColor colorWithRed:0.247  green:0.451  blue:0.651 alpha:1]];
    
    // Find out the path of MainMenu.plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MainMenu" ofType:@"plist"];
    // Load the file content and read the data into arrays
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    // Parse the dictionary
    reportsData = [dict objectForKey:@"Reports"];
    responsibleData = [dict objectForKey:@"responsible"];
    reportNames = [dict objectForKey:@"ReportNames"] ;
    reportType = [dict objectForKey:@"ReportType"];
    adminEntries = [ dict objectForKey:@"adminEntries"];
    reportTitles = [ dict objectForKey:@"ReportTitles"];
    reportShifts = [ dict objectForKey:@"ReportShifts"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0){
        return reportsData.count;
    }else{
        
        return adminEntries.count;
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuItem" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuItem"];
    }
    // Configure the cell...
    if (indexPath.section == 0){
        cell.textLabel.text = [reportsData objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Responsible Person: %@",[responsibleData objectAtIndex:indexPath.row]];
    } else if (indexPath.section ==1){
        cell.textLabel.text = [adminEntries objectAtIndex:indexPath.row];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(indexPath.section == 0){
        reportName = [reportNames objectAtIndex:indexPath.row];
        reportTitle = [reportTitles objectAtIndex:indexPath.row];
        reportShift = [reportShifts objectAtIndex:indexPath.row];
        
        [self performSegueWithIdentifier:[reportType objectAtIndex:indexPath.row] sender:self];
    }else{
        [self performSegueWithIdentifier:[adminEntries objectAtIndex:indexPath.row] sender:self];
        
    }
}

- (IBAction)unwindToMainMenu:(UIStoryboardSegue*)sender {
    //  UIViewController *sourceViewController = sender.sourceViewController;
    // Pull any data from the view controller which initiated the unwind segue.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0){
        return nil;
    } else if (section ==1){
        return @"Admin";
        
    }
    return @"error";
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UITableView appearance] setBackgroundColor:[UIColor redColor]];
    
    return YES;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    OperationsViewController * myvc = segue.destinationViewController;
    if ([myvc respondsToSelector:@selector(setReportShift:)]){
        myvc.reportShift = reportShift;
        
    }
    if ([myvc respondsToSelector:@selector(setReportName:)]){
        myvc.reportName = reportName;
        
    }
    if ([myvc respondsToSelector:@selector(setReportTitle:)]){
        myvc.reportTitle = reportTitle;
        
    }
    if ([myvc respondsToSelector:@selector(setWorkDates:)]) {
        [myvc performSelector:@selector(setWorkDates:)
                                              withObject:workDates];
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation



@end
