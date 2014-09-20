//
//  RecentPhotosTVC.m
//  FlickrPhotos
//
//  Created by Loc Trinh on 6/6/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import "RecentPhotosTVC.h"

@interface RecentPhotosTVC ()

@end

@implementation RecentPhotosTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPhotos];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchPhotos];
}

- (void)fetchPhotos
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.photos = [userDefault objectForKey:@"Recent Photos"];
    [self.tableView reloadData];
}

@end
