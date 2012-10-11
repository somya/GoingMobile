//
//  Created by somya on 10/7/12.
//
//


#import "FetchImageTask.h"

@implementation FetchImageTask
@synthesize url = m_url;
@synthesize index = m_index;
@synthesize m_connection;
@synthesize downloading = mDownloading;


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
    [m_fetchedData release], m_fetchedData = nil;
    [m_fetchError release], m_fetchError = nil;
    [m_connection release], m_connection = nil;
    [super dealloc];
}

- (id)run:(NSError **)error {
    if ([self isCancelled]) {
        return nil;
    }

    if (self.url) {
        NSURL *url1 = [NSURL URLWithString:m_url];
        NSData *data = [self fetchDataForURL:url1 error:NULL]; //[NSData dataWithContentsOfURL:url1];
        int i = 0;
        while (![self isCancelled] && (!data || 0 == data.length) && (i < 10)) {
            NSString *backupUrl = [NSString stringWithFormat:@"%@?image=%d", m_url, ++i];
            data = [self fetchDataForURL:url1 error:NULL];
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
    [m_fetchedData release];
    m_fetchedData = [[NSMutableData alloc] init];

    self.downloading = YES;
    m_connection = [[NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:aUrl] delegate:self] retain];
    while (self.downloading) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }

    if (outErr != NULL) {
        *outErr = m_fetchError;
    }
    NSData *fetchedData = [[m_fetchedData copy] autorelease];
    [m_fetchedData release], m_fetchedData = nil;
    [m_connection release], m_connection = nil;
    return fetchedData;
}

#pragma mark -
#pragma mark Connection Delegate
//============================================================================================================

- (void)imageDownloadComplete {
    self.downloading = NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (self.isCancelled) {
        NSLog(@"CANCELLED MID CONNECTION");
        [connection cancel];
        [self imageDownloadComplete];
    } else {
        [m_fetchedData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [m_fetchError release];
    m_fetchError = [error retain];
    [self imageDownloadComplete];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self imageDownloadComplete];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (self.isCancelled) {
        NSLog(@"CANCELLED BEFORE STREAM");
        [connection cancel];
        [self imageDownloadComplete];
    }
}

// --V-- example using cfnetwork.. not optimized like NSURLConnection
//- (NSData *)fetchDataForURL:(NSURL *)aUrl error:(NSError **)outErr {
//    if ([self isCancelled]) {
//        return nil;
//    }
//    // construct request
//    CFStringRef url = (CFStringRef) aUrl;
//    CFStringRef requestMethod = CFSTR("GET");
//    CFHTTPMessageRef req = CFHTTPMessageCreateRequest(kCFAllocatorDefault, requestMethod, url, kCFHTTPVersion1_1);
//    CFReadStreamRef readStream = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, req);
//
//    NSMutableData *imgData = nil;
//    if (![self isCancelled]) {
//        // open stream
//        if (!CFReadStreamOpen(readStream)) {
//            CFStreamError myErr = CFReadStreamGetError(readStream);
//            if (outErr != NULL) {
//                *outErr = [NSError errorWithDomain:NSStringFromClass([self class]) code:myErr.error userInfo:[NSDictionary dictionaryWithObject:@"Read stream error occurred" forKey:NSLocalizedDescriptionKey]];
//            }
//
//        } else {
//            // read data
//            UInt32 statusCode = 0;
//            CFHTTPMessageRef res = NULL;
//            CFStringRef statusLine = NULL;
//            if (![self isCancelled]) {
//                res = (CFHTTPMessageRef) CFReadStreamCopyProperty(readStream, kCFStreamPropertyHTTPResponseHeader);
//                statusLine = CFHTTPMessageCopyResponseStatusLine(res);
//                statusCode = (UInt32) CFHTTPMessageGetResponseStatusCode(res);
//
//                CFIndex numBytesRead;
//                imgData = [[[NSMutableData alloc] init] autorelease];
//                int myReadBufferSize = 1024;
//                do {
//                    UInt8 buf[myReadBufferSize]; // define myReadBufferSize as desired
//                    numBytesRead = CFReadStreamRead(readStream, buf, sizeof(buf));
//                    //            NSLog(@"     read %i bytes", (int) numBytesRead);
//                    if (numBytesRead > 0) {
//                        [imgData appendBytes:buf length:(NSUInteger) numBytesRead];
//                    } else if (numBytesRead < 0) {
//                        CFStreamError error = CFReadStreamGetError(readStream);
//                        if (outErr != NULL) {
//                            *outErr = [NSError errorWithDomain:NSStringFromClass([self class]) code:error.error userInfo:[NSDictionary dictionaryWithObject:@"Read stream error occurred" forKey:NSLocalizedDescriptionKey]];
//                        }
//                    }
//                } while (![self isCancelled] && (numBytesRead > 0));
//            }
//
//            if (![self isCancelled]) {
//                if (statusCode < 200 || statusCode >= 300) {
//                    if (outErr != NULL) {
//                        *outErr = [NSError errorWithDomain:NSStringFromClass([self class]) code:statusCode userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Read error: %@", [[[NSString alloc] initWithData:imgData encoding:NSUTF8StringEncoding] autorelease]] forKey:NSLocalizedDescriptionKey]];
//                    }
//                }
//            }
//
//            if (res != NULL) {
//                CFRelease(res);
//                res = NULL;
//            }
//            if (statusLine != NULL) {
//                CFRelease(statusLine);
//                res = NULL;
//            }
//        }
//    }
//
//    // clean up
//    if (readStream != NULL) {
//        CFReadStreamClose(readStream);
//        CFRelease(readStream);
//    }
//    if (req != NULL) {
//        CFRelease(req);
//    }
//    if ([self isCancelled]) {
//        imgData = nil;
//    }
//    return imgData;
//}


@end