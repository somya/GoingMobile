//
//  Created by somya on 10/7/12.
//
//


#import "FetchImageTask.h"

@implementation FetchImageTask
@synthesize url = m_url;
@synthesize index = m_index;

- (id)initWithUrl:(NSString *)url
{
	self = [super init];
	if ( self )
	{
		self.url = url;
	}

	return self;
}

+ (id)objectWithUrl:(NSString *)url
{
	return [[[FetchImageTask alloc] initWithUrl:url] autorelease];
}

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
		NSLog( @"[%i] fetched %i bytes from url: %@", self.index, data.length, self.url );
		int i = 0;
		while ( 0 == data.length && i < 10  )
		{

			NSString *backupUrl = [NSString stringWithFormat:@"%@?image=%d", m_url, ++i];
			data = [NSData dataWithContentsOfURL:[NSURL URLWithString:backupUrl]];
			NSLog( @"[%i] fetched %i bytes from url: %@", self.index, data.length, backupUrl );
		}
		UIImage *image = [UIImage imageWithData:data];
		return image;
	}
	return nil;
}


@end