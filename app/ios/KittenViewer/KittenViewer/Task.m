//
//  Created by somya on 10/6/12.
//
//


#import "Task.h"

@implementation Task
@synthesize onSuccess = m_onSuccess;
@synthesize onError = m_onError;

- (id)initWithOnSuccess:(TaskOnSuccess)onSuccess onError:(TaskOnError)onError
{
	self = [super init];
	if ( self )
	{
		self.onSuccess = onSuccess;
		self.onError = onError;
	}

	return self;
}


- (id)run:(NSError **)error
{
	return nil;
}

- (void)dealloc
{
	[m_onSuccess release];
	[m_onError release];
	[super dealloc];
}


@end