//
//  FlaskServerClient.swift
//  LancerHacks Project 2022
//
//  Created by Rohan Sinha on 3/5/22.
//

import Foundation


class FlaskServerClient {
    static let boundary = "example.boundary.\(ProcessInfo.processInfo.globallyUniqueString)"
    static let fieldName = "upload_doodle"
    //CREDIT: https://gist.github.com/nnsnodnb/efd4635a6be2be41fdb67135d2dd9257
    
    class func getRandomWord(completionHandler: @escaping (RandomWordResponse?, Error?) -> Void) {
        guard let requestURL = URL(string: "http://localhost:5000/getRandomWord") else { return }
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            if let error = error {
                completionHandler(nil, error)
            }
            
            guard let data = data else { return }
            
            if let responseDataObject = try? JSONDecoder().decode(RandomWordResponse.self, from: data) {
                completionHandler(responseDataObject, error)
            }
        }
        
        task.resume()
    }
    
    class func getInfoForWord(word: String, completionHandler: @escaping (VocabWordInfoResponse?, Error?) -> Void) {
        guard let requestURL = URL(string: "http://localhost:5000/getWordFromInput/\(word)") else { return }
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            if let error = error {
                completionHandler(nil, error)
            }
            
            guard let data = data else { return }
            
            if let responseDataObject = try? JSONDecoder().decode(VocabWordInfoResponse.self, from: data) {
                completionHandler(responseDataObject, error)
            }
        }
        
        task.resume()
    }
    
    
    class func postHandwrittenImage(imageData: Data, completionHandler: @escaping (VocabWordInfoResponse?, Error?) -> Void) {
        guard let url = URL(string: "http://localhost:5000/getWordFromImg") else { return }
        var request = URLRequest(url: url)
        var boundary = UUID().uuidString
        
        request.httpMethod = "POST"
        request.addValue("image/png", forHTTPHeaderField: "Accept")
        request.addValue("image/png", forHTTPHeaderField: "Content-Type")
        
        request.setValue("image/png; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpBody = imageData

        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                return
            }
            
            if let responseObject = try? JSONDecoder().decode(VocabWordInfoResponse.self, from: data) {
                completionHandler(responseObject, nil)
            }
        }
        
        task.resume()
    }
    
}
