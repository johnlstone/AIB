//
//  preventiveMeasureViewController.h
//  AibUnifiedReports
//
//  Created by John Stone on 7/27/15.
//  Copyright (c) 2015 John Stone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface preventiveMeasureViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *caViewBox;
@property (weak, nonatomic) IBOutlet UIImageView *pmViewBox;
@property (weak, nonatomic) IBOutlet UITextView *preventiveMeasure;
@property (weak, nonatomic) IBOutlet UITextView *correctiveAction;
@property (weak, nonatomic) NSString * reportName;

@property (weak, nonatomic) NSString * dateText;
- (IBAction)dimiss:(id)sender;

@end
