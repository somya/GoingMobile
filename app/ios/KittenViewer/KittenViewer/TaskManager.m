//
//  Created by somya on 10/6/12.
//
//


#import "TaskManager.h"

int MAX_THREADS = 0;
NSMutableArray *pendingTasks;
BOOL cancel;
dispatch_semaphore_t jobSemaphore;
dispatch_semaphore_t dataSemaphore;

@implementation TaskManager

+ (void)initialize
{
	NSLog( @"%s", sel_getName( _cmd ) );
	pendingTasks = [[NSMutableArray alloc] init];

	int cpuCount = [[NSProcessInfo processInfo] processorCount];
	MAX_THREADS = cpuCount * 2;
	jobSemaphore = dispatch_semaphore_create( MAX_THREADS );
	dataSemaphore = dispatch_semaphore_create( 0 );

	cancel = NO;

	for ( int j = 0; j < MAX_THREADS; j++ )
	{
		dispatch_queue_t queue =
			dispatch_queue_create( [[NSString stringWithFormat:@"worker_%d", j] UTF8String], nil );

		dispatch_async( queue, ^
		{
			while ( true )
			{
				dispatch_semaphore_wait( dataSemaphore, DISPATCH_TIME_FOREVER );
				dispatch_semaphore_wait( jobSemaphore, DISPATCH_TIME_FOREVER );
				Task *task = nil;
				if ( pendingTasks.count > 0 )
				{
					@synchronized ( pendingTasks )
					{
						if ( pendingTasks.count > 0 )
						{
							// LIFO queue
							task = [pendingTasks lastObject];
							[pendingTasks removeObject:task];
						}
					}
				}

				if ( task )
				{
					[TaskManager runTask:task];
				}

				if ( cancel )
				{
					break;
				}
			}
		} );
	}
}

+ (void)submitTask:(Task *)task
{
	@synchronized ( pendingTasks )
	{
		[pendingTasks addObject:task];
	}
	dispatch_semaphore_signal( dataSemaphore );
}

+ (void)runTask:(Task *)task
{

	@autoreleasepool
	{
		@try
		{

			NSError *error = nil;
			id result = [task run:&error];
			dispatch_async( dispatch_get_main_queue(), ^
			{
				if ( error )
				{
					task.onError( result );
				}
				else
				{
					task.onSuccess( result );
				}
			} );
		}
		@catch ( NSException *exception )
		{
			dispatch_async( dispatch_get_main_queue(), ^
			{
				NSError *error = [NSError errorWithDomain:@"" code:1
					userInfo:[NSDictionary dictionaryWithObject:exception
						forKey:NSLocalizedFailureReasonErrorKey]];
				task.onError( error );
			} );
		}
		@finally
		{
			dispatch_semaphore_signal( jobSemaphore );
		}
	}
}


@end