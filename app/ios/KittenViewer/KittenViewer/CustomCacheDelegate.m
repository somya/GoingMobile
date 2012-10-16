//
//  Created by somya on 10/15/12.
//
//


#import "CustomCacheDelegate.h"

@implementation CustomCacheDelegate
- (void)cache:(NSCache *)cache willEvictObject:(id)obj
{

	NSLog( @"Cache Evicting Object = %@", obj );
}

@end