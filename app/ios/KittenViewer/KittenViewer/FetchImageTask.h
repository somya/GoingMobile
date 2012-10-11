//
//  Created by somya on 10/7/12.
//
//


#import <Foundation/Foundation.h>
#import "Task.h"

@interface FetchImageTask : Task <NSURLConnectionDataDelegate>
{
	NSString *m_url;
	int m_index;

    NSMutableData *m_fetchedData;
    NSError *m_fetchError;
    NSURLConnection *m_connection;
    BOOL mDownloading;
}
@property( nonatomic, copy ) NSString *url;
@property( nonatomic ) int index;
@property(nonatomic, retain) NSURLConnection *m_connection;
@property BOOL downloading;

- (id)initWithUrl:(NSString *)url;

+ (id)objectWithUrl:(NSString *)url;


@end