//
//  Created by somya on 10/7/12.
//
//


#import <Foundation/Foundation.h>
#import "Task.h"


typedef id(^TaskOnRun)(NSError **);


@interface BlockRunnerTask : Task
{
	TaskOnRun m_onRun;
}
@property( nonatomic, copy ) TaskOnRun onRun;


- (id)initWithOnRun:(TaskOnRun)onRun Complete:(TaskOnComplete)onComplete onError:(TaskOnError)onError;



@end