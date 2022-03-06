//
//  VocabBuilderDoodleContainerView.swift
//  LancerHacks Project 2022
//
//  Created by Rohan Sinha on 3/5/22.
//

import UIKit

class VocabBuilderDoodleContainerView: UIView {

    @IBOutlet weak var doodleView: VocabBuilderDoodleView!
    
    @IBAction func onErase_btnTap(_ sender: Any) {
        doodleView.resetDrawing()
    }
}
