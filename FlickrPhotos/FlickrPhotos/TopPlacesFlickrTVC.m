//
//  TopPlacesFlickrTVC.m
//  FlickrPhotos
//
//  Created by Loc Trinh on 6/4/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import "TopPlacesFlickrTVC.h"
#import "FlickrFetcher.h"

@interface TopPlacesFlickrTVC ()

@end

@implementation TopPlacesFlickrTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPlaces];
}

- (IBAction)fetchPlaces
{
    [self.refreshControl beginRefreshing];
    NSURL *url = [FlickrFetcher URLforTopPlaces];
    dispatch_queue_t fetchPlacesQ = dispatch_queue_create("Fetch Places Queue", NULL);
    dispatch_async(fetchPlacesQ, ^{
        NSMutableArray *countries = [[NSMutableArray alloc] init];
        NSMutableDictionary *locations = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *locationID = [[NSMutableDictionary alloc] init];
        NSData *jsonData = [NSData dataWithContentsOfURL:url];
        NSArray *placesData = [[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL]
                               valueForKeyPath:FLICKR_RESULTS_PLACES];
        
        for (NSDictionary *place in placesData) {
            NSString *placeID = [place valueForKey:FLICKR_PLACE_ID];
            NSString *placeName = [place valueForKey:FLICKR_PLACE_NAME];
            NSString *countryName = [[placeName componentsSeparatedByString:@", "] lastObject];
            [countries addObject:countryName];
            [locationID setObject:placeID forKey:placeName];
            if(![locations objectForKey:countryName]){
                [locations setObject:[[NSMutableArray alloc] init] forKey:countryName];
            }
            [[locations objectForKey:countryName] addObject:placeName];
        }
        
        countries = [[[NSSet setWithArray:countries] allObjects] mutableCopy];
        countries = [[countries sortedArrayUsingComparator:^NSComparisonResult(NSString *first, NSString *second){return [first compare:second];}]mutableCopy];
        
        for(int i = 0; i < [countries count]; i++){
            locations[countries[i]] = [locations[countries[i]] sortedArrayUsingComparator:^NSComparisonResult(NSString *first, NSString *second){return [first compare:second];}];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.locations = locations;
            self.countries = countries;
            self.locationID = locationID;
            [self.tableView reloadData];
        });
    });
    
}

@end
