//
//  RandomWordResponse.swift
//  LancerHacks Project 2022
//
//  Created by Rohan Sinha on 3/5/22.
//

import Foundation

struct RandomWordResponse: Codable {
    var partOfSpeech: String
    var definition: String
    var example: String
    var word: String
    
    enum CodingKeys: String, CodingKey {
        case partOfSpeech = "PoS"
        case definition
        case example
        case word
    }
}
