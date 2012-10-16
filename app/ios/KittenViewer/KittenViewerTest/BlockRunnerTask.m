//
//  Created by somya on 10/7/12.
//
//


#import "BlockRunnerTask.h"

@implementation BlockRunnerTask
@synthesize onRun = m_onRun;

- (id)initWithOnRun:(TaskOnRun)onRun Complete:(TaskOnComplete)onComplete
	onError:(TaskOnError)onError
{
	self = [super initWithOnComplete:onComplete onError:onError];
	if ( self )
	{
		self.onRun = onRun;
	}

	return self;
}

- (id)run:(NSError **)error
{
	return self.onRun(error);
}

- (void)dealloc
{
	[m_onRun release];
	[super dealloc];
}

@end