//
//  Created by somya on 9/28/12.
//
//


#import "KittenViewCell.h"
#import "TaskManager.h"
#import "FetchImageTask.h"
#import "Task.h"
#include <libkern/OSAtomic.h>

@implementation KittenViewCell
@synthesize leftKittenImageView = m_leftKittenImageView;
@synthesize rightKittenImageView = m_rightKittenImageView;
@synthesize urlLeft = m_urlLeft;
@synthesize urlRight = m_urlRight;
@synthesize leftTask = mLeftTask;
@synthesize rightTask = mRightTask;

NSUInteger KittenViewCellTaskCount = 0;


int counter = 0;

- (void)dealloc
{
    [self cancelTasks];
	[m_leftKittenImageView release];
	[m_rightKittenImageView release];
	[m_urlLeft release];
	[m_urlRight release];
    [mLeftTask release], mLeftTask = nil;
    [mRightTask release], mRightTask = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if ( self )
	{
		m_leftKittenImageView = [[UIImageView alloc] init];
		m_leftKittenImageView.image = [UIImage imageNamed:@"empty.png"];
		[self.contentView addSubview:m_leftKittenImageView];

		m_rightKittenImageView = [[UIImageView alloc] init];
		m_rightKittenImageView.image = [UIImage imageNamed:@"empty.png"];
		[self.contentView addSubview:m_rightKittenImageView];
	}

	return self;
}

- (void)prepareForReuse
{
	[super prepareForReuse];
    [self cancelTasks];

    NSArray *temp = [NSArray arrayWithObjects:m_leftKittenImageView, m_rightKittenImageView, nil];

	for ( UIImageView *uiImageView in temp )
	{
		uiImageView.image = [UIImage imageNamed:@"empty.png"];
	}
}

- (void)cancelTasks {
//    NSLog(@"CANCELLING TASKS FOR CELL: %@",self);
    self.leftTask.cancelled = YES;
    self.leftTask = nil;

    self.rightTask.cancelled = YES;
    self.rightTask = nil;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	self.contentView.backgroundColor = [UIColor blackColor];
}

- (void)loadImages
{
	CGFloat maxX = self.contentView.bounds.size.width;
	CGRect left;
	CGRect right;
	u_int32_t random_width = 60 + (arc4random() % ((int) maxX - 120));
	CGRectDivide( self.contentView.bounds, &left, &right, random_width, CGRectMinXEdge );

	self.leftKittenImageView.frame = CGRectInset( left, 1, 1 );
	self.rightKittenImageView.frame = CGRectInset( right, 1, 1 );

	NSArray *temp = [NSArray arrayWithObjects:m_leftKittenImageView, m_rightKittenImageView, nil];

	self.urlLeft = [NSString stringWithFormat:@"http://placekitten.com/%d/%d",
	                                          (int) self.leftKittenImageView.bounds.size.width,
	                                          (int) self.leftKittenImageView.bounds.size.height];

	self.urlRight = [NSString stringWithFormat:@"http://placekitten.com/%d/%d",
	                                           (int) self.rightKittenImageView.bounds.size.width,
	                                           (int) self.rightKittenImageView.bounds.size.height];
//	NSLog( @"urlLeft = %@", self.urlLeft );
//	NSLog( @"urlRight = %@", self.urlRight );

	FetchImageTask *leftTask = [[FetchImageTask alloc] initWithUrl:self.urlLeft];
	leftTask.index = OSAtomicIncrement32( &counter );

	leftTask.onComplete = ^( id o )
	{
        OSAtomicIncrement32((int32_t *) &KittenViewCellTaskCount);
        if ( [leftTask.url isEqualToString:self.urlLeft] )
        {
            self.leftKittenImageView.image = o;
		}
	};
	leftTask.onError = ^( NSError *error, BOOL cancelled )
	{
        OSAtomicIncrement32((int32_t *) &KittenViewCellTaskCount);
        if (!cancelled) {
            NSLog( @"error = %@", error );
        }
    };
	[TaskManager submitTask:leftTask];
    self.leftTask = leftTask;
	[leftTask release];

	FetchImageTask *rightTask = [[FetchImageTask alloc] initWithUrl:self.urlRight];
	rightTask.index = OSAtomicIncrement32( &counter );

	rightTask.onComplete = ^( id o )
	{
        OSAtomicIncrement32((int32_t *) &KittenViewCellTaskCount);
		if ( [rightTask.url isEqualToString:self.urlRight] )
		{
			self.rightKittenImageView.image = o;
		}
	};
	rightTask.onError = ^( NSError *error, BOOL cancelled )
	{
        OSAtomicIncrement32((int32_t *) &KittenViewCellTaskCount);
        if (!cancelled) {
            NSLog( @"error = %@", error );
        }
    };
	[TaskManager submitTask:rightTask];
    self.rightTask = rightTask;
	[rightTask release];
}


@end