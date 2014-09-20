//
//  FlickrPhotosTVC.m
//  FlickrPhotos
//
//  Created by Loc Trinh on 6/4/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import "FlickrPhotosTVC.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface FlickrPhotosTVC ()
@property (nonatomic, strong) NSMutableArray *recentPhotos;
@end

@implementation FlickrPhotosTVC

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photo Cell" forIndexPath:indexPath];
    
    // Configure the cell.
    NSDictionary *photo = self.photos[indexPath.row];
    NSString *title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    NSString *description = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    if(title.length == 0 && description.length == 0){
        cell.textLabel.text = @"Unknown";
        cell.detailTextLabel.text = @"";
    }
    else if(title.length == 0 && description.length != 0){
        cell.textLabel.text = description;
        cell.detailTextLabel.text = @"";
    }
    else{
        cell.textLabel.text = title;
        cell.detailTextLabel.text = description;
    }
    return cell;
}


#pragma mark - Navigation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detail = self.splitViewController.viewControllers[1];
    if([detail isKindOfClass:[UINavigationController class]]){
        detail = [((UINavigationController *)detail).viewControllers firstObject];
    }
    if([detail isKindOfClass:[ImageViewController class]]){
        [self prepareImageViewController:detail toDisplayPhoto:self.photos[indexPath.row]];
    }
}

- (void)prepareImageViewController:(ImageViewController *)ivc toDisplayPhoto:(NSDictionary *)photo
{
    ivc.imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
    ivc.title = [[photo valueForKeyPath:FLICKR_PHOTO_TITLE] length] == 0 ? @"Unknown" : [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if(![userDefault objectForKey:@"Recent Photos"]){
        [userDefault setObject:[[NSArray alloc]init] forKey:@"Recent Photos"];
    }
    else{
        self.recentPhotos = [[userDefault objectForKey:@"Recent Photos"] mutableCopy];
        if([self.recentPhotos count] > 20) [self.recentPhotos removeObjectAtIndex:0];
        [self.recentPhotos addObject:photo];
        [userDefault setObject:self.recentPhotos forKey:@"Recent Photos"];
        [userDefault synchronize];
    }
}
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Display Photo"]){
                if([segue.destinationViewController isKindOfClass:[ImageViewController class]]){
                    [self prepareImageViewController:segue.destinationViewController
                                      toDisplayPhoto:self.photos[indexPath.row]];

                }
            }
        }
    }
}


@end
