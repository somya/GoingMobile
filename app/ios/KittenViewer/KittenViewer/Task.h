//
//  Created by somya on 10/6/12.
//
//


#import <Foundation/Foundation.h>

typedef void(^TaskOnComplete)(id);
typedef void(^TaskOnError)(NSError *, BOOL cancelled);

@interface Task : NSObject
{
	@private
	TaskOnComplete m_onComplete;
	TaskOnError m_onError;
    BOOL mCancelled;
}

@property( nonatomic, copy ) TaskOnComplete onComplete;
@property( nonatomic, copy ) TaskOnError onError;
@property(getter=isCancelled) BOOL cancelled;

- (id)initWithOnComplete:(TaskOnComplete)onComplete onError:(TaskOnError)onError;
- (id)run:(NSError **)error;


@end