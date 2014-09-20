//
//  FlickrPlacesTVC.m
//  FlickrPhotos
//
//  Created by Loc Trinh on 6/5/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import "FlickrPlacesTVC.h"
#import "PhotosFromPlaceTVC.h"

@interface FlickrPlacesTVC ()

@end

@implementation FlickrPlacesTVC


- (NSMutableArray *)countries{
    if(!_countries) _countries = [[NSMutableArray alloc] init];
    return _countries;
}


- (NSMutableDictionary *)locations{
    if(!_locations) _locations = [[NSMutableDictionary alloc] init];
    return _locations;
}


- (NSMutableDictionary *)locationID{
    if(!_locationID) _locationID = [[NSMutableDictionary alloc] init];
    return _locationID;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.countries count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.locations[self.countries[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Location Cell" forIndexPath:indexPath];
    
    // Configure the cell.
    NSString *name = [self getPlaceName:indexPath];
    NSArray *nameTokens = [name componentsSeparatedByString:@", "];
    cell.textLabel.text = [nameTokens firstObject];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", nameTokens[1], [nameTokens lastObject]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // Return section title
    return self.countries[section];
}

- (NSString *)getPlaceName:(NSIndexPath *)indexPath{
    return self.locations[self.countries[indexPath.section]][indexPath.row];
}

- (NSString *)getPlaceID:(NSString *)placeName{
    return self.locationID[placeName];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     if([sender isKindOfClass:[UITableViewCell class]]){
         NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
         if(indexPath){
             if([segue.identifier isEqualToString:@"Get Photos"]){
                 if([segue.destinationViewController isKindOfClass:[PhotosFromPlaceTVC class]]){
                     PhotosFromPlaceTVC *ptvc = (PhotosFromPlaceTVC *)segue.destinationViewController;
                     ptvc.placeIDforURL = [self getPlaceID:[self getPlaceName:indexPath]];
                     ptvc.title = [[[self getPlaceName:indexPath] componentsSeparatedByString:@", "] firstObject];
                 }
             }
         }
     }
     
 }












@end
