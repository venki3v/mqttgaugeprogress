//
//  GauageViewController.m
//  MqttProgressBar
//
//  Created by Covisint Admin on 1/6/17.
//  Copyright © 2017 Covisint Admin. All rights reserved.
//

#import "GauageViewController.h"
#import "WMGaugeView.h"
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
@interface GauageViewController ()
@property (strong, nonatomic) IBOutlet WMGaugeView *vv;

@property (strong, nonatomic) IBOutlet WMGaugeView *gaugeView;
@end

@implementation GauageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification:) name:@"MsgNotification" object:nil];
    
    _gaugeView.style = [WMGaugeViewStyle3D new];
    _gaugeView.maxValue = 240.0;
    _gaugeView.showRangeLabels = YES;
    _gaugeView.rangeValues = @[ @50,                  @90,                @130,               @240.0              ];
    _gaugeView.rangeColors = @[ RGB(232, 111, 33),    RGB(232, 231, 33),  RGB(27, 202, 33),   RGB(231, 32, 43)    ];
    _gaugeView.rangeLabels = @[ @"VERY LOW",          @"LOW",             @"OK",              @"OVER FILL"        ];
    _gaugeView.unitOfMeasurement = @"psi";
    _gaugeView.showUnitOfMeasurement = YES;
    _gaugeView.scaleDivisionsWidth = 0.008;
    _gaugeView.scaleSubdivisionsWidth = 0.006;
    _gaugeView.rangeLabelsFontColor = [UIColor blackColor];
    _gaugeView.rangeLabelsWidth = 0.04;
    _gaugeView.rangeLabelsFont = [UIFont fontWithName:@"Helvetica" size:0.04];
    
    [_gaugeView setValue:100.0 animated:YES duration:1.6 completion:^(BOOL finished) {
        
    }];

}

- (void) receiveTestNotification:(NSNotification *) notification{

NSDictionary *userInfo = notification.userInfo;
NSString *value = [userInfo objectForKey:@"msg"];

    self.navigationController.navigationBar.topItem.title = [[userInfo objectForKey:@"title"] uppercaseString];
    
    [_gaugeView setValue:[value doubleValue] animated:YES duration:1.6 completion:^(BOOL finished) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
