//
//  Created by somya on 10/6/12.
//
//


#import "Task.h"

@implementation Task
@synthesize onComplete = m_onComplete;
@synthesize onError = m_onError;
@synthesize cancelled = mCancelled;


- (id)initWithOnComplete:(TaskOnComplete)onComplete onError:(TaskOnError)onError
{
	self = [super init];
	if ( self )
	{
		self.onComplete = onComplete;
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
	[m_onComplete release];
	[m_onError release];
	[super dealloc];
}



@end