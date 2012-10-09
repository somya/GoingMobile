//
//  Created by somya on 9/28/12.
//
//


#import <Foundation/Foundation.h>

@class Task;

extern NSUInteger KittenViewCellTaskCount;

@interface KittenViewCell : UITableViewCell
{
	UIImageView *m_leftKittenImageView;
	UIImageView *m_rightKittenImageView;
@private
	NSString *m_urlLeft;
	NSString *m_urlRight;

    Task *mLeftTask;
    Task *mRightTask;
}
@property( nonatomic, retain ) UIImageView *leftKittenImageView;
@property( nonatomic, retain ) UIImageView *rightKittenImageView;
@property( nonatomic, copy ) NSString *urlLeft;
@property( nonatomic, copy ) NSString *urlRight;
@property(nonatomic, retain) Task *leftTask;
@property(nonatomic, retain) Task *rightTask;


- (void)cancelTasks;

- (void)loadImages;


@end