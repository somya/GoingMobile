//
//  Created by somya on 9/28/12.
//
//


#import "KittenViewCell.h"

@implementation KittenViewCell
@synthesize kittenImageView = m_kittenImageView;
@synthesize url = m_url;

- (void)dealloc
{
	[m_kittenImageView release];
	[m_url release];
	[super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if ( self )
	{
		m_kittenImageView = [[UIImageView alloc] init];
		[self.contentView addSubview:m_kittenImageView];
	}

	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	self.contentView.backgroundColor = [UIColor blackColor];

	self.kittenImageView.frame = CGRectInset( self.contentView.bounds, 1, 1 );
}

- (void)setUrl:(NSString *)url
{
	if ( m_url != url )
	{
		url = [url mutableCopy];
		[m_url release];
		m_url = url;

		if ( m_url )
		{
			NSURL *url1 = [NSURL URLWithString:m_url];
			NSData *data = [NSData dataWithContentsOfURL:url1];
			UIImage *image = [UIImage imageWithData:data];
			m_kittenImageView.image = image;
		}
	}
}


@end