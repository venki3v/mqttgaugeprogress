//
//  Data.m
//  MqttProgressBar
//
//  Created by Covisint Admin on 1/6/17.
//  Copyright © 2017 Covisint Admin. All rights reserved.
//

#import "Data.h"

@implementation Data

@synthesize Dict;
static Data* _sharedMySingleton = nil;

+(Data*)sharedMySingleton
{
    @synchronized([Data class])
    {
        if (!_sharedMySingleton)
            _sharedMySingleton = [[self alloc] init];
        return _sharedMySingleton;
    }
    
    return nil;
}
@end

