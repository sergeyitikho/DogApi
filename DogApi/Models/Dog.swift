//
//  Dog.swift
//  DogApi
//
//  Created by John Doe on 10.11.2023.
//

import Foundation

struct Dog: Decodable {
    let message: String
    let status: String
    
    init(message: String, status: String) {
        self.message = message
        self.status = status
    }
    
    init(dogsData: [String: Any]) {
        message = dogsData["message"] as? String ?? ""
        status = dogsData["status"] as? String ?? ""
    }
}

