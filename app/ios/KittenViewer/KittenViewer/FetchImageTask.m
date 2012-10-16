//
//  Created by somya on 10/7/12.
//
//


#import "FetchImageTask.h"
#import "CustomCacheDelegate.h"

@implementation FetchImageTask
@synthesize url = m_url;
@synthesize index = m_index;

NSCache *theCache;

+ (void)initialize
{
	theCache = [[NSCache alloc] init];
	theCache.totalCostLimit = 1024 * 1024 * 5; // 5MB
	theCache.delegate = [[CustomCacheDelegate alloc] init];
}

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
		@synchronized ( theCache )
		{
			id object = [theCache objectForKey:self.url];
			if ( object )
			{
				NSLog( @"Cache hit on self.url = %@", self.url );
				return (UIImage *) object;
			}
		}
		NSData *data = [NSData dataWithContentsOfURL:url1];
//		NSLog( @"[%i] fetched %i bytes from url: %@", self.index, data.length, self.url );
		int i = 0;
		while ( 0 == data.length && i < 20 )
		{

			NSString *backupUrl = [NSString stringWithFormat:@"%@?image=%d", m_url, ++i];
			data = [NSData dataWithContentsOfURL:[NSURL URLWithString:backupUrl]];
			NSLog( @"[%i] fetched %i bytes from url: %@", self.index, data.length, backupUrl );
		}
		UIImage *image = [UIImage imageWithData:data];
		@synchronized ( theCache )
		{
			if ( data.length > 0 )
			{
				CGFloat cost = image.size.width * image.size.height * 4;
//				NSLog( @"Cache Add: self.url = %@, cost = %f", self.url, cost );
				[theCache setObject:image forKey:self.url cost:(NSUInteger) cost];
			}
		}
		return image;
	}
	return nil;
}


@end