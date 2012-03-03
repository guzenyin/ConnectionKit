//
//  CKSFTPConnection.h
//  Sandvox
//
//  Created by Mike on 25/10/2011.
//  Copyright 2011 Karelia Software. All rights reserved.
//

#import <Connection/Connection.h>
#import <CURLHandle/CURLHandle.h>


@interface CKCurlFTPConnection : NSObject <CKPublishingConnection>
{
 @private
    CURLHandle          *_handle;
    NSURLRequest        *_request;
    NSURLCredential     *_credential;
    NSOperationQueue    *_queue;
    NSString            *_currentDirectory;
    
    NSObject                        *_delegate;
    NSURLAuthenticationChallenge    *_challenge;
}

@property(nonatomic, copy) NSString *currentDirectory;

@end
