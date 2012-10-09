//
//  Created by somya on 10/7/12.
//
//


#import "FetchImageTask.h"

@implementation FetchImageTask
@synthesize url = m_url;
@synthesize index = m_index;

- (id)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        self.url = url;
    }

    return self;
}

+ (id)objectWithUrl:(NSString *)url {
    return [[[FetchImageTask alloc] initWithUrl:url] autorelease];
}

- (void)dealloc {
    [m_url release];
    [super dealloc];
}

- (id)run:(NSError **)error {

    if ([self isCancelledAtLocation:@"Start run"]) {
        return nil;
    }

    if (self.url) {
        NSURL *url1 = [NSURL URLWithString:m_url];
        NSData *data = [self fetchDataForURL:url1 error:NULL]; //[NSData dataWithContentsOfURL:url1];
//        NSLog(@"[%i] fetched %i bytes from url: %@", self.index, data.length, self.url);
        int i = 0;
        while (![self isCancelledAtLocation:@"Fetch backup"] && (!data || 0 == data.length) && (i < 10)) {
            NSString *backupUrl = [NSString stringWithFormat:@"%@?image=%d", m_url, ++i];
            data = [self fetchDataForURL:url1 error:NULL];
//            NSLog(@"BACKUP [%i] fetched %i bytes from url: %@", self.index, data.length, backupUrl);
        }
        UIImage *image = nil;
        if (![self isCancelledAtLocation:@"convert to UIImage"]) {
            image = [UIImage imageWithData:data];
        }
        return image;
    }
    return nil;
}


- (NSData *)fetchDataForURL:(NSURL *)aUrl error:(NSError **)outErr {
    if ([self isCancelledAtLocation:@"start fetch data"]) {
        return nil;
    }
    // construct request
    CFStringRef url = (CFStringRef) aUrl;
    CFStringRef requestMethod = CFSTR("GET");
    CFHTTPMessageRef req = CFHTTPMessageCreateRequest(kCFAllocatorDefault, requestMethod, url, kCFHTTPVersion1_1);
    CFReadStreamRef readStream = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, req);

    NSMutableData *imgData = nil;
    if (![self isCancelledAtLocation:@"Before stream open"]) {
        // open stream
        if (!CFReadStreamOpen(readStream)) {
            CFStreamError myErr = CFReadStreamGetError(readStream);
            if (outErr != NULL) {
                *outErr = [NSError errorWithDomain:NSStringFromClass([self class]) code:myErr.error userInfo:[NSDictionary dictionaryWithObject:@"Read stream error occurred" forKey:NSLocalizedDescriptionKey]];
            }

        } else {
            // read data
            UInt32 statusCode = 0;
            CFHTTPMessageRef res = NULL;
            CFStringRef statusLine = NULL;
            if (![self isCancelledAtLocation:@"Before read"]) {
                res = (CFHTTPMessageRef) CFReadStreamCopyProperty(readStream, kCFStreamPropertyHTTPResponseHeader);
                statusLine = CFHTTPMessageCopyResponseStatusLine(res);
                statusCode = (UInt32) CFHTTPMessageGetResponseStatusCode(res);

                CFIndex numBytesRead;
                imgData = [[[NSMutableData alloc] init] autorelease];
                int myReadBufferSize = 1024;
                do {
                    UInt8 buf[myReadBufferSize]; // define myReadBufferSize as desired
                    numBytesRead = CFReadStreamRead(readStream, buf, sizeof(buf));
                    //            NSLog(@"     read %i bytes", (int) numBytesRead);
                    if (numBytesRead > 0) {
                        [imgData appendBytes:buf length:(NSUInteger) numBytesRead];
                    } else if (numBytesRead < 0) {
                        CFStreamError error = CFReadStreamGetError(readStream);
                        if (outErr != NULL) {
                            *outErr = [NSError errorWithDomain:NSStringFromClass([self class]) code:error.error userInfo:[NSDictionary dictionaryWithObject:@"Read stream error occurred" forKey:NSLocalizedDescriptionKey]];
                        }
                    }
                } while (![self isCancelledAtLocation:@"during read"] && (numBytesRead > 0));
            }

            if (![self isCancelledAtLocation:@"After read"]) {
                if (statusCode < 200 || statusCode >= 300) {
                    if (outErr != NULL) {
                        *outErr = [NSError errorWithDomain:NSStringFromClass([self class]) code:statusCode userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Read error: %@", [[[NSString alloc] initWithData:imgData encoding:NSUTF8StringEncoding] autorelease]] forKey:NSLocalizedDescriptionKey]];
                    }
                }
            }

            if (res != NULL) {
                CFRelease(res);
                res = NULL;
            }
            if (statusLine != NULL) {
                CFRelease(statusLine);
                res = NULL;
            }
        }
    }

    // clean up
    if (readStream != NULL) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (req != NULL) {
        CFRelease(req);
    }
    if ([self isCancelledAtLocation:@"Before return of data"]) {
        imgData = nil;
    }
    return imgData;
}

- (BOOL)isCancelledAtLocation:(NSString *)loc {
    BOOL b = [self isCancelled];
    if (b) {
        NSLog(@"%@: cancelled",loc);
    }
    return b;
}

@end