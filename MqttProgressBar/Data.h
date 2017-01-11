//
//  Data.h
//  MqttProgressBar
//
//  Created by Covisint Admin on 1/6/17.
//  Copyright © 2017 Covisint Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject
@property NSMutableDictionary *Dict;
+(Data*)sharedMySingleton;
@end
