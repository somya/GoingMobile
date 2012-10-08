//
//  Created by somya on 10/7/12.
//
//


#import <Foundation/Foundation.h>
#import "Task.h"

@interface FetchImageTask : Task
{
	NSString *m_url;
}
@property( nonatomic, copy ) NSString *url;

- (id)initWithUrl:(NSString *)url;

+ (id)objectWithUrl:(NSString *)url;


@end