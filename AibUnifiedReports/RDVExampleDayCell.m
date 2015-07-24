// RDVExampleDayCell.m
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

#import "RDVExampleDayCell.h"

@implementation RDVExampleDayCell
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _notificationView = [[UIView alloc] initWithFrame:CGRectMake(40, 200, 280, 192)];
              [_notificationView setAlpha:.75];
        _holidayView = [[UIView alloc] initWithFrame:CGRectMake(40,200,280,192)];
        [_holidayView setAlpha:.75];
          [_holidayView setBackgroundColor:[UIColor blueColor]];
        [_notificationView setHidden:YES];
        
        [self.contentView addSubview:_notificationView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize viewSize = self.contentView.frame.size;
    //  UIImage *image = [UIImage imageNamed:@"bloodymoon.jpg"];
    // [[self notificationView]   ].image = image;
    
    [[self notificationView] setFrame:  CGRectMake(3, 3, viewSize.width-3, viewSize.height -3)];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BR1_circle-3.png"]];
    [imageView setFrame:CGRectMake(11.0, 11.0, 90.0, 90.0) ];
    if (_notificationView.subviews.count == 0){
        [imageView setTag:1];
        
        [_notificationView addSubview:imageView];
    }
    if (_holidayView.subviews.count ==0){
    //    [_holidayView addSubview:imageView];
        
    }
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [[self notificationView] setHidden:YES];
}

@end
