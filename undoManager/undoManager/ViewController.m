//
//  ViewController.m
//  undoManager
//
//  Created by 路国良 on 16/1/11.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "ViewController.h"
@interface ViewController (){
    NSUndoManager*_undomanager;
    NSInteger _a;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _undomanager = [[NSUndoManager alloc] init];
    _a = 0;
}

- (IBAction)Undo:(id)sender {
    [_undomanager undo];
}

- (IBAction)Redo:(id)sender {
    [_undomanager redo];
 }

- (void)setMyObjectTitle:(NSString *)newTitle {

    NSString *currentTitle = self.label.text;
    if (newTitle != currentTitle) {
        [_undomanager registerUndoWithTarget:self
                                    selector:@selector(setMyObjectTitle:)
                                  object:self.label.text];
//        [_undomanager setActionName:NSLocalizedString(@"Title Change", @"title undo")];
        [self.label setText:newTitle];
        _a = [self.label.text integerValue];
     }
}

-(void)setMyLabelText:(NSString*)newText{
    NSString *currentTitle = self.label.text;
    if (newText != currentTitle) {
        [[_undomanager prepareWithInvocationTarget:self] setMyLabelText:self.label.text];
        self.label.text = newText;
        _a = [newText integerValue];
    }
    
}

- (IBAction)method1:(id)sender {
    _a++;
    [self setMyObjectTitle:[NSString stringWithFormat:@"%ld",(long)_a]];
}

- (IBAction)method2:(id)sender {
    _a++;
    [self setMyLabelText:[NSString stringWithFormat:@"%ld",(long)_a]];
   
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature * methodSignature  = [[self class] instanceMethodSignatureForSelector:aSelector];
    
    if (!methodSignature) {
        methodSignature = [NSMethodSignature signatureWithObjCTypes:"v@:*"];
    }
    NSLog(@"%s",__func__);
    return methodSignature;
}

//- (id)forwardingTargetForSelector:(SEL)aSelector{
//     NSLog(@"%s",__func__);
//    return nil;
//}
//
//- (void)forwardInvocation:(NSInvocation *)anInvocation{
//    NSLog(@"%s",__func__);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
