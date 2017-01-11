//
//  ViewController.m
//  MqttProgressBar
//
//  Created by Covisint Admin on 1/6/17.
//  Copyright © 2017 Covisint Admin. All rights reserved.
//

#import "ViewController.h"
#import "MQTTClient.h"

@interface ViewController ()<MQTTSessionDelegate>

@end

@implementation ViewController
NSString *key;
MQTTSession *session;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc] init];
    transport.host = @"ssl://mqtt.covapp.io";
    transport.port = 8883;
    
    //username: 'ae987bd2-75c2-4453-8c25-bc588fb5a7f6',
    //password: '786420bf-abd5-4ee6-8e15-2dc81b5a3303'
    
    session = [[MQTTSession alloc] init];
    session.transport = transport;
    session.userName = @"bc582db8-0358-47f6-a561-981ec216bc74";
    session.password = @"73b3674b-c2eb-4e5d-abfb-1bab608fe743";
    session.clientId = @"aDeD383173bf4eee9D23";
    session.delegate = self;
    [session connectAndWaitToHost:@"mqtt.covapp.io" port:8883 usingSSL:YES timeout:30];
    //    [session connectAndWaitTimeout:30];  //this is part of the synchronous API
    
    [session subscribeToTopic:@"011a1a1a-b75f-43a0-957f-f29894edf54c" atLevel:2 subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss){
        if (error) {
            NSLog(@"Subscription failed %@", error.localizedDescription);
        } else {
            NSLog(@"Subscription sucessfull! Granted Qos: %@", gQoss);
        }
    }]; //
    
//    NSString *str = @"{\"messageId\":\"MSG12345\",\"deviceId\":\"e82a9878-489e-40d3-8d9c-c5bdcc7bbcdd\",\"eventTemplateId\":\"71a0d3cb-e228-47f6-b446-76a5beab2478\",\"message\":\"eyJFbmdpbmUgU3RhdHVzIjoiMCJ9\",\"encodingType\":\"BASE64\"}";
//    
//    [session publishAndWaitData:[str dataUsingEncoding:4]
//                        onTopic:@"cf2ec4c2-de54-4d30-9524-c661e182097a"
//                         retain:NO
//                            qos:MQTTQosLevelAtLeastOnce];

}


-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    NSLog(@"### %@", identifier);
    key = identifier;
    return YES;
}

- (void)newMessage:(MQTTSession *)session
              data:(NSData *)data
           onTopic:(NSString *)topic
               qos:(MQTTQosLevel)qos
          retained:(BOOL)retained
               mid:(unsigned int)mid {
    // this is one of the delegate callbacks
    
    NSString *msg = [[NSString alloc] initWithData:data encoding:4];
    NSLog(@"Message %@", msg);
    NSLog(@"inside message %@", topic);
    
    
    NSDictionary *json = [[NSDictionary alloc]initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]];
 
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:[json objectForKey:@"message"] options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", decodedString);
    
    
    NSDictionary *msgJson = [[NSDictionary alloc]initWithDictionary:[NSJSONSerialization JSONObjectWithData:decodedData options:0 error:nil]];
    NSString *value = @"";
    if ([key isEqualToString:@"oil"]) {
        value = [msgJson objectForKey:@"AnalogValue4"];
    } else if ([key isEqualToString:@"coolant"]){
        value = [msgJson objectForKey:@"AnalogValue2"];
    }  else if([key isEqualToString:@"tire"]){
        value = [msgJson objectForKey:@"AnalogValue6"];
    } else if([key isEqualToString:@"fuel"]){
        value = [msgJson objectForKey:@"AnalogValue3"];
    }
    
    NSDictionary *userInfo = @{@"msg" : value , @"title" : key };
    [[NSNotificationCenter defaultCenter] postNotificationName: @"MsgNotification" object:nil userInfo:userInfo];
    
}

- (void)connectionClosed:(MQTTSession *)session{
    
    MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc] init];
    transport.host = @"ssl://mqtt.covapp.io";
    transport.port = 8883;
    session = [[MQTTSession alloc] init];
    session.transport = transport;
    session.userName = @"bc582db8-0358-47f6-a561-981ec216bc74";
    session.password = @"73b3674b-c2eb-4e5d-abfb-1bab608fe743";
    session.clientId = @"aDeD383173bf4eee9D23";
    session.delegate = self;
    [session connectAndWaitToHost:@"mqtt.covapp.io" port:8883 usingSSL:YES timeout:30];
    //    [session connectAndWaitTimeout:30];  //this is part of the synchronous API
 
    [session subscribeToTopic:@"011a1a1a-b75f-43a0-957f-f29894edf54c" atLevel:2 subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss){
        if (error) {
            NSLog(@"Subscription failed %@", error.localizedDescription);
        } else {
            NSLog(@"Subscription sucessfull! Granted Qos: %@", gQoss);
        }
    }]; //
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    [segue destinationViewController].navigationItem.title = [key uppercaseString];
    
}
@end

