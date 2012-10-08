//
//  Created by somya on 10/7/12.
//
//


#import "TaskManagerTest.h"
#import "TaskManager.h"
#import "FetchImageTask.h"
#import "BlockRunnerTask.h"

@implementation TaskManagerTest

- (void)testInitialize
{
	[TaskManager initialize];
}

- (void)testSubmitTask
{
	FetchImageTask
		*fetchImageTask = [[FetchImageTask alloc] initWithUrl:@"http://placekitten.com/g/200/200"];
	fetchImageTask.onComplete = ^( id o )
	{
		NSLog( @"%s", sel_getName( _cmd ) );
		NSLog( @"o = %@", o );
		CFRunLoopStop( CFRunLoopGetMain() );
	};
	fetchImageTask.onError = ^( NSError *error )
	{
		NSLog( @"error = %@", error );
	};
	[TaskManager submitTask:fetchImageTask];
	CFRunLoopRun();

	[fetchImageTask release];
}

- (void)testTaskComplete
{
	__block Boolean didComplete = NO;
		BlockRunnerTask
			*fetchImageTask = [[BlockRunnerTask alloc] initWithOnRun:(id) ^( NSError **pError )
		{
			return nil;
		} Complete:^( id o )
		{
			didComplete = true;
			CFRunLoopStop( CFRunLoopGetMain() );
		} onError:^( NSError * error )
		{
			didComplete = false;
			CFRunLoopStop( CFRunLoopGetMain() );
		}];

		[TaskManager submitTask:fetchImageTask];
		CFRunLoopRun();

		STAssertTrue(didComplete, @"Didn't error");

		[fetchImageTask release];
}

- (void)testTaskError
{
	__block Boolean didError = NO;
	BlockRunnerTask
		*fetchImageTask = [[BlockRunnerTask alloc] initWithOnRun:(id) ^( NSError **pError )
	{
		*pError = [NSError errorWithDomain:@"test" code:123 userInfo:nil];
		return nil;
	} Complete:^( id o )
	{
		didError = false;
		CFRunLoopStop( CFRunLoopGetMain() );
	} onError:^( NSError * error)
	{
		didError = true;
		CFRunLoopStop( CFRunLoopGetMain() );
	}];

	[TaskManager submitTask:fetchImageTask];
	CFRunLoopRun();

	STAssertTrue(didError, @"Didn't error");

	[fetchImageTask release];
}

- (void)testTaskException
{

	__block Boolean didError = NO;
	BlockRunnerTask
		*fetchImageTask = [[BlockRunnerTask alloc] initWithOnRun:(id) ^( NSError **pError )
	{
		@throw [NSException exceptionWithName:@"Test" reason:@"blah"
			userInfo:nil];
		return nil;
	} Complete:^( id o )
	{
		didError = false;
		CFRunLoopStop( CFRunLoopGetMain() );
	} onError:^( NSError * error)
	{

		didError = true;
		CFRunLoopStop( CFRunLoopGetMain() );
	}];

	[TaskManager submitTask:fetchImageTask];
	CFRunLoopRun();

	STAssertTrue(didError, @"Didn't error");

	[fetchImageTask release];
}

- (void)testMultipleTaskComplete
{
}
@end