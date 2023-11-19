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
enum FetchError: Error {
    case noData
    case invalidURL
    case decodingError
}
final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    func fetchImage<T: Decodable>(from url: URL, to imageView: UIImageView, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(FetchError.noData))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                if let imageUrlString = (decodedData as? Dog)?.message, let imageUrl = URL(string: imageUrlString) {
                    URLSession.shared.dataTask(with: imageUrl) { imageData, _, _ in
                        if let imageData = imageData, let image = UIImage(data: imageData) {
                            DispatchQueue.main.async {
                                imageView.image = image
                                completion(.success(decodedData))
                            }
                        }
                    }.resume()
                } else {
                    completion(.failure(FetchError.invalidURL))
                }
            } catch {
                completion(.failure(FetchError.decodingError))
            }
        }.resume()
    }
}
