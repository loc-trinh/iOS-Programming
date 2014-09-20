//
//  FlickrPlacesTVC.h
//  FlickrPhotos
//
//  Created by Loc Trinh on 6/5/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrPlacesTVC : UITableViewController
@property (nonatomic, strong) NSMutableArray *countries;
@property (nonatomic, strong) NSMutableDictionary *locations;
@property (nonatomic, strong) NSMutableDictionary *locationID;
@end
