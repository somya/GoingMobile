//
//  Created by somya on 9/28/12.
//
//


#import "KittenViewCell.h"
#import "TaskManager.h"
#import "FetchImageTask.h"
#include <libkern/OSAtomic.h>

@implementation KittenViewCell
@synthesize leftKittenImageView = m_leftKittenImageView;
@synthesize rightKittenImageView = m_rightKittenImageView;
@synthesize urlLeft = m_urlLeft;
@synthesize urlRight = m_urlRight;

int counter = 0;

- (void)dealloc
{
	[m_leftKittenImageView release];
	[m_rightKittenImageView release];
	[m_urlLeft release];
	[m_urlRight release];
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
	NSArray *temp = [NSArray arrayWithObjects:m_leftKittenImageView, m_rightKittenImageView, nil];

	for ( UIImageView *uiImageView in temp )
	{
		uiImageView.image = [UIImage imageNamed:@"empty.png"];
	}
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
	                                          (int) self.leftKittenImageView.bounds.size.width * 4,
	                                          (int) self.leftKittenImageView.bounds.size.height * 4];

	self.urlRight = [NSString stringWithFormat:@"http://placekitten.com/%d/%d",
	                                           (int) self.rightKittenImageView.bounds.size.width *4,
	                                           (int) self.rightKittenImageView.bounds.size.height * 4];
//	NSLog( @"urlLeft = %@", self.urlLeft );
//	NSLog( @"urlRight = %@", self.urlRight );

	FetchImageTask *leftTask = [[FetchImageTask alloc] initWithUrl:self.urlLeft];
	leftTask.index = OSAtomicIncrement32( &counter );

	leftTask.onComplete = ^( id o )
	{
		if ( [leftTask.url isEqualToString:self.urlLeft] )
		{
			[UIView animateWithDuration:0.25 animations:^
			{
				self.leftKittenImageView.alpha = 0.0;
			} completion:^( BOOL finished )
			{
				self.leftKittenImageView.image = o;
				[UIView animateWithDuration:0.5 animations:^
				{
					self.leftKittenImageView.alpha = 1.0;
				}];
			}];
		}
	};
	leftTask.onError = ^( NSError *error )
	{
		NSLog( @"error = %@", error );
	};
	[TaskManager submitTask:leftTask];
	[leftTask release];

	FetchImageTask *rightTask = [[FetchImageTask alloc] initWithUrl:self.urlRight];
	rightTask.index = OSAtomicIncrement32( &counter );

	rightTask.onComplete = ^( id o )
	{
		if ( [rightTask.url isEqualToString:self.urlRight] )
		{
			[UIView animateWithDuration:0.5 animations:^
			{
				self.rightKittenImageView.alpha = 0.0;
			} completion:^( BOOL finished )
			{
				self.rightKittenImageView.image = o;
				[UIView animateWithDuration:0.5 animations:^
				{
					self.rightKittenImageView.alpha = 1.0;
				}];
			}];
		}
	};
	rightTask.onError = ^( NSError *error )
	{
		NSLog( @"error = %@", error );
	};
	[TaskManager submitTask:rightTask];
	[rightTask release];
}


@end