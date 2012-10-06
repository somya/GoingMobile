//
//  Created by somya on 9/28/12.
//
//


#import "KittenViewCell.h"

@implementation KittenViewCell
@synthesize leftKittenImageView = m_leftKittenImageView;
@synthesize rightKittenImageView = m_rightKittenImageView;

- (void)dealloc
{
	[m_leftKittenImageView release];
	[m_rightKittenImageView release];
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

	NSArray *temp = [NSArray arrayWithObjects:m_leftKittenImageView, m_rightKittenImageView, nil];

	for ( UIImageView *uiImageView in temp )
	{
		NSString *url = [NSString stringWithFormat:@"http://placekitten.com/g/%d/%d",
		                                           (int) uiImageView.bounds.size.width* 2,
		                                           (int) uiImageView.bounds.size.height*2];
		NSLog( @"url = %@", url );

		dispatch_queue_t queue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0 );
		dispatch_async( queue, ^
		{
			UIImage *image =
				[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];

			dispatch_async( dispatch_get_main_queue(), ^
			{
				uiImageView.image = image;
			} );
		} );
	}
}


@end