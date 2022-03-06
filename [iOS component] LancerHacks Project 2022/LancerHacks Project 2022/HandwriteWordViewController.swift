//
//  HandwriteWordViewController.swift
//  LancerHacks Project 2022
//
//  Created by Rohan Sinha on 3/5/22.
//

import UIKit

class HandwriteWordViewController: UIViewController {
    
    @IBOutlet weak var handwriteDrawingArea: ListCreatorDoodleView!
    
    var linesArrayForDrawingArea: [[CGPoint]] = []
    var onHandwriteCompletion: (([[CGPoint]]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handwriteDrawingArea.lineArray = linesArrayForDrawingArea
        handwriteDrawingArea.setNeedsDisplay()
    }
    
    @IBAction func onEraseBtnTap(_ sender: Any) {
        handwriteDrawingArea.resetDrawing()
    }
    
    @IBAction func onUndoBtnTap(_ sender: Any) {
        handwriteDrawingArea.undoManager?.undo()
    }
    
    @IBAction func onRedoBtnTap(_ sender: Any) {
        handwriteDrawingArea.undoManager?.redo()
    }
    
    @IBAction func onFinishBtnTap(_ sender: Any) {
        onHandwriteCompletion?(handwriteDrawingArea.lineArray)
        navigationController?.popViewController(animated: true)
    }
    
    
}
