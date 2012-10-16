//
//  Created by somya on 10/12/12.
//
//


#import "KittenImageLoader.h"

@implementation KittenImageLoader

+ (UIImage *)loadImageFromUrl:(NSString *)url
{
	NSURL *url1 = [NSURL URLWithString:url];
	NSData *data = [NSData dataWithContentsOfURL:url1];
	NSLog( @"fetched %i bytes from url: %@", data.length, url );
	int i = 0;
	while ( 0 == data.length && i < 20 )
	{

		NSString *backupUrl = [NSString stringWithFormat:@"%@?image=%d", url, ++i];
		data = [NSData dataWithContentsOfURL:[NSURL URLWithString:backupUrl]];
		NSLog( @"fetched %i bytes from url: %@", data.length, backupUrl );
	}
	if ( data.length > 0 )
	{
		return [UIImage imageWithData:data];
	}
	return nil;
}
@end