//
//  Created by somya on 10/7/12.
//
//


#import <Foundation/Foundation.h>
#import "Task.h"

@interface FetchImageTask : Task
{
	NSString *m_url;
	int m_index;
}
@property( nonatomic, copy ) NSString *url;
@property( nonatomic ) int index;

- (id)initWithUrl:(NSString *)url;

+ (id)objectWithUrl:(NSString *)url;


@end