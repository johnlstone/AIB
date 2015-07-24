//
//  SIgnPadViewController.h
//  AibUnifiedReports
//
//  Created by John Stone on 7/18/15.
//  Copyright (c) 2015 John Stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPSSignatureView.h"    


@interface SIgnPadViewController : UIViewController
@property (weak, nonatomic) IBOutlet PPSSignatureView *signPad;
@property (weak,nonatomic) NSDate *signDate;
@end
