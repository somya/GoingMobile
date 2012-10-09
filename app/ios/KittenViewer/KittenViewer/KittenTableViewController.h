//
//  KittenTableViewController.h
//  KittenViewer
//
//  Created by Somya Jain on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KittenTableViewController : UITableViewController {
    BOOL mRecordsTasks;
    NSDate *mRecordStart;
    NSUInteger mCountBeforeStart;
}
@property(nonatomic) BOOL recordsTasks;
@property(nonatomic, retain) NSDate *recordStart;


@end
