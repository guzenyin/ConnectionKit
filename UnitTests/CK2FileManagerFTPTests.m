//
//  Created by Sam Deane on 06/11/2012.
//  Copyright 2012 Karelia Software. All rights reserved.
//

#import "CK2FileManagerGenericTests.h"

@interface CK2FileManagerFTPTests : CK2FileManagerGenericTests

@end

@implementation CK2FileManagerFTPTests

- (id)initWithInvocation:(NSInvocation *)anInvocation
{
    if ((self = [super initWithInvocation:anInvocation]) != nil)
    {
        self.responsesToUse = @"ftp";
    }

    return self;
}

@end