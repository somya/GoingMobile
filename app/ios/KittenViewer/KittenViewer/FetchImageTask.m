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

    if ([self isCancelled]) {
        return nil;
    }

    if (self.url) {
        NSURL *url1 = [NSURL URLWithString:m_url];
        NSData *data = [self fetchDataForURL:url1 error:NULL]; //[NSData dataWithContentsOfURL:url1];
//        NSData *data = [NSData dataWithContentsOfURL:url1];
//        NSLog(@"[%i] fetched %i bytes from url: %@", self.index, data.length, self.url);
        int i = 0;
        while (![self isCancelled] && (!data || 0 == data.length) && (i < 10)) {
            NSString *backupUrl = [NSString stringWithFormat:@"%@?image=%d", m_url, ++i];
//            data = [NSData dataWithContentsOfURL:url1];
            data = [self fetchDataForURL:url1 error:NULL];
//            NSLog(@"BACKUP [%i] fetched %i bytes from url: %@", self.index, data.length, backupUrl);
        }
        UIImage *image = nil;
        if (![self isCancelled]) {
            image = [UIImage imageWithData:data];
        }
        return image;
    }
    return nil;
}


- (NSData *)fetchDataForURL:(NSURL *)aUrl error:(NSError **)outErr {
    if ([self isCancelled]) {
        return nil;
    }
    // construct request
    CFStringRef url = (CFStringRef) aUrl;
    CFStringRef requestMethod = CFSTR("GET");
    CFHTTPMessageRef req = CFHTTPMessageCreateRequest(kCFAllocatorDefault, requestMethod, url, kCFHTTPVersion1_1);
    CFReadStreamRef readStream = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, req);

    NSMutableData *imgData = nil;
    if (![self isCancelled]) {
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
            if (![self isCancelled]) {
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
                } while (![self isCancelled] && (numBytesRead > 0));
            }

            if (![self isCancelled]) {
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
    if ([self isCancelled]) {
        imgData = nil;
    }
    return imgData;
}


@end