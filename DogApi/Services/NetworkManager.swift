//
//  NetworkManager.swift
//  DogApi
//
//  Created by John Doe on 15.11.2023.
//

import Foundation
import UIKit

enum Link {
    case baseURL
    var url: URL {
        switch self {
        case .baseURL:
            return URL(string: "https://dog.ceo/api/breeds/image/random")!
        }
    }
}
final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    func fetchDogImage(from url: URL, to image: UIImageView) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "no error description")
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let dog = try jsonDecoder.decode(Dog.self, from: data)
                guard let imageUrl = URL(string: dog.message) else {
                    print("Invalid image URL")
                    return
                }
                URLSession.shared.dataTask(with: imageUrl) { imageData, _, _ in
                    if let imageData = imageData {
                        DispatchQueue.main.async {
                            image.image = UIImage(data: imageData)
                        }
                    }
                }.resume()
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
