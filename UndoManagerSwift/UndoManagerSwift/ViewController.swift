//
//  ViewController.swift
//  UndoManagerSwift
//
//  Created by 路国良 on 16/1/15.
//  Copyright © 2016年 baofoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    var temporary:Int32 = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        undoManager!.levelsOfUndo = 0
        // Do any additional setup after loading the view, typically from a nib.
    }
    func setMyobjectTitle(newTitle:String){
        let currebTitle:String = label.text!
        if currebTitle != newTitle{
           undoManager!.registerUndoWithTarget(self, selector: Selector("setMyobjectTitle:"), object: label.text)
        }
        label.text = newTitle
        temporary = Int32(label.text!)!
    }
    func setMyLabelText(newTitle:String){
        let currebTitle:String = label.text!
        if currebTitle != newTitle{
            undoManager?.prepareWithInvocationTarget(self).setMyLabelText(label.text!)
        }
        label.text = newTitle
        temporary = Int32(label.text!)!
    }

    @IBAction func method1(sender: AnyObject) {
        ++temporary
        setMyobjectTitle(String(temporary))
    }
    
    @IBAction func method2(sender: AnyObject) {
        ++temporary
        setMyLabelText(String(temporary))
    }
    
    @IBAction func undo(sender: AnyObject) {
        undoManager?.undo()
    }
    
    @IBAction func redo(sender: AnyObject) {
        undoManager?.redo()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        undoManager?.removeAllActionsWithTarget(self)
        undoManager?.registerUndoWithTarget(self, selector: Selector("setMyobjectTitle:"), object: label.text)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

