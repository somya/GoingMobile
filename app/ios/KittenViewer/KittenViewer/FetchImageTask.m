//
//  Created by somya on 10/7/12.
//
//


#import "FetchImageTask.h"

@implementation FetchImageTask
@synthesize url = m_url;

- (void)dealloc
{
	[m_url release];
	[super dealloc];
}

- (id)run:(NSError **)error
{
	if ( self.url )
	{
		NSURL *url1 = [NSURL URLWithString:m_url];
		NSData *data = [NSData dataWithContentsOfURL:url1];
		UIImage *image = [UIImage imageWithData:data];
		return image;
	}
	return nil;
}


@end