//
//  VocabWord.swift
//  LancerHacks Project 2022
//
//  Created by Rohan Sinha on 3/5/22.
//

import Foundation

class VocabWord {
    var word: String?
    var definition: String?
    var example: String?
    var inputType: WordInput
    
    enum WordInput {
        case doodled
        case text
    }
    
    init(inputType: WordInput) {
        self.inputType = inputType
    }
    
    init(word: String, definition: String, example: String) {
        self.word = word
        self.definition = definition
        self.example = example
        self.inputType = .text
    }
    
}
