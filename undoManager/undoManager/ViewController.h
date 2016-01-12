//
//  ViewController.h
//  undoManager
//
//  Created by 路国良 on 16/1/11.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *label;

- (IBAction)Undo:(id)sender;

- (IBAction)Redo:(id)sender;
/*
 - (void)registerUndoWithTarget:(id)target selector:(SEL)selector object:(nullable id)anObject;
 */
- (IBAction)method1:(id)sender;
/*
 - (id)prepareWithInvocationTarget:(id)target;
 // called as:
 // [[undoManager prepareWithInvocationTarget:self] setFont:oldFont color:oldColor]
 // When undo is called, the specified target will be called with
 // [target setFont:oldFont color:oldColor]
 */
- (IBAction)method2:(id)sender;

@end

