//
//  ListCreatorDoodledWordCell.swift
//  LancerHacks Project 2022
//
//  Created by Rohan Sinha on 3/5/22.
//

import UIKit

class ListCreatorDoodledWordCell: UITableViewCell {

    @IBOutlet weak var detectedTextField: UITextField!
    @IBOutlet weak var drawingArea: ListCreatorDoodleView!
    
    
    func setDrawingAreaText(linesArray: [[CGPoint]]) {
        drawingArea.lineArray = linesArray
        drawingArea.setNeedsDisplay()
        guard let image = drawingArea.exportAsImage(), let imageData = image.pngData() else { return }
        FlaskServerClient.postHandwrittenImage(imageData: imageData) { responseObject, error in
            DispatchQueue.main.async {
                if let responseObject = responseObject {
                    self.detectedTextField.text = responseObject.word
                }
            }
        }
        //pass in image & update text
        //detectedTextField.text = "Detected word"
    }
}
