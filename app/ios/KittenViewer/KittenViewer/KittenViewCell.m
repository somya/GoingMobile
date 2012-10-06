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
		[self.contentView addSubview:m_leftKittenImageView];

		m_rightKittenImageView = [[UIImageView alloc] init];
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
		uiImageView.image = nil;
	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	self.contentView.backgroundColor = [UIColor blackColor];

}

- (void)loadImages
{
//	CGFloat maxY = self.contentView.bounds.size.height;
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
		NSString *url = [NSString stringWithFormat:@"http://lorempixel.com/g/%d/%d",
		                                           (int) uiImageView.bounds.size.width,
		                                           (int) uiImageView.bounds.size.height];
//		NSLog( @"url = %@", url );

		UIImage *image =
			[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
		uiImageView.image = image;
	}
}


@end