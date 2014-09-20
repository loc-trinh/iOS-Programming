//
//  PhotosFromPlaceTVC.m
//  FlickrPhotos
//
//  Created by Loc Trinh on 6/5/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import "PhotosFromPlaceTVC.h"
#import "FlickrFetcher.h"

@interface PhotosFromPlaceTVC ()

@end

@implementation PhotosFromPlaceTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPhotos];
}

- (IBAction)fetchPhotos
{
    [self.refreshControl beginRefreshing];
    NSURL *url = [FlickrFetcher URLforPhotosInPlace:self.placeIDforURL maxResults:50];
    
    dispatch_queue_t fetchPhotosQ = dispatch_queue_create("Fetch Photos Queue", NULL);
    dispatch_async(fetchPhotosQ, ^{
        NSData *jsonData = [NSData dataWithContentsOfURL:url];
        NSDictionary *photosData = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
        NSArray *photos = [photosData valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = photos;
            [self.tableView reloadData];
        });
        
    });
 
}

@end
