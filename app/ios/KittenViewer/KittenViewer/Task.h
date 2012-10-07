//
//  Created by somya on 10/6/12.
//
//


#import <Foundation/Foundation.h>

typedef void(^TaskOnSuccess)(id);
typedef void(^TaskOnError)(NSError *);

@interface Task : NSObject
{
	@private
	TaskOnSuccess m_onSuccess;
	TaskOnError m_onError;
}
@property( nonatomic, copy ) TaskOnSuccess onSuccess;
@property( nonatomic, copy ) TaskOnError onError;

- (id)initWithOnSuccess:(void (^)(id))onSuccess onError:(TaskOnError)onError;


- (id)run:(NSError **)error;




@end