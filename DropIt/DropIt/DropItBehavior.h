//
//  DropItBehavior.h
//  DropIt
//
//  Created by Loc Trinh on 4/15/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropItBehavior : UIDynamicBehavior

- (void)addItem:(id <UIDynamicItem>)item;
- (void)removeItem:(id <UIDynamicItem>)item;
@end
