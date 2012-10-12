//
//  Created by somya on 9/28/12.
//
//


#import "KittenViewCell.h"
#import "KittenImageLoader.h"

@implementation KittenViewCell
@synthesize leftKittenImageView = m_leftKittenImageView;
@synthesize rightKittenImageView = m_rightKittenImageView;
@synthesize leftUrl = m_leftUrl;
@synthesize rightUrl = m_rightUrl;

- (void)dealloc
{
	[m_leftKittenImageView release];
	[m_rightKittenImageView release];
	[m_leftUrl release];
	[m_rightUrl release];
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
	u_int32_t random_width = 40 + (arc4random() % ((int) maxX - 80));
	CGRectDivide( self.contentView.bounds, &left, &right, random_width, CGRectMinXEdge );

	self.leftKittenImageView.frame = CGRectInset( left, 1, 1 );
	self.rightKittenImageView.frame = CGRectInset( right, 1, 1 );

	NSString *leftUrl = [NSString stringWithFormat:@"http://placekitten.com/%d/%d",
	                                               (int) self.leftKittenImageView.bounds.size.width,
	                                               (int) self.leftKittenImageView.bounds.size.height];

	self.leftUrl = leftUrl;
	dispatch_queue_t queue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 );
	dispatch_async( queue, ^
	{
		UIImage *image = [KittenImageLoader loadImageFromUrl:leftUrl];

		dispatch_async( dispatch_get_main_queue(), ^
		{
			if ( [self.leftUrl compare:leftUrl] == NSOrderedSame )
			{
				self.leftKittenImageView.image = image;
			}
			else
			{
				NSLog( @"leftUrl = %@, self.leftUrl = %@", leftUrl, self.leftUrl );
			}
		} );
	} );

	NSString *rightUrl = [NSString stringWithFormat:@"http://placekitten.com/%d/%d",
	                                                (int) self.rightKittenImageView.bounds.size.width,
	                                                (int) self.rightKittenImageView.bounds.size.height];
	self.rightUrl = rightUrl;

	queue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 );
	dispatch_async( queue, ^
	{
		UIImage *image = [KittenImageLoader loadImageFromUrl:rightUrl];

		dispatch_async( dispatch_get_main_queue(), ^
		{

			if ( [self.rightUrl compare:rightUrl] == NSOrderedSame )
			{
				self.rightKittenImageView.image = image;
			}
			else
			{
				NSLog( @"rightUrl = %@, self.rightUrl = %@", rightUrl, self.rightUrl );
			}
		} );
	} );
}


@end