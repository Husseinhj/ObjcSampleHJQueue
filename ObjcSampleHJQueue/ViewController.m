//
//  ViewController.m
//  ObjcSampleHJQueue
//
//  Created by Hussein Habibi on 6/21/1396 AP.
//  Copyright © 1396 AP Hussein.Juybari. All rights reserved.
//

#import "ViewController.h"
#import "TimerHJQueue/HJQueue.h"

@interface ViewController ()<HJQueueDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *timerIntervalPickerView;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;
@property (strong, nonatomic) HJQueue *queue;
@property (nonatomic) NSInteger counter;
@property (weak, nonatomic) IBOutlet UITextField *maxTextField;
@property (weak, nonatomic) IBOutlet UISwitch *timerDequeueSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *infinitLengthSwitch;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _timerIntervalPickerView.delegate = self;
    _timerIntervalPickerView.dataSource = self;
    
    _queue = [[HJQueue alloc] initInfiniteLength];
    [_queue setDelegate:self];

    [_timerDequeueSwitch setOn:YES];
    [_infinitLengthSwitch setOn:YES];
    [_maxTextField setEnabled:NO];
}

- (IBAction)timerDequeueStateSwitchStateChanged:(id)sender {
    UISwitch *timerSwitch = (UISwitch *) sender;
    
    [_timerIntervalPickerView setUserInteractionEnabled:timerSwitch.isOn];
    
    if (!timerSwitch.isOn) {
        [_queue stopTimerInterval];
    } else {
        NSInteger row = [_timerIntervalPickerView selectedRowInComponent:0];
        [_queue setQueueTimeInterval:(row *2)+2];
    }
}

- (IBAction)infiniteLengthSwitchStateChanged:(id)sender {
    UISwitch *infSwitch = (UISwitch *) sender;
    
    [_queue setInfiniteLength:infSwitch.isOn];
    [_maxTextField setEnabled:!infSwitch.isOn];
}

- (IBAction)queueClicked:(id)sender {
    
    if (!_infinitLengthSwitch.isOn) {
        if ([_maxTextField.text length] > 0) {
            NSInteger max = [_maxTextField.text integerValue];
            [_queue setMax:max];
        }
    }
    
    bool state = [_queue enqueue:@(++_counter)];
    
    if (state)
        _logTextView.text = [NSString stringWithFormat:@"%@ Queue value : %zd \n",_logTextView.text,_counter];
}
- (IBAction)dequeueClicked:(id)sender {
    NSString *obj = [_queue dequeue];
    
    if (obj) {
        _logTextView.text = [NSString stringWithFormat:@"%@ Dequeue with value : %@ \n",_logTextView.text,obj];
    }
}

-(void) dequeueWithTick:(id)object{
    _logTextView.text = [NSString stringWithFormat:@"%@ Dequeue periodic ('%.01f') with value : %@ \n",_logTextView.text,[_queue queueTimeInterval],object];
}

#pragma mark - pickerView delegates

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 20;
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%zd",(row*2)+2];
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [_queue setQueueTimeInterval:(row*2)+2];
}

@end
