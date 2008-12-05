//
//  CKConnectionRegistry.m
//  Connection
//
//  Created by Mike on 05/12/2008.
//  Copyright 2008 Karelia Software. All rights reserved.
//

#import "CKConnectionRegistry.h"

#import "CKAbstractConnection.h"

#import "NSURL+Connection.h"


@implementation CKConnectionRegistry

+ (CKConnectionRegistry *)sharedConnectionRegistry
{
    static CKConnectionRegistry *result;
    if (!result)
    {
        result = [[CKConnectionRegistry alloc] init];
    }
    
    return result;
}

- (id)init
{
    if (self = [super init])
    {
        _connectionClassesByName = [[NSMutableDictionary alloc] init];
        _connectionClassesByURLScheme = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_connectionClassesByURLScheme release];
    [_connectionClassesByName release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Class Registration

- (void)registerClass:(Class <CKConnection>)connectionClass forURLScheme:(NSString *)URLScheme;
{
    [_connectionClassesByName setObject:connectionClass forKey:[connectionClass name]];
    
    if (URLScheme)
    {
        [_connectionClassesByURLScheme setObject:connectionClass forKey:URLScheme];
    }
}

- (Class <CKConnection>)connectionClassForURLScheme:(NSString *)URLScheme
{
    return [_connectionClassesByURLScheme objectForKey:URLScheme];
}

- (Class <CKConnection>)connectionClassForName:(NSString *)connectionName
{
    return [_connectionClassesByName objectForKey:connectionName];
}

#pragma mark -
#pragma mark Connection Creation

- (id <CKConnection>)connectionWithURL:(NSURL *)URL
{
    Class class = [self connectionClassForURLScheme:[URL scheme]];
    
    id <CKConnection> result = nil;
    if (class)
    {
        result = [[[class alloc] initWithURL:URL] autorelease];
    }
    
    return result;
}

- (id <CKConnection>)connectionWithName:(NSString *)name host:(NSString *)host port:(NSNumber *)port
{
    return [self connectionWithName:name host:host port:port user:nil password:nil error:NULL];
}

- (id <CKConnection>)connectionWithName:(NSString *)name host:(NSString *)host port:(NSNumber *)port user:(NSString *)username password:(NSString *)password error:(NSError **)error
{
    Class class = [self connectionClassForName:name];
    
    id <CKConnection> result = nil;
    if (class)
    {
        NSURL *URL = [[NSURL alloc] initWithScheme:[[class URLSchemes] objectAtIndex:0]
                                              host:host
                                              port:port
                                              user:username
                                          password:password];
        
        result = [[[class alloc] initWithURL:URL] autorelease];
        [URL release];
    }
                      
    if (!result && error)
	{
		NSError *err = [NSError errorWithDomain:CKConnectionErrorDomain
										   code:CKConnectionNoConnectionsAvailable
									   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:LocalizedStringInConnectionKitBundle(
																																@"No connection available for requested connection type", @"failed to find a connection class"),
												 NSLocalizedDescriptionKey,
												 [(*error) localizedDescription],
												 NSLocalizedRecoverySuggestionErrorKey,	// some additional context
												 nil]];
		*error = err;
	}
	
    return result;
}

@end
