//
//  ViewController.m
//  Imaginarium
//
//  Created by Loc Trinh on 6/2/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewController.h"

@interface ViewController ()

@end

@implementation ViewController

 - (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[ImageViewController class]]){
        ImageViewController *ivc = (ImageViewController *)segue.destinationViewController;
        ivc.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://images.apple.com/v/iphone-5s/gallery/a/images/download/%@.jpg", segue.identifier]];
        ivc.title = segue.identifier;
    }
}


@end
